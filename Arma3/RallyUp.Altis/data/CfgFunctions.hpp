


//RallyUp class cfgFunctions "Creates function database"
class CfgFunctions{	
	class RallyUp {
		tag = "RallyUp";		
		class ambient {
			file = "fnc\ambient";
			class ambient_EnemyAir;
			class ambient_EnemyGround;
			class ambient_weather;
		};
		class camera {
			file = "fnc\camera";
			class camera_RandomCamera;
			class camera_Locations;
		};		
		class create {
			file = "fnc\create";
			class create_enemy;
			class create_fillcargo;
			class create_PopulateBuilding;
			class create_MineField;
			class create_reinforcements;
			class create_requestteammates;
			class create_intel;
		};	
		class debug {
			file = "fnc\debug";
			class debug_allunits;
			class debug_allmissions;
			class debug_DisplayAllLocation;
			class debug_marker;	
			class debug_Master;
		};
		class diary {
			file = "fnc\diary";
			class diary_RallyUpInfo;
		};		
		class position {
			file = "fnc\position";
			class position_3dCenter;
			class position_Locations;
			class position_LocationsBuilding;
			class position_LocationsName;
			class position_LocationsObject;
			class position_LocationsRoad;
			class position_LocationsSpots;
		};		
		class task {
			file = "fnc\task";
			class task_addaction;
			class task_CleanUp; 
			class task_CountDownRemoval;
			class task_FillAmmocrate;
			class task_inheritvelocity;
			class task_OpenDoors;
			class task_Paratroopers;
			class task_RandomDamage;
			class task_UpdateSpawns;
			class task_isTriggered;
			class task_ArrayofCfg;
		};		
		class text {
			file = "fnc\text";
			class text_GetInfo;
			class text_RandomName;
		};
		class ui {
			file = "fnc\ui";
			class ui_settings;
			class ui_HeadUp;
		};
	};
};
