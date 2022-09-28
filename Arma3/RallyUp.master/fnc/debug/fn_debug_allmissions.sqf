/*

	Author: CodeRedFox
	Uses: Checks all missions
	Note:
	Usage:		[] spawn RALLYUP_fnc_debug_allmissions;

*/ diag_log format ["RallyUp : RALLYUP_fnc_debug_allmissions | %1 | %2",time,serverTime];
if (!isServer) exitwith {};
[] spawn RALLYUP_fnc_debug_allunits;

_TaskWait = ["RallyUp","Relocate","Support"];

_TaskTypes = ["Ambush","Assassinate","Barricade","Mount","Overwatch","PayDay","Rescue","Search","Surveillance"];

	{
			
			//RALLYUP_SkipMissions = true;
			
			sleep 5;
			_position = [getpos player,500,5500,(RALLYUP_LocationsPopulace+RALLYUP_LocationsLocal+RALLYUP_LocationsPoints),5] call RALLYUP_fnc_position_Locations; 
			player setpos _position;
			_Direction = [player, RALLYUP_WorldSizeCenter] call BIS_fnc_dirTo;
			player setDir _Direction;
			sleep 5;
			
			_Task = [RALLYUP_WorldSizeCenter] execVM format["Missions\Mission_%1.sqf",_x];
			
			sleep 5;			
			
	} foreach _TaskTypes+_TaskWait;

diag_log format ["--- RALLYUP_fnc_debug_allmissions --- | %1 | %2",time,serverTime];

sleep 5;hintC "ALL MISSIONS DONE";