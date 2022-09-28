/*
	Author: CodeRedFox
	Uses: Creates support mission
	Note: 
	Usage: [position player] execVM "missions\Secondary_ResupplyAirDrop.sqf"
	Examples:

*/ diag_log format ["RallyUpDiag Starting : Secondary_ResupplyAirDrop.sqf | %1",_this select 0];
if (!isServer) exitwith {};
	
	
	// Variables
		private["_supplyHelo","_SupplyHeloVeh","_para","_Reward_Cargo","_ammocrateSmoke"];
		
		_currentLocation = _this select 0;				
		_Task_Status = "Canceled";
		RALLYUP_minDistance = 100;
	
				
		_distance = 1000;
		_flyheight = 300;
		
		_supplyHelogroup = createGroup (RallyUpBluFor select 0);		
		_dropAmount = count allplayers*2;
				
	// Find Tasking Location	
		_TaskLocation = [_currentLocation,RALLYUP_minDistance,RALLYUP_maxDistance,RALLYUP_LocationsPoints,7] call RALLYUP_fnc_position_Locations; 
		sleep 5;
			
	// Diary	
		_taskTitle = "Secondary - AirDrop";
		_taskPosition = _TaskLocation;
		_taskType = "Support";
		_taskDescription = str formatText ["
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	Move to %1 to start the air drop.
			<br/>			
			<br/>
			<br/>T I P S : -----------------
			<br/>	
		",_TaskLocation];	
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,2],0,1,true,_taskType] call BIS_fnc_taskCreate;
		
	// Task Event	
		_countdown = time+RALLYUP_TimeOutSec;	
		waituntil {
			sleep 2;					
			if (( time > _countdown)) exitWith {_Task_Status = "Canceled";true};			
			if ({_x distance _taskPosition < 100} count allplayers > 0) exitWith {
				// Spawn Helicopter
				_SpawnPosition = [_currentLocation, 200, (random 360)] call BIS_fnc_relPos;				
				_DeSpawnPosition = [_currentLocation, 500, (random 360)] call BIS_fnc_relPos;				
				_DropLocation = _TaskLocation;
						
				_SpawnPositionWP = [_SpawnPosition select 0,_SpawnPosition select 1,_flyheight];				
				_DeSpawnPositionWP = [_DeSpawnPosition select 0,_DeSpawnPosition select 1,_flyheight];				
				_DropLocationWP = [_DropLocation select 0,_DropLocation select 1,_flyheight];					
				
				_pickedvehicletype = (((RALLYUP_Groups_FriendlyHelicopters select 2) select 1) select floor random count ((RALLYUP_Groups_FriendlyHelicopters select 2) select 1));
				_supplyHelo = [_SpawnPositionWP, (random 360), _pickedvehicletype,_supplyHelogroup] call bis_fnc_spawnvehicle;
				_SupplyHeloVeh = _supplyHelo select 0;	
				_SupplyHeloVeh flyinheight _flyheight;		
			
				_chopperWaypoint_1 = (_supplyHelo select 2) addWaypoint [_DropLocationWP,100];
				_chopperWaypoint_2 = (_supplyHelo select 2) addWaypoint [_DeSpawnPositionWP, 500];
		
				_chopperWaypoint_1 setWaypointBehaviour "CARELESS";	
				_chopperWaypoint_2 setWaypointBehaviour "CARELESS";
			
				_chopperWaypoint_1 setWaypointType "MOVE";			
				_chopperWaypoint_2 setWaypointType "MOVE";
		
				_chopperWaypoint_2 setWaypointStatements ["true", "
					{deleteVehicle vehicle _x} forEach thislist;
					{deleteVehicle _x} forEach thislist;
					deleteGroup (group this);
				"];	
				
				_ammocrateSmoke = "SmokeShellGreen" createVehicle _TaskLocation;
				_ammocrateSmoke setVelocity [random 5, random 5, 20];
				true;			
			};					
		};				
		
		waituntil {	
	
			sleep 2;
			
			if (( time > _countdown)) exitWith {_Task_Status = "Canceled";true};	
			if ((getpos _SupplyHeloVeh) distance2D _TaskLocation < 500) exitWith {
				for "_i" from 1 to _dropAmount do {	
					_CargoArray = (RALLYUP_AmmoCrates+RALLYUP_ResupplyVehicles) select floor random count (RALLYUP_AmmoCrates+RALLYUP_ResupplyVehicles);
					_Reward_Cargo = _CargoArray createVehicle getPos _SupplyHeloVeh;
					_Reward_Cargo setDir (getdir _SupplyHeloVeh);
					_Reward_Cargo setPosATL (_SupplyHeloVeh modelToWorld[0,-20,0]);
					[_SupplyHeloVeh,_Reward_Cargo,-20] call RALLYUP_fnc_task_inheritvelocity;
					_para = "B_Parachute_02_F" createVehicle getPos _SupplyHeloVeh;	
					_para setDir (getdir _Reward_Cargo);
					_para setPosATL (_Reward_Cargo modelToWorld[0,0,0]);		
					_Reward_Cargo attachTo [_para,[0,0,1]];	
						sleep 2;		
				};								
				_Task_Status = "Succeeded";
					true;
			};		
		};
		
		
		
		
// Task End Events
[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"

if(true) exitWith {};
		
		
		
		
		
		