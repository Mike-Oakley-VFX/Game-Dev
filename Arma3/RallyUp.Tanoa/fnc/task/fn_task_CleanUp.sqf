/*
	Author: CodeRedFox	
	Function: Cleans up the scene of any left over units and vehicles.	
	Usage: [side,distance] spawn RALLYUP_fnc_task_CleanUp;
	Example: [RALLYUP_Enemy_Side,500] call RALLYUP_fnc_task_CleanUp;
*/ diag_log format ["RallyUp : RALLYUP_fnc_task_CleanUp | %1 | %2",time,serverTime];
	
	// private ["_side","_distance"];

	_side = _this select 0;
	_distance = _this select 1;
	_Playersdistance = [AllPlayers] call RALLYUP_fnc_Position_3dCenter;	
	
	{

		if ((_x distance _Playersdistance > _distance) and (side _x == _side)) then
		{
			
			//if ( _x in (fullCrew vehicle _x) ) then { moveOut _x };
			
			deleteVehicle vehicle _x;
			deleteVehicle _x;
			deleteGroup (group _x);

		};	
	
	} forEach allUnits+vehicles+allDead+allDeadMen;

	{if (damage _x > 0.9) then { deleteVehicle _x};} forEach vehicles;



	RALLYUP_TotalUnits = 0;

if(true) exitWith {};

