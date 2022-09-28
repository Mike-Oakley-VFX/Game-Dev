/*
	Author: CodeRedFox	
	Function: Cleans up the scene of any left over units and vehicles.	
	Usage: [side,distance] spawn RALLYUP_fnc_task_CleanUp;
	Example: [(RallyUpOpFor select 0),500] spawn RALLYUP_fnc_task_CleanUp;
*/ diag_log format ["RallyUp : RALLYUP_fnc_task_CleanUp | %1 | %2",time,serverTime];
	
	// private ["_side","_distance"];

	sleep 1;
	_side = _this select 0;
	_distance = _this select 1;
	_Playersdistance = [AllPlayers] call RALLYUP_fnc_Position_3dCenter;
	
	{

		if ((_x distance _Playersdistance > _distance) and (side _x == _side)) then
		{
			deleteVehicle vehicle _x;
			deleteVehicle _x;
			deleteGroup (group _x);
		};
	
	} forEach allUnits+vehicles;
	RALLYUP_TotalUnits = 0;

if(true) exitWith {};
