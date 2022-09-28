/*

	Author: CodeRedFox
	Uses: Debug with markers
	Note:
	Usage:		[] spawn RALLYUP_fnc_task_OpenDoors;

*/

	_vehicle = _this select 0;

	_doors = [
		"Doors",
		"Door_R_source","Door_L_source","Door_rear_source",
		"door_R","door_L",
		"DoorL_Back","DoorR_Back",
		"door_L_pop","door_R_pop",
		"Door_1_source","Door_2_source","Door_3_source","Door_4_source","Door_5_source","Door_6_source"
	];
	
	waituntil {
		sleep 5;
		if ((getPosATL _vehicle) select 2 > 10) then {
			{
				_vehicle animateDoor [_x,0];
			} forEach _doors;
		} else {
			{
				_vehicle animateDoor [_x,1];
			} forEach _doors;		
		};	
		if (!alive _vehicle) exitwith {true};
		false
	};

diag_log format ["RallyUp : RALLYUP_fnc_task_OpenDoors | doors : %1",count _doors];	

