	// Degug
	//RALLYUP_DEBUG = true;	// Debug on or off
	//if (RALLYUP_DEBUG) then {	[] spawn RALLYUP_fnc_debug_Master; };	
	

	
// --- STARTING GAME LOGIC	

	[] call RALLYUP_fnc_game_RallyUp;


	["Initialize", [true]] call BIS_fnc_dynamicGroups; // Starts Dynamic Groups


	//[] spawn RALLYUP_fnc_ambient_weather;	

	// [] spawn RALLYUP_fnc_ambient_Air;
		
	//if ( ["RALLYUP_param_ambientAir"] call BIS_fnc_getParamValue == 1 ) then { [] spawn RALLYUP_fnc_ambient_Air; };
	
	//if ( ["RALLYUP_param_ambientGround"] call BIS_fnc_getParamValue == 1 ) then { [] spawn RALLYUP_fnc_ambient_Ground; };
			
	// [] execVM "missions\Tasking_Missions.sqf";	// Starts the missions
	
diag_log format ["RallyUp : RallyUp.sqf | HAS STARTED : %1 ---------------------------------------------------------------------------------------------------",serverTime];		
