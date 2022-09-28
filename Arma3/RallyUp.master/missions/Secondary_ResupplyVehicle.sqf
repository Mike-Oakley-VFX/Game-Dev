
/*
	Author: CodeRedFox
	Uses: Creates support mission
	Note: 
	Usage: [position player] execVM "missions\Secondary_ResupplyVehicle.sqf"
	Examples:

*/ diag_log format ["RallyUpDiag Starting : Secondary_ResupplyVehicle.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	
	// Variables
		_currentLocation = getMarkerPos "respawn_West";
				
		_Task_Status = "Canceled";
						
		_minDistance = 100;
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);		
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_distance = 1000;
		_NewLocation = _currentLocation;
		
	// Find Tasking Location
		_TaskLocation = [_currentLocation,10,_minDistance] call RALLYUP_fnc_position_LocationsLocal;

	// Create Helicopter
		_SpawnPosition = [_currentLocation, 2500, (random 360)] call BIS_fnc_relPos;
		_DeSpawnPosition = [_currentLocation, 5000, (random 360)] call BIS_fnc_relPos;
		
		_supplyHelogroup = createGroup (RallyUpBluFor select 0);
		_pickedvehicletype = (((RALLYUP_Groups_FriendlyHelicopters select 2) select 1) select floor random count ((RALLYUP_Groups_FriendlyHelicopters select 2) select 1));
		_supplyHelo = [_SpawnPosition, (random 360), _pickedvehicletype,_supplyHelogroup] call bis_fnc_spawnvehicle;
		_SupplyHeloVeh = _supplyHelo select 0;

		_VehicleDropArray = RALLYUP_ResupplyVehicles select floor random count RALLYUP_ResupplyVehicles;
		_Picked_VehicleDrop = _VehicleDropArray createVehicle getPos _SupplyHeloVeh;
		_SupplyHeloVeh setSlingLoad _Picked_VehicleDrop;

		
		_chopperWaypoint_1 = (_supplyHelo select 2) addWaypoint [_currentLocation,1000];
		_chopperWaypoint_2 = (_supplyHelo select 2) addWaypoint [_DeSpawnPosition, 500];
		
		_chopperWaypoint_1 setWaypointBehaviour "CARELESS";	
		_chopperWaypoint_2 setWaypointBehaviour "CARELESS";
		
		_chopperWaypoint_1 setWaypointType "UNHOOK";		
		_chopperWaypoint_2 setWaypointType "MOVE";
		_chopperWaypoint_2 setWaypointStatements ["true", "
			{deleteVehicle vehicle _x} forEach thislist;
			{deleteVehicle _x} forEach thislist;
			deleteGroup (group this);
		"];	
			
		
	// Diary
	
		_taskInformation = [_SupplyHeloVeh] call RALLYUP_fnc_text_GetInfo;
		_taskInformationVeh = [_Picked_VehicleDrop] call RALLYUP_fnc_text_GetInfo;
		_taskTitle = "Secondary Resupply - Vehicle";
		_taskPosition = _currentLocation;
		_taskType = "Support";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Support_ca.paa' width='50px'/>
			<img image='%2' width='100px'/>
			<img image='%3' width='100px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	Stand by, a %1 in on route to a drop location.
			<br/>			
			<br/>
			<br/>T I P S : -----------------
			<br/>	The task will start where ever the cargo lands.
		",_taskInformation select 1,_taskInformation select 2,_taskInformationVeh select 2];	
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,2],0,1,true,_taskType] call BIS_fnc_taskCreate;
	

	
	// Create Enemy's
		// [_currentLocation,1] spawn RALLYUP_fnc_create_reinforcements;
	
	{playsound "Supply_Inbound"} foreach Allplayers;
	// ["Supply_Inbound","playSound",true] call BIS_fnc_MP;
	// [{playSound "Supply_Inbound";}, "BIS_fnc_spawn",true] call BIS_fnc_MP;
	
		
		
	// Task Event
		[_Task_Name,_currentLocation] call BIS_fnc_taskSetDestination;
		_countdown = time+RALLYUP_TimeOutSec;
		waituntil {
			
			sleep 1;			
			if (( time > _countdown) or (getpos _Picked_VehicleDrop select 2 < 10) or (!alive _SupplyHeloVeh) or (!alive _Picked_VehicleDrop)) exitWith {true};		
			
		};	
		
		sleep 5;
			_newpos = [getpos _Picked_VehicleDrop select 0,getpos _Picked_VehicleDrop select 1,5];
								
			[_Task_Name,_newpos] call BIS_fnc_taskSetDestination;
	
		
		_countdown = time+RALLYUP_TimeOutSec;
		waituntil {
			sleep 5;
						
			_distance = ([AllPlayers] call RALLYUP_fnc_Position_3dCenter) distance (getpos _Picked_VehicleDrop);
			if (_distance < 100) exitWith {_Task_Status = "Succeeded";true};
			if ((!alive _SupplyHeloVeh) or (!alive _Picked_VehicleDrop)) then {
				{deleteVehicle vehicle _x} forEach (units _supplyHelogroup);
				{deleteVehicle _x} forEach (units _supplyHelogroup);
				deleteGroup _supplyHelogroup;		
				_Task_Status = "Failed";
				deletevehicle _Picked_VehicleDrop;
				true
			};
			
			if ((surfaceIsWater (getpos _Picked_VehicleDrop)) or (_distance > _maxDistance) or ( time > _countdown)) exitWith {
				_Task_Status = "Canceled";
				deletevehicle _Picked_VehicleDrop;
				true
			};
				false
		};

		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
