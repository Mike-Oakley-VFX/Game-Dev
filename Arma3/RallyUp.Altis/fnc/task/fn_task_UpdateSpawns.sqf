/*
	Author: CodeRedFox	
	Function: Updates main spawn point
	Usage: [side,position] call RALLYUP_fnc_task_UpdateSpawns;
	Example : [West,position] call RALLYUP_fnc_task_UpdateSpawns;
	Returns: N/A
*/ 
	if (RALLYUP_DEBUG == true) then {hint "Loaded FNC : RALLYUP_fnc_task_UpdateSpawns";};
	
	_side = _this select 0;	
	_position = _this select 1;		
		
	_markerSpawnName = toLower format ["respawn_%1",_side];	
	
	_positionFind = [_position, 0, 100, 2, 0, 45, 0] call BIS_fnc_findSafePos;
		
		if (isnil "markerSpawnType") then {
		
			markerSpawnType = toLower format ["respawn_%1",_side];
			markerReSpawn = createMarker [_markerSpawnName, _positionFind];	
			RallyPointBackpack = "Land_TentDome_F" createVehicle _positionFind;
			
			RallyPointBackpack allowdamage false;
			RallyPointBackpack enableSimulationGlobal false;	
			
			//[west, markerReSpawn] call BIS_fnc_addRespawnPosition;
			
			[player] spawn BIS_FNC_RESPAWNMENUPOSITION;

			[[RallyPointBackpack],"RALLYUP_fnc_create_requestteammates", true,true] call BIS_fnc_MP;
			
			{				
				_RallyPosition = [_positionFind, 2, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos;	
				_x setPos [_RallyPosition select 0,_RallyPosition select 1, 0.5];	
			} foreach allplayers;		
			
		};		

		RallyPointBackpack setPos _positionFind;
		RallyPointBackpack setPosATL [position RallyPointBackpack select 0, position RallyPointBackpack select 1, 0.1];	
		
		markerReSpawn setMarkerPos _positionFind;	
		markerReSpawn setMarkerType "hd_flag";
		markerReSpawn setMarkerText "Spawn Point";
		
		// Resupply
		//[_positionFind] execVM "missions\intermission_ResupplyAmmo.sqf";
		
diag_log format ["RallyUp : RALLYUP_fnc_task_UpdateSpawns | Position : %1",_positionFind];		
if(true) exitWith {};
