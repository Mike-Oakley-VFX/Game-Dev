
/*
	Author: CodeRedFox
	Uses: This picks the tasks for the game world
	Note: 
	Usage: [] execVM "missions\Tasking_Missions.sqf"
*/ 

diag_log format ["RallyUp : Tasking_Missions.sqf | %1",getMarkerPos "respawn_West"];
if (!isServer) exitwith {};

	sleep 5;
	
	_spawnUpdate = getMarkerPos "respawn_West";
	
	// Create start up Resupply
	[_spawnUpdate] execVM "missions\Intermission_SpawnSupplies.sqf";
	
	while {RALLYUP_GAMESTATUS} do {	
		sleep 10;
		// Pick Tasks
			_IntermissionStringText = str formatText ["Missions\Intermission_%1.sqf",(RALLYUP_MissionsIntermission select floor random count RALLYUP_MissionsIntermission)];
			_PrimaryStringText = str formatText ["Missions\Primary_%1.sqf",(RALLYUP_MissionsPrimary select floor random count RALLYUP_MissionsPrimary)];
			_SecondaryStringText = str formatText ["Missions\Secondary_%1.sqf",(RALLYUP_MissionsSecondary select floor random count RALLYUP_MissionsSecondary)];
		
		// Intermission Mission. Waits until completed
			_Launch_IntermissionMissions = [_spawnUpdate] execVM format["%1",_IntermissionStringText];
				waitUntil{sleep 5;scriptdone _Launch_IntermissionMissions};				
				
			// Update Spawn
				_spawnUpdate = [AllPlayers] call RALLYUP_fnc_Position_3dCenter;
				[(RallyUpBluFor select 0),_spawnUpdate] call RALLYUP_fnc_task_UpdateSpawns;
						
		// Primary and Secondary missions. Waits until Primary is completed
			_Launch_SecondaryMissions = [_spawnUpdate] execVM format["%1",_SecondaryStringText];
			sleep (RALLYUP_TimeOutSec/20);
			_Launch_PrimaryMissions = [_spawnUpdate] execVM format["%1",_PrimaryStringText];
				waitUntil{sleep 5;scriptdone _Launch_PrimaryMissions};
		
			// Update Spawn
				_spawnUpdate = [AllPlayers] call RALLYUP_fnc_Position_3dCenter;
				[(RallyUpBluFor select 0),_spawnUpdate] call RALLYUP_fnc_task_UpdateSpawns;				
				[(RallyUpOpFor select 0),500] spawn RALLYUP_fnc_task_CleanUp;
				
	};

if(true) exitWith {endMission "END1"};
