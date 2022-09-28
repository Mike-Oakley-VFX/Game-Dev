/*
	Author: CodeRedFox	
	Function: Instructs the leader to eject his group with a parachute ever 1 second.
	Usage: [_Leader] spawn RALLYUP_fnc_task_Paratroopers
	Returns: N/A
*/ 


	_Leader = _this select 0;
	_ParaGroup = units group _Leader;

	{
		sleep 1;
		removeBackpack _x;
		_x addBackpack 'B_Parachute'; //B_O_Parachute_02_F
		unassignVehicle _x;
		[_x] ordergetin false;
		moveOut _x;
	} forEach _ParaGroup;

diag_log format ["RallyUp : RALLYUP_fnc_task_Paratroopers | ParaGroup : %1 Count = %2",_Leader,_ParaGroup];