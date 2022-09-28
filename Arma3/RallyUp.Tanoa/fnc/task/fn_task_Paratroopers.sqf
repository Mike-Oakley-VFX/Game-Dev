/*
	Author: CodeRedFox	
	Function: Instructs the leader to eject his group with a parachute ever 1 second.
	Usage: [_Leader] spawn RALLYUP_fnc_task_Paratroopers
	Returns: N/A
*/ 



	_paraLeader = _this select 0;
	_paraGroup = group _paraLeader;
	_vehicle = assignedVehicle _paraLeader;

	{
		waitUntil { !surfaceIsWater position _x };
		removeBackpack _x;
		_x addBackpack 'B_Parachute'; //B_O_Parachute_02_F
		moveOut _x;	
		unassignVehicle _x;
		sleep 1;
	} forEach units _ParaGroup;

	// Strip ai og NVG for fun
	if (RALLYUP_AINVG ==1) then {{_x unassignItem (hmd _x);_x removeItem (hmd _x);_x addPrimaryWeaponItem "acc_flashlight";	} foreach units _paraGroup;	};
	_paraGroup enablegunlights "forceOn"; _paraGroup setBehaviour "SAFE"; _paraGroup setformation (RALLYUP_formationMode select floor random count RALLYUP_formationMode);
	
	_RETURN = [ _paraLeader, _paraGroup, _vehicle ];

diag_log format ["RallyUp : RALLYUP_fnc_task_Paratroopers | Leader : %1 Group = %2 : Veh : %3",_RETURN select 0,_RETURN select 1,_RETURN select 2];
//hint format ["RallyUp : RALLYUP_fnc_task_Paratroopers | Leader : %1 Group = %2 : Veh : %3",_RETURN select 0,_RETURN select 1,_RETURN select 2];
_RETURN