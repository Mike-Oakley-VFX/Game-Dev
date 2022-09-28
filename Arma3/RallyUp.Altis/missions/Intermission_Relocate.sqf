
/*
	Author: CodeRedFox
	Uses: Relocate mission to move all players to another part of the map
	Note: 
	Usage: [position] execVM "missions\Intermission_Relocate.sqf"
	Examples:[position player] execVM "missions\Intermission_Relocate.sqf"
	
*/ diag_log format ["RallyUpDiag Starting : Intermission_Relocate.sqf | %1 | %2",time,serverTime];
if (!isServer) exitwith {};

// Variables
	_Position = _this select 0;
	_Task_Status = "Canceled";
	_countdown = time+RALLYUP_TimeOutSec;
	_iscargo =[];
	
	_mapdistance = (RALLYUP_WorldSizeCenter select 1);
	
	_TransportationHelogroup = createGroup (RallyUpBluFor select 0);
	
// Tasking Locations
	
	[(RallyUpOpFor select 0),100] spawn RALLYUP_fnc_task_CleanUp;

	_Task_LocationPickup = [_Position,0,500,RALLYUP_LocationsPoints,10] call RALLYUP_fnc_position_Locations;
		if (_Task_LocationPickup distance2d _Position > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};	// Will cancel if the task to to far away	
		_Task_LocationName = [_Task_LocationPickup] call RALLYUP_fnc_position_LocationsName;
	_Task_LocationDrop = [_Position,RALLYUP_maxDistance,RALLYUP_maxDistance*5,RALLYUP_LocationsPoints,10] call RALLYUP_fnc_position_Locations;
		_Task_LocationNameDrop = [_Task_LocationDrop] call RALLYUP_fnc_position_LocationsName;
	
	_SpawnPosition = [_Task_LocationPickup, 200, (random 360)] call BIS_fnc_relPos;

	
// Starting Friendlies
	_pickedvehicletype = (((RALLYUP_Groups_FriendlyHelicopters select 2) select 1) select floor random count ((RALLYUP_Groups_FriendlyHelicopters select 2) select 1));
	_TransportationHelo = [_SpawnPosition, (random 360), _pickedvehicletype,_TransportationHelogroup] call bis_fnc_spawnvehicle;
	_TransportationHeloVeh =  _TransportationHelo select 0;
	_TransportationHeloGroup =  _TransportationHelo select 2;
		
	TransportTakeoff = false;
	_TransportationHeloVeh addAction ["<t color=RALLYUP_COLORHEX  t size='2'>Take off</t>",
		{
			params ["_target"];
			TransportTakeoff = true;
			removeAllActions _target;			
		}
	];
	
	[_TransportationHeloVeh] spawn RALLYUP_fnc_task_OpenDoors;
		

// Diary
	_taskInformation = [_TransportationHeloVeh] call RALLYUP_fnc_text_GetInfo;
	
	
	_taskTitle = "Transportation";
	_taskPosition = _Task_LocationPickup;
	_taskType = "takeoff";
	_taskDescription = str formatText ["
		<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Support_ca.paa' width='50px'/>
		<img image='%3' width='50px'/>
		<br/>
		<br/>O P S E C : -----------------
		<br/>
		<br/>	All groups move to and wait for transportation near %1.
		<br/>	The next AO will be near %4
		<br/>
		<br/>
		<br/>O B J E C T I V E : -----------------
		<br/>
		<br/>	- All groups board the %2
		<br/>
		<br/>
		<br/>TIPS:
		<br/>	
		<br/>			
	",_Task_LocationName,_taskInformation select 1,_taskInformation select 3,_Task_LocationNameDrop];	
	
	_Task_Name = str formatText ["%1%2",_taskType,time];
	_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;

	{playsound "Transport_Inbound"} foreach Allplayers;
	
// Chopper Waypoint 01
	_chopperWaypoint_01 = _TransportationHeloGroup addWaypoint [_Task_LocationPickup,0];
	_chopperWaypoint_01 setWaypointType "Move";
	_chopperWaypoint_01 setWaypointBehaviour "CARELESS";
	_chopperWaypoint_01 setWaypointStatements ["true", "
		{(vehicle _x) land 'LAND'} foreach thisList;		
		
	"];

	// Transportations here
	waitUntil {	
		
		sleep 5;
		
		if ( TransportTakeoff == true) exitwith {			
			TransportTakeoff = false;
			{playsound "Transport_Inbound"} foreach Allplayers;			
			
			[_Task_Mission,'land'] call BIS_fnc_taskSetType;
			[_Task_Mission,_Task_LocationDrop] call BIS_fnc_taskSetDestination;
			
			_chopperWaypoint_02 = _TransportationHeloGroup addWaypoint [_Task_LocationDrop,0];
			_chopperWaypoint_02 setWaypointType "UNLOAD";
			_chopperWaypoint_02 setWaypointBehaviour "CARELESS";
							
			_chopperWaypoint_02 setWaypointStatements ["true", "
				{(vehicle _x) land 'LAND'} foreach thisList;
				{
					{
						unassignVehicle _x;
						[_x] ordergetin false;
						doGetOut _x;						
					} forEach (assignedcargo vehicle _x);
				} forEach thisList;
				
			"];			
			true
		};		
		false	
	};
		
	waituntil {	
		sleep 5;
		_iscargo = fullCrew [_TransportationHeloVeh, "cargo"];
		hint format ["%1",count _iscargo];
		if ( count _iscargo == 0) exitwith {

			_DeSpawnPosition = [_Task_LocationDrop, 2500, (random 360)] call BIS_fnc_relPos;
			_chopperWaypoint_03 = _TransportationHeloGroup addWaypoint [_DeSpawnPosition, 500];
			_chopperWaypoint_03 setWaypointType "MOVE";
			_chopperWaypoint_03 setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
			"];
		
			
			{playsound "Transport_accomplished"} foreach Allplayers;_Task_Status = "Succeeded";
					
			[(RallyUpBluFor select 0),_Task_LocationDrop] call RALLYUP_fnc_task_UpdateSpawns;
				true;
		};
				
		if (!alive _TransportationHeloVeh) exitWith {_Task_Status = "Failed";true};
			false
	};
		

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status =  "Succeeded","Failed","Canceled"
	
	sleep 5;
	if(true) exitWith {[_Task_Mission] call BIS_fnc_deleteTask};
