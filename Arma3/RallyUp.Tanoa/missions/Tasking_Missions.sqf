
/*
	Author: CodeRedFox
	Uses: This picks the tasks for the game world
	Note: 
	Usage: [] execVM "missions\Tasking_Missions.sqf"
*/ 

diag_log format ["RallyUp : Tasking_Missions.sqf | %1",getMarkerPos 'respawn_Side'];
if (!isServer) exitwith {};

	_spawnUpdate = getMarkerPos RALLYUP_Respawn_MRK;		
	
	//_missionList = [ "DestroyArtillery", "DestroyMortars", "DestroyPOI", "DestroyVehicle","HVT"];

	_missionList = ["DestroyMortars"];

	// Start up Resupply
	_SpawnMission = [getMarkerPos RALLYUP_Respawn_MRK] execVM "missions\mission_Spawn.sqf";
	waitUntil{ sleep 5; if ( scriptdone _SpawnMission ) exitWith { true};false };

	// Start up Main Missions
	while {RALLYUP_GAMESTATUS} do {	
		_missionLocation = getMarkerPos RALLYUP_Respawn_MRK;

		// Rally up mission
		_Launch_RallyUp = [ _missionLocation ] execVM "missions\mission_RallyUp.sqf";
			waitUntil{ sleep 5;if ( scriptdone _Launch_RallyUp ) exitWith { true}; false };
			[RALLYUP_Enemy_Side,RALLYUP_minDist] spawn RALLYUP_fnc_task_CleanUp;

		// Main Mission
		_missiontext = str formatText ["missions\mission_%1.sqf",( _missionList select floor random count _missionList )];
		_Launch_IntermissionMissions = [ _missionLocation ] execVM format["%1",_missiontext];
			waitUntil{ sleep 5;if ( scriptdone _Launch_IntermissionMissions ) exitWith { true};	false };
			[RALLYUP_Enemy_Side,RALLYUP_minDist] spawn RALLYUP_fnc_task_CleanUp;

		// Secondary mission

	false
	};

diag_log format ["RallyUp : Tasking_Missions.sqf | HAS ENDED %1",serverTime];
if(true) exitWith {endMission "END1"};
