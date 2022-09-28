
/*
	Author: CodeRedFox
	Uses: Creates spawn assets
	Note: 
	Usage: [position player] execVM "missions\Intermission_SpawnSupplies.sqf"
	Examples:

*/ diag_log format ["RallyUpDiag Starting : Secondary_ResupplyVehicle.sqf | %1",_this select 0];
if (!isServer) exitwith {};
	
	// Variables
		_currentLocation = getMarkerPos "respawn_West";
		
	// Find safe spawn Location
		_AmmoSpawnPosition = [_currentLocation, 50, 250, 2, 0, 45, 0] call BIS_fnc_findSafePos;

	// Create Spawn Ammo 
		_AmmoCrateArray = RALLYUP_AmmoCrates select floor random count RALLYUP_AmmoCrates;		
		_Picked_AmmoCrate = _AmmoCrateArray createVehicle _AmmoSpawnPosition;		
		["AmmoboxInit",[_Picked_AmmoCrate,true]] call BIS_fnc_arsenal;
		
	// Create Spawn Ammo
		_VehicleSpawnPosition = [_AmmoSpawnPosition, 0, 50, 2, 0, 45, 0] call BIS_fnc_findSafePos;
		_VehicleArray = RALLYUP_ResupplyVehicles select floor random count RALLYUP_ResupplyVehicles;		
		_Picked_Vehicle = _VehicleArray createVehicle _VehicleSpawnPosition;	
			
	
	// Diary
		_taskTitle = "Resupply";
		_taskTime = date params ["_year", "_month", "_day", "_hours", "_minutes"];
		_taskStatus = "Canceled";
		_taskPosition = [((_AmmoSpawnPosition select 0) + (_VehicleSpawnPosition select 0)) / 2,((_AmmoSpawnPosition select 1) + (_VehicleSpawnPosition select 1)) / 2,0];	
		_taskType = "container";
		_taskDescription = str formatText ["
			<br/>O P S E C : -----------------
			<br/>
			<br/>	Vehicle and Ammo drop at %1.
			<br/>	
		",_taskPosition];
		
			_Task_Name = str formatText ["%1%2",_taskType,time];			
			_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;				
		
		waituntil {
			sleep 5;
			
			_areaTrigger = [allplayers,(RallyUpBluFor select 0),_taskPosition,50,75] call RALLYUP_fnc_task_isTriggered;	
			if (_areaTrigger) exitWith {_taskStatus = "Succeeded";true};
				false
		};
				
// Task End Events
[_Task_Mission,_taskStatus] call BIS_fnc_taskSetState;
sleep 5;
if(true) exitWith {[_Task_Mission] call BIS_fnc_deleteTask};




