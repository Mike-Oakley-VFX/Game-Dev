
/*
	Author: CodeRedFox
	Uses: Main Game Call
	Note: !!!  DO NOT EDIT ANYTHING IN THIS FILE  !!!
	
*/

// Server & Client Settings	
	#include "RALLYUP_Assets.hpp"	
	[] execVM "data\CfgLocations.sqf";
	//[] spawn RALLYUP_fnc_ambient_weather;
	
	// Debugging
	if (RALLYUP_DEBUG) then {	[] spawn RALLYUP_fnc_debug_Master; };	
	if (RALLYUP_DEBUG == true) then {hint "Loaded SQF : RallyUp.sqf";};
	
	
// Server only Settings
	if (isServer) then {
		
	
	
		["Initialize"] call BIS_fnc_dynamicGroups;
		_pickedSpot = [RALLYUP_WorldSizeCenter,1000,RALLYUP_WorldSize,RALLYUP_LocationsLocal,10] call RALLYUP_fnc_position_Locations; 
		
		[(RallyUpBluFor select 0),_pickedSpot] call RALLYUP_fnc_task_UpdateSpawns;
		

				
		//skipTime = ["RALLYUP_param_Daytime"] call BIS_fnc_getParamValue;
				
		//if ( ["RALLYUP_param_ambientAir"] call BIS_fnc_getParamValue ) then { [] spawn RALLYUP_fnc_ambient_EnemyAir; };
		//if ( ["RALLYUP_param_ambientGround"] call BIS_fnc_getParamValue == 1 ) then { [] spawn RALLYUP_fnc_ambient_EnemyGround; };
				
		
		//[] execVM "missions\Tasking_Mission.sqf";	
		
		diag_log format ["RallyUp : RallyUp.sqf | %1",_this];
	};

// Client only Settings
	if (hasInterface) then {	
		[] call RALLYUP_fnc_diary_RallyUpInfo;	
		
		// Revive loadout saves
		player addEventhandler ["killed",{[_this select 0, [_this select 0, "mySavedLoadout"]] call BIS_fnc_saveInventory}]; 
		player addEventhandler ["respawn",{[_this select 0,[_this select 0, "mySavedLoadout"]] call BIS_fnc_loadInventory}];
		
		// Group Assign
		["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;
			_squadName = ["Squade"] call RALLYUP_fnc_text_RandomName;
			_GroupAssign = [nil, _squadName, false];	
			[ "RegisterGroup", [ group player, leader group player, _GroupAssign ] ] remoteExec [ "BIS_fnc_dynamicGroups", 2 ];
		_PlayerSquadName = (group player) setGroupIDGlobal [_squadName];
		
		player addBackpack "B_Respawn_TentDome_F";
		
		if (RALLYUP_UISettings) then {[player] spawn RALLYUP_fnc_ui_settings; };
		
		diag_log format ["RallyUp : RallyUp.sqf | Player : %1",player];
		
	};

	
	



	
