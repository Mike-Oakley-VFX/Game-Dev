/*
	Author: CodeRedFox
	Uses: This is the collection of all the game assets that will be used.
	Note: To add/switch in your mod assets, enter it here under the correct class.
	Usage: [] call compile preprocessFileLineNumbers "RallyUp.sqf"; 
	
	Helpful Links: 
		GitHub : https://github.com/coderedfox/RallyUp.Altis
		BI ARMA 3 Unit and Vehicle list : https://community.bistudio.com/wiki/Arma_3_Assets/
		
	Array example :
		["classname"]
		["Group Name", ["class name"]]
		
	Array Returns Example :	
		RALLYUP_Groups_EnemyInf : Returns the whole array all groups and classnames
		(RALLYUP_Groups_EnemyInf select 0) : Returns "Insurgent Spotters"
		((RALLYUP_Groups_EnemyInf select 0) select 1): Returns "O_G_Soldier_M_F"
		
*/

if ( !isServer) exitwith { diag_log format ["RallyUp : fn_game_rallyup.sqf | NOT SERVER %1",serverTime]; }; // Exit if not the server
diag_log format ["RallyUp : fn_game_rallyup.sqf | START %1",serverTime];

// ---------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------

	// Info about the world.
	RALLYUP_GAMESTATUS = true;  // DO NOT EDIT lets the mission know if its running
	RALLYUP_TOTAL_ENEMY_UNITS = []; // DO NOT EDIT counts up total units

	RALLYUP_WorldSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize"); // auto Map size	
	RALLYUP_WorldSizeCenter = [RALLYUP_WorldSize / 2,RALLYUP_WorldSize / 2,0]; // Auto center of map
	RALLYUP_BuildingTypes = ["Building"];	// This should cover everything ["Building","house","Ruins","Church"];
	RALLYUP_LocationsLocal = ["NameVillage","NameLocal"]; // Small Locations
	RALLYUP_LocationsPopulace = ["NameCity","NameCityCapital","NameVillage"]; // All city's and Villages
	RALLYUP_LocationsPoints = ["Hill","NameMarine","Mount"]; // Non Populated areas
	RALLYUP_AINVG = ["RALLYUP_param_AINVG"] call BIS_fnc_getParamValue; // Should AI have NVG?
	publicVariable "RALLYUP_AINVG";

	RALLYUP_EnemyMultiplier = ["RALLYUP_param_WAVENUMBER"] call BIS_fnc_getParamValue; 	// Params to multply enemy
	RALLYUP_minDist = ["RALLYUP_param_MINDISTANCE"] call BIS_fnc_getParamValue; // Missions spawn minumum distance
	RALLYUP_maxDist = ["RALLYUP_param_MAXDISTANCE"] call BIS_fnc_getParamValue; // Missions spawn max distance
	RALLYUP_TimeOutSec = 7200; // Gloabal Mission timeout, default to 7200 or 2 hours to end missions

	RALLYUP_Intel_Updated = false; //For use with Intel items Sets up as false first
	
	RALLYUP_COLORHEX = "#ffb400"; publicVariable "RALLYUP_COLORHEX"; // Coloring but not being used
	RALLYUP_COLORRGBA = [1,0.706,0,1]; publicVariable "RALLYUP_COLORRGBA"; // Coloring but not being used

	// Sides From Params
	RALLYUP_param_PlayerSide = ["RALLYUP_param_PlayerSide"] call BIS_fnc_getParamValue; // Player set friendly side
	RALLYUP_param_BLUFORFactions = ["RALLYUP_param_BLUFORFaction"] call BIS_fnc_getParamValue; // Player set BLURFOR faction
	RALLYUP_param_OPFORFactions = ["RALLYUP_param_OPFORFaction"] call BIS_fnc_getParamValue; // Player set OPFOR faction

	// Selects BLUFOR Factions
	switch ( RALLYUP_param_BLUFORFactions ) do
	{
		case 0: { RALLYUP_BLUFORFaction = "BLU_F" }; 		// NATO
		case 1: { RALLYUP_BLUFORFaction = "BLU_G_F" }; 		// FIA
		case 2: { RALLYUP_BLUFORFaction = "BLU_T_F" }; 		// Pacific NATO
		case 3: { RALLYUP_BLUFORFaction = "BLU_CTRG_F" }; 	// Pacific CTRG
		case 4: { RALLYUP_BLUFORFaction = "BLU_GEN_F" }; 	// Gendarmerie
		case 5: { RALLYUP_BLUFORFaction = "BLU_W_F" }; 		// Woodland NATO
	};

	// Selects OPFOR Factions
	switch ( RALLYUP_param_OPFORFactions ) do
	{
		case 0: { RALLYUP_OPFORFaction = "OPF_F" }; 		// Iranian CSAT
		case 1: { RALLYUP_OPFORFaction = "OPF_G_F" }; 		// FIA
		case 2: { RALLYUP_OPFORFaction = "OPF_T_F" }; 		// Chinese CSAT
		case 3: { RALLYUP_OPFORFaction = "OPF_R_F" }; 		// Spetznatz
	};

	// Sets Player picked side
	switch ( RALLYUP_param_PlayerSide ) do
	{
		case 0: {
			RALLYUP_Friend_Side = WEST;	RALLYUP_Friend_Faction = RALLYUP_BLUFORFaction;
			RALLYUP_Enemy_Side = EAST; RALLYUP_Enemy_Faction = RALLYUP_OPFORFaction;
		};
		case 1 :{
			RALLYUP_Friend_Side = EAST; RALLYUP_Friend_Faction = RALLYUP_OPFORFaction;
			RALLYUP_Enemy_Side = WEST;	RALLYUP_Enemy_Faction = RALLYUP_BLUFORFaction;
		};
	};	

	// Selects Independent Factions
	RALLYUP_GUER_Side = Independent; RALLYUP_GUERFaction = "OPF_G_F";

	// Selects Civillian Factions
	RALLYUP_CIV_Side = Civilian; RALLYUP_CIVFaction = "CIV_F";

	diag_log format ["RallyUp : Sides and Factions | Friend %1 \ %2 | Enemy%3 \ %4", RALLYUP_Friend_Side,	RALLYUP_Friend_Faction,	RALLYUP_Enemy_Side,	RALLYUP_Enemy_Faction];

	// Creates and Updates Spawn Position
	RALLYUP_Respawn_MRK = "respawn_" + str(RALLYUP_Friend_Side);	
	_pickedSpot = [ [random RALLYUP_WorldSize,random RALLYUP_WorldSize],0,RALLYUP_WorldSize,RALLYUP_LocationsLocal,5] call RALLYUP_fnc_position_Locations; 
	[RALLYUP_Friend_Side,_pickedSpot] call RALLYUP_fnc_task_UpdateSpawns; // Picks first spawn spot

	// ---------------------------------------------------------------------
	// Randomzied variables
	// ---------------------------------------------------------------------
	// USEAGE:	_var = [SIDE, Faction, ARRAY Types, ARRAY Excluded names , ARRAY Must Contain Attrib] call RALLYUP_fnc_task_ArrayofCfg;
	// EXAMPLE: _var = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction, ["_Soldier_"], ["_unarmed_"] , ["transportSoldier"]] call RALLYUP_fnc_task_ArrayofCfg;

	// Randomize friendly and Vehicles	
	RALLYUP_Random_FriendlyInf = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction, "Men", ["Range","_unarmed_","pilot","_Survivor_","Parade","Crew","Competitor"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
		publicVariable "RALLYUP_Random_FriendlyInf"; // allows clients to read data to spawn units
	RALLYUP_Random_FriendlyVeh = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction, "Car", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyMech = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Armored", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyHeliTrans = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Air", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyHeli = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Air", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyJet = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Air", ["Heli"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyBoats = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Ship", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_FriendlyUAV = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction,  "Autonomous", ["UGV","Ship","SAM","AAA","Radar","Medical"], [] ] call RALLYUP_fnc_task_ArrayofCfg;

	// Randomize Enemy and Vehicles
	RALLYUP_Random_EnemyInf = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction, "Men", ["Range","_unarmed_","pilot","survior","Parade","Crew","Competitor"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyVeh = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction, "Car", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyMechTrans = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Armored", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyMech = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Armored", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyHeliTrans = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Air", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyHeli = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Air", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyJet = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Air", ["Heli"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyPara = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Air", [], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyBoats = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Ship", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyUAV = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Autonomous", ["UGV","Ship","SAM","AAA","Radar","Medical"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyStatics = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Static", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyMortars = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Static", [], ["artilleryScanner"] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_EnemyArtillery = [RALLYUP_Enemy_Side, RALLYUP_Enemy_Faction,  "Armored", [], ["artilleryScanner"] ] call RALLYUP_fnc_task_ArrayofCfg;

	// 	Random Civillians
	RALLYUP_Random_CivAir = [RALLYUP_CIV_Side, RALLYUP_CIVFaction,  "Air", ["_Wreck_"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
	RALLYUP_Random_CivVeh = [RALLYUP_CIV_Side, RALLYUP_CIVFaction, "Car", ["_Wreck_"], ["transportSoldier"] ] call RALLYUP_fnc_task_ArrayofCfg;

	// Random AmmoCrates 
	RALLYUP_AmmoCrates = [RALLYUP_CIV_Side, "Default", "Ammo", [str RALLYUP_Enemy_Side], [] ] call RALLYUP_fnc_task_ArrayofCfg;

	// Random Wrecks typesvehicleClass = "Wreck_sub";
	RALLYUP_Wrecks = [RALLYUP_CIV_Side, "Default", "Wreck", ["Traw","Boat" ], [] ] call RALLYUP_fnc_task_ArrayofCfg;
		
	// Random Assassinate and Rescue items : People 
	RALLYUP_POI = [RALLYUP_CIV_Side, RALLYUP_CIVFaction, "Men", [], [] ] call RALLYUP_fnc_task_ArrayofCfg;

	// Random Assassinate and Rescue items : Vehicles
	RALLYUP_POIVehicles = ( [RALLYUP_CIV_Side, RALLYUP_CIVFaction, "Car", [], [] ] call RALLYUP_fnc_task_ArrayofCfg) + ([RALLYUP_CIV_Side, RALLYUP_CIVFaction, "Air", [], [] ] call RALLYUP_fnc_task_ArrayofCfg);

	// Random Objectives Types
	RALLYUP_BldObjectives = ["Land_Communication_","Land_Cargo_Tower_"];
	
	// Random Mine types
	RALLYUP_MinesAP = [4, "None", "Mines", ["UnderwaterMine","SatchelCharge","DemoCharge"], ["camouflage"] ] call RALLYUP_fnc_task_ArrayofCfg;

	// Different kinda of actions for AI
	RALLYUP_combatMode = ["AWARE","COMBAT","STEALTH"];
	RALLYUP_formationMode =["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"];
	RALLYUP_SpeedMode = ["LIMITED","NORMAL","FULL"];

diag_log format ["RallyUp : fn_game_rallyup.sqf | END %1",serverTime];
if(true) exitWith {}