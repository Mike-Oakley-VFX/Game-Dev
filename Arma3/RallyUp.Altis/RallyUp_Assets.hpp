/*
	Author: CodeRedFox
	Uses: This is the collection of all the game assets that will be used.
	Note: To add/switch in your mod assets, enter it here under the correct class.
	Usage: #include "RALLYUP_Assets.hpp"
	
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


// ---------------------------------------------------------------------
// Global Variables
// ---------------------------------------------------------------------
		
		RALLYUP_DEBUG = true;	// Debug on or off
		
		RALLYUP_TOTAL_ENEMY_UNITS = []; // DO NOT EDIT
		RALLYUP_GAMESTATUS = true;  // DO NOT EDIT
		RALLYUP_COLORHEX = ["ffb400"]; 
		RALLYUP_COLORRGBA = [1,0.706,0,1];
		
		RALLYUP_FriendlySide = west;
		RALLYUP_EnemySide = east;
		
		
		
		RALLYUP_EnemyMultiplier = ["RALLYUP_param_WAVENUMBER"] call BIS_fnc_getParamValue;
				
		// Info about the world.
			RALLYUP_WorldSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize"); // Map size	
			RALLYUP_WorldSizeCenter = [RALLYUP_WorldSize / 2,RALLYUP_WorldSize / 2,0]; // center of map
		
		// informationg about Objects on the map
			RALLYUP_BuildingTypes = ["Building"];	// This should cover everything ["Building","house","Ruins","Church"];
			RALLYUP_LocationsLocal = ["NameVillage","NameLocal"]; // Small Locations
			RALLYUP_LocationsPopulace = ["NameCity","NameCityCapital","NameVillage"]; // All city's and Villages
			RALLYUP_LocationsPoints = ["Hill","NameMarine","Mount"]; // Non Populated areas
			
			RALLYUP_UISettings = true; // Enable user settings. NOT READY
			RALLYUP_UIHeadsup = true; // Enable user headup. NOT READY
			RALLYUP_UIViewDistance = 2000; 	// Sets user view distance. NOT READY
		
		// Sets the default min and max mission range. Missions may override this value
			RALLYUP_minDistance = ["RALLYUP_param_minDistance"] call BIS_fnc_getParamValue;
			RALLYUP_maxDistance = ["RALLYUP_param_maxDistance"] call BIS_fnc_getParamValue;
			RALLYUP_TimeOutSec = 600; // Gloabal Mission timeout and sleeps
		
		// Mission names
			RALLYUP_MissionsIntermission = [
				"RallyUp","RallyUp","RallyUp","RallyUp",
				"Relocate"
			];
			RALLYUP_MissionsPrimary = [
				"Ambush","AmmoCache","Assassinate",
				"Barricade",
				"Mount",
				"Overwatch",
				"PayDay",
				"Rescue","Reward",
				"Search","Surveillance"
			];
			RALLYUP_MissionsSecondary = [
				"ResupplyAmmo","ResupplyVehicle",
				"RewardHelicopter","RewardJet"	
			];	
	
	
		RallyUpBluFor = [WEST,"North Atlantic Treaty Organisation (NATO)"]; // Friendly forces
		RallyUpOpFor = [EAST,"Canton-Protocol Strategic Alliance Treaty (CSAT)"]; // Enemy forces
		RallyUpCivFor = [civilian,"Altian Civilian's"]; // Civilian force

	// Different kinda of actions for AI
		RALLYUP_combatMode = ["AWARE","COMBAT","STEALTH"];
		RALLYUP_formationMode =["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"];
		RALLYUP_SpeedMode = ["LIMITED","NORMAL","FULL"];
		
// ---------------------------------------------------------------------
// Mission Objects
// ---------------------------------------------------------------------	
	
	// List of possible Intel items for the search missions ["class name"]
		RALLYUP_MissionItems = ["Land_Laptop_device_F","Land_PortableLongRangeRadio_F","Land_MobilePhone_smart_F","Land_File1_F","Land_File2_F","Land_FilePhotos_F","Land_Map_F","Land_Suitcase_F","Land_HandyCam_F","Land_Laptop_F","Land_Laptop_unfolded_F", "Land_SatellitePhone_F","Land_Laptop_device_F","Land_PaperBox_open_full_F"
		];
		
	// Intel reveal
		RALLYUP_Intel_Updated = false;
		RALLYUP_Intel = ["Land_File1_F","Land_File2_F","Land_FilePhotos_F","Land_Map_F","Land_Map_unfolded_F","Land_Notepad_F",	"Land_Photos_V1_F",		"Land_MobilePhone_smart_F","Land_PortableLongRangeRadio_F"
	];	
				
		
	// AmmoCrates  ["class name"]
		RALLYUP_AmmoCrates = ["B_CargoNet_01_ammo_F","B_supplyCrate_F"];
		
	// Wrecks types  ["class name"]
		RALLYUP_Wrecks = ["Land_UWreck_Heli_Attack_02_F","Land_UWreck_MV22_F","Land_Wreck_BMP2_F","Land_Wreck_BRDM2_F",
			"Land_Wreck_Heli_Attack_01_F","Land_Wreck_HMMWV_F","Land_Wreck_Hunter_F","Land_Wreck_Slammer_F"
		];	

	// Assassinate and Rescue items : People and vehicles  ["Group Name", [class name]] 
		RALLYUP_POI = ["B_officer_F","O_officer_F","I_officer_F","C_man_1","C_man_polo_6_F_afro","C_man_polo_6_F_euro","C_man_polo_6_F_asia",
			"C_Nikos","C_Nikos_aged","C_journalist_F","C_man_hunter_1_F","C_man_pilot_F",
			"C_Orestes","C_Marshal_F","b_g_survivor_F","b_survivor_F","C_scientist_F","C_man_w_worker_F",
			"B_Competitor_F","B_Story_SF_Captain_F","B_Story_Colonel_F","I_G_Story_SF_Captain_F",
			"I_G_resistanceLeader_F"
		];
		
		// Most of these have auto Randomization of its looks
		RALLYUP_POIVehicles = ["C_Offroad_01_F","C_Van_01_transport_F","C_SUV_01_F","C_Hatchback_01_F","C_Quadbike_01_F",
			"C_Heli_Light_01_civil_F"];
			
		RALLYUP_BldObjectives = [
			"Land_Radar_F","Land_Radar_Small_F",
			"Land_Medevac_HQ_V1_F","Land_Research_HQ_F",
			"Land_Cargo_HQ_V3_F",
			"Land_Cargo_Patrol_V3_F",
			"Land_Crane_F","Land_cmp_Tower_F",
			"Land_Castle_01_tower_F",
			"Land_TTowerBig_1_F","Land_TTowerBig_2_F","Land_Communication_F",
			"Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V3_F"
		];
		
		RALLYUP_MinesAP = [
			"APERSMine_Range_Ammo",
			"APERSBoundingMine_Range_Ammo",
			"APERSTripMine_Wire_Ammo",
			"ClaymoreDirectionalMine_Remote_Ammo",
			"IEDUrbanSmall_Remote_Ammo",
			"IEDLandSmall_Remote_Ammo"
		];
		
		RALLYUP_MinesAT = [
			"ATMine_Range_Ammo",
			"SLAMDirectionalMine_Wire_Ammo",
			"IEDUrbanBig_Remote_Ammo",
			"IEDLandBig_Remote_Ammo"
		];

// ---------------------------------------------------------------------
// Friendly Units
// ---------------------------------------------------------------------

	// list of items that can be requested as re-enforcements
		RALLYUP_Reinforcements = [
			"B_Soldier_02_f","B_Soldier_03_f","B_Soldier_F","B_Soldier_GL_F","B_soldier_AR_F","B_soldier_M_F",
			"B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_soldier_exp_F","B_soldier_AT_F","B_soldier_AA_F",
			"B_soldier_UAV_F","B_sniper_F",	"B_ghillie_lsh_F","B_ghillie_sard_F","B_ghillie_ard_F",
			"B_Sharpshooter_F","B_HeavyGunner_F"
		];
		
		RALLYUP_ResupplyVehicles = [
			"B_G_Offroad_01_F",
			"B_G_Offroad_01_armed_F",
			"B_MRAP_01_F",
			"B_MRAP_01_hmg_F",
			"B_MRAP_01_gmg_F"
		];
		
		RALLYUP_ResupplyWeapons = [
			"arifle_MXC_F","arifle_MX_F","arifle_MX_GL_F","arifle_MX_SW_F","arifle_MXM_F",
			"hgun_P07_F"
		];
		RALLYUP_ResupplyMagazines = ["30Rnd_65x39_caseless_mag","16Rnd_9x21_Mag","GrenadeHand"];
		RALLYUP_ResupplyItems = ["SmokeShell","SmokeShellGreen","Chemlight_green"];
		RALLYUP_ResupplyBackpacks = [];
		
		
	// Friendly Unit Groups [Group Name, [class name]]
		RALLYUP_Groups_FriendlyInf = [	
			["Insurgent Spotters",		["B_G_Soldier_lite_F","B_G_Soldier_M_F"]],
			["Insurgent Squad",		["B_G_officer_F","B_G_Soldier_TL_F","B_G_Soldier_AR_F","B_G_Soldier_exp_F","B_G_Soldier_LAT_F","B_G_Soldier_GL_F","B_G_medic_F"]],
			["Air-Defence Team", 		["B_Soldier_TL_F","B_Soldier_AA_F","B_Soldier_AA_F","B_Soldier_AAT_F"]],		
			["Air-Armour Team", 		["B_Soldier_TL_F","B_Soldier_AT_F","B_Soldier_AT_F","B_Soldier_AAT_F"]],
			["Assault Squad", 		["B_Soldier_SL_F","B_Sharpshooter_F","B_Soldier_AT_F","B_soldier_M_F","B_HeavyGunner_F","B_medic_F","B_Soldier_AR_F"]],
			["Fire Team", 			["B_Soldier_TL_F","B_Soldier_AT_F","B_Soldier_GL_F","B_Soldier_AR_F"]],		
			["Recon Patrol", 		["B_recon_TL_F","B_recon_F","B_recon_medic_F","B_recon_M_F"]],		
			["Recon Squad", 		["B_recon_TL_F","B_recon_LAT_F","B_recon_F","B_recon_medic_F","B_recon_M_F","B_recon_JTAC_F","B_recon_exp_F"]],
			["Recon Team", 			["B_recon_TL_F","B_recon_LAT_F","B_recon_medic_F","B_recon_M_F","B_recon_JTAC_F","B_recon_exp_F"]],
			["Rifle Squad", 		["B_Soldier_TL_F","B_Soldier_SL_F","B_Soldier_AT_F","B_Soldier_lite_F","B_soldier_M_F","B_medic_F","B_Soldier_AA_F","B_Soldier_AAT_F"]],
			["Sniper Team",			["B_sniper_F","B_spotter_F"]],		
			["Weapons Squad", 		["B_Soldier_SL_F","B_Soldier_AT_F","B_soldier_M_F","B_Soldier_GL_F","B_medic_F","B_Soldier_AR_F"]],
			["HMG Squad", 			["B_Soldier_TL_F","B_support_MG_F","B_support_AMG_F"]],
			["GMG Squad", 			["B_Soldier_TL_F","B_support_GMG_F","B_support_AMG_F"]],
			["Mortar Squad", 		["B_Soldier_TL_F","B_support_Mort_F","B_support_AMort_F"]],
			["UAV Squad", 			["B_soldier_UAV_F","B_UAV_01_F"]]		
		];

	// Friendly Mechanized Groups [Group Name, [class name]]	
		RALLYUP_Groups_FriendlyMech = [
			// Insurgent
			["Local Support", 			["B_G_Offroad_01_F","B_G_Van_01_transport_F"]],	
			["Local Armed Support", 	["B_G_Offroad_01_armed_F"]],	
			["Local Armed Response",	["B_G_Offroad_01_armed_F","B_G_Offroad_01_F"]],
			
			//BLUFOR Technical
			["Military Troops",	["B_Truck_01_covered_F","B_Truck_01_transport_F","B_Truck_01_box_F"]],			
			["Military Patrol", 	["B_MRAP_01_F"]],			
			["Military Response", 	["B_MRAP_01_hmg_F"]],
			["Military Support", 	["B_MRAP_01_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]],
				
			//BLUFOR APC
			["APC Support", 		["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F"]],		
			
			//BLUFOR Armour
			["Tank Support", 		["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"]],
			["Anti-Defence Support",	["B_APC_Tracked_01_AA_F","B_Truck_01_ammo_F"]],
			["Artillery Support",		["B_MBT_01_arty_F","B_MBT_01_mlrs_F","B_Truck_01_ammo_F"]],
			
			//BLUFOR Support
			["Support", 			["B_Truck_01_Repair_F","B_Truck_01_ammo_F","B_Truck_01_fuel_F","B_Truck_01_medical_F"]],
			
			//BLUFOR AI
			["UAG Squad", 			["B_UGV_01_rcws_F","B_UAV_02_F","B_UAV_02_CAS_F"]]
	
		];

	// Friendly Static Groups [Group Name, [class name]]	
		RALLYUP_Groups_FriendlyStatic = [
			["HMG Support", 		["B_HMG_01_F","B_HMG_01_high_F"]],
			["GMG Support", 		["B_GMG_01_F","B_GMG_01_high_F"]],
			["Air-Defence Support", 	["B_static_AA_F"]],
			["Air-Armour Support", 		["B_static_AT_F"]],
			["Mortar Support", 		["B_Mortar_01_F","B_G_Mortar_01_F"]]
		];
		
	// Friendly Boat Groups [Group Name, [class name]]	
		RALLYUP_Groups_FriendlyBoats = [
			["Transport", 			["B_G_Boat_Transport_01_F","B_Boat_Transport_01_F"]],
			["Attack", 			["B_Boat_Armed_01_minigun_F","B_Boat_Armed_01_minigun_F"]],	
			["Sub", 			["B_SDV_01_F"]]
		];
	
	// Friendly Helicopters Groups [Group Name, [class name]]	
		
		//RALLYUP_SideAHelicoptersTransport = [RALLYUP_FriendlySide,"CfgVehicles", "Helicopter_Base_F", "Heli_Transport_", "" ] call RALLYUP_fnc_task_ArrayofCfg;
		
			
		RALLYUP_Groups_FriendlyHelicopters = [
			["Scout", 			["B_Heli_Light_01_F","B_Heli_Light_01_armed_F","B_Heli_Light_01_stripped_F"]],
			["Transport",			["B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F"]],
			["Cargo", 			["B_Heli_Transport_03_F","B_Heli_Transport_03_unarmed_F","B_Heli_Transport_03_black_F","B_Heli_Transport_03_unarmed_green_F"]],
			["Attack", 			["B_Heli_Attack_01_F"]]
		];
	
	// Friendly Jets Groups [Group Name, [class name]]	
		RALLYUP_Groups_FriendlyJets = [
			["CAS", 			["B_Plane_CAS_01_F"]],
			["UAV CAS", 			["B_UAV_02_CAS_F"]],
			["UAV Air", 			["B_UAV_02_F"]]
		];				
				
		
// ---------------------------------------------------------------------
// Enemy Units
// ---------------------------------------------------------------------		
		
	// Enemy Unit Groups [Group Name, [class name]]
		RALLYUP_Groups_EnemyInf = [
	
			["Insurgent Spotters",		["O_G_Soldier_lite_F","O_G_Soldier_M_F"]],
			["Insurgent Squad",		["O_G_officer_F","O_G_Soldier_TL_F","O_G_Soldier_AR_F","O_G_Soldier_exp_F","O_G_Soldier_LAT_F","O_G_Soldier_GL_F","O_G_medic_F"]],
			["Air-Defence Team", 		["O_Soldier_TL_F","O_Soldier_AA_F","O_Soldier_AA_F","O_Soldier_AAT_F"]],		
			["Air-Armour Team", 		["O_Soldier_TL_F","O_Soldier_AT_F","O_Soldier_AT_F","O_Soldier_AAT_F"]],
			["Assault Squad", 		["O_Soldier_SL_F","O_Sharpshooter_F","O_Soldier_AT_F","O_soldier_M_F","O_HeavyGunner_F","O_medic_F","O_Soldier_AR_F"]],
			["Fire Team", 			["O_Soldier_TL_F","O_Soldier_AT_F","O_Soldier_GL_F","O_Soldier_AR_F"]],		
			["Recon Patrol", 		["O_recon_TL_F","O_recon_F","O_recon_medic_F","O_recon_M_F"]],		
			["Recon Squad", 		["O_recon_TL_F","O_recon_LAT_F","O_recon_F","O_recon_medic_F","O_recon_M_F","O_recon_JTAC_F","O_recon_exp_F"]],
			["Recon Team", 			["O_recon_TL_F","O_recon_LAT_F","O_recon_medic_F","O_recon_M_F","O_recon_JTAC_F","O_recon_exp_F"]],
			["Rifle Squad", 		["O_Soldier_TL_F","O_Soldier_SL_F","O_Soldier_AT_F","O_Soldier_lite_F","O_soldier_M_F","O_medic_F","O_Soldier_AA_F","O_Soldier_AAT_F"]],
			["Sniper Team",			["O_sniper_F","O_spotter_F"]],		
			["Weapons Squad", 		["O_Soldier_SL_F","O_Soldier_AT_F","O_soldier_M_F","O_Soldier_GL_F","O_medic_F","O_Soldier_AR_F"]],
			["HMG Squad", 			["O_Soldier_TL_F","O_support_MG_F","O_support_AMG_F"]],
			["GMG Squad", 			["O_Soldier_TL_F","O_support_GMG_F","O_support_AMG_F"]],
			["Mortar Squad", 		["O_Soldier_TL_F","O_support_Mort_F","O_support_AMort_F"]],
			["UAV Squad", 			["O_soldier_UAV_F","O_UAV_01_F"]]		
		];
		
	// Enemy Mechanized Groups [Group Name, [class name]]	
		RALLYUP_Groups_EnemyMech = [
			// Insurgent
			["Local Support", 		["O_G_Offroad_01_F","O_G_Van_01_transport_F"]],	
			["Local Armed Support", 	["O_G_Offroad_01_armed_F"]],	
			["Local Armed Response",	["O_G_Offroad_01_armed_F","O_G_Offroad_01_F"]],
			
			//OPFOR Technical
			["Military Troops",	["O_Truck_02_covered_F","O_Truck_02_transport_F","O_Truck_02_box_F"]],			
			["Military Patrol", 	["O_MRAP_02_F"]],			
			["Military Response", 	["O_MRAP_02_F","O_MRAP_02_hmg_F"]],
			["Military Support", 	["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_Truck_02_covered_F"]],
			["Tempest",			["O_Truck_03_transport_F","O_Truck_03_covered_F","O_Truck_03_device_F"]],
			
			//OPFOR APC
			["APC Support", 		["O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F"]],		
			
			//OPFOR Armour
			["Tank Support", 		["O_MBT_02_cannon_F","O_MBT_02_cannon_F"]],
			["Anti-Defence Support",	["O_APC_Tracked_02_AA_F","O_Truck_03_ammo_F"]],
			["Artillery Support",		["O_MBT_02_arty_F","O_MBT_02_arty_F","O_Truck_03_ammo_F"]],
			
			//OPFOR Support
			["Support", 			["O_Truck_02_fuel_F","O_Truck_02_Ammo_F","O_Truck_02_medical_F","O_Truck_02_box_F"]],
			
			//OPFOR AI
			["UAG Squad", 			["O_UGV_01_rcws_F","O_UAV_02_F"]]
	
		];		
		
	// Enemy Static Groups [Group Name, [class name]]	
		RALLYUP_Groups_EnemyStatic = [
			["HMG Support", 		["O_HMG_01_F","O_HMG_01_high_F"]],
			["GMG Support", 		["O_GMG_01_F","O_GMG_01_high_F"]],
			["Air-Defence Support", 	["O_static_AA_F"]],
			["Air-Armour Support", 		["O_static_AT_F"]],
			["Mortar Support", 		["O_Mortar_01_F","O_Mortar_01_F","O_Mortar_01_F"]]
		];
		
	// Enemy Boat Groups [Group Name, [class name]]	
		RALLYUP_Groups_EnemyBoats = [
			["Transport", 			["O_G_Boat_Transport_01_F","O_Boat_Transport_01_F"]],
			["Attack", 			["O_Boat_Armed_01_hmg_F","O_Boat_Armed_01_hmg_F"]],	
			["Sub", 			["O_SDV_01_F"]]
		];
	
	// Enemy Helicopters Groups [Group Name, [class name]]	
		RALLYUP_Groups_EnemyHelicopters = [
			["Scout", 			["O_Heli_Light_02_unarmed_F","O_Heli_Light_02_unarmed_F"]],
			["Transport",			["O_Heli_Transport_04_F","O_Heli_Transport_04_bench_F","O_Heli_Transport_04_covered_F"]],
			["Assault", 			["O_Heli_Light_02_F","O_Heli_Light_02_F"]],
			["Attack", 			["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F"]]
		];
	
	// Enemy Jets Groups [Group Name, [class name]]	
		RALLYUP_Groups_EnemyJets = [
			["CAS", 			["O_Plane_CAS_02_F"]],
			["AA", 				["I_Plane_Fighter_03_AA_F"]],
			["UAV CAS", 			["O_UAV_02_CAS_F"]],
			["UAV Air", 			["O_UAV_02_F"]]
		];
		
		
/*		
Rally Up by CodeRedFox is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
Based on a work at https://github.com/coderedfox/RallyUp.Altis.
*/		
		
		
