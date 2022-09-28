/*

	Author: CodeRedFox
	Uses: Debug MASTER

*/ 
if (!RALLYUP_DEBUG) exitwith {};

	player allowDamage false;
	OnMapSingleClick "vehicle player SetPos [_pos select 0, _pos select 1, _pos select 2]";
	
	[] spawn RALLYUP_fnc_debug_allunits;
	
	
	waitUntil {
		sleep 1;
		//hint format ["%1",RALLYUP_Intel_Updated];
			false
	};

