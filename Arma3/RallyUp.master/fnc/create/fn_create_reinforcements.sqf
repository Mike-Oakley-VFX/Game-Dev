/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,amount] spawn RALLYUP_fnc_create_reinforcements
	Example: [position player,5] spawn RALLYUP_fnc_create_reinforcements
	Returns: N/A
*/
		//private ["_Enemy","_CreatedEnemy"];
		
		
		_position = _this select 0;	
		_amount = ceil random (_this select 1);	
		
		//_type = ["Units","Vehicles","Helicopters","ParaTroops"];
		_type = ["ParaTroops"];
		_combatMode = RALLYUP_combatMode;
		_formationMode = RALLYUP_formationMode;		
		
		
		if (count allunits < 50) then {
			for "_i" from 1 to _amount do {	
				_typeArray = _type select floor random count _type;	
				
				if (_typeArray == "Units") then {

					_SelectEnemyGroup = (RALLYUP_Groups_EnemyInf select floor random count RALLYUP_Groups_EnemyInf) select 1;
					_foundLocation = [_position, 300, 1000, 2, 0, 45, 0] call BIS_fnc_findSafePos;			
					_Enemy = [_foundLocation, (RallyUpOpFor select 0), _SelectEnemyGroup] call BIS_fnc_spawnGroup;					
					[_Enemy, _position, (random 100)+50] call bis_fnc_taskPatrol;					
					RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS + (units _Enemy);		
					diag_log format ["RallyUp : RALLYUP_fnc_create_reinforcements | %1 = %2",_typeArray,count (units _Enemy)];	
				};
				
				
				if (_typeArray == "Vehicles" or _typeArray == "Helicopters") then {	
					_EnemyVehGroup = createGroup (RallyUpOpFor select 0);
					if (_typeArray == "Vehicles") then {
						_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyMech select floor random count RALLYUP_Groups_EnemyMech) select 1;
						_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
						_foundLocation = [_position, 1000, 2000, 2, 0, 45, 0] call BIS_fnc_findSafePos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;						
						[_EnemyVehGroup, _position, (random 100)+50] call bis_fnc_taskPatrol;
					};
					
					if (_typeArray == "Boats") then {
						_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyMech select floor random count RALLYUP_Groups_EnemyMech) select 1;
						_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
						_foundLocation = [_position, 1000, 2000, 2, 0, 45, 0] call BIS_fnc_findSafePos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;						
						[_EnemyVehGroup, _position, (random 100)+50] call bis_fnc_taskPatrol;
					};					
					
					if (_typeArray == "Helicopters") then {	

						_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyHelicopters select floor random count RALLYUP_Groups_EnemyHelicopters) select 1;
						_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;

						_foundLocation = [_position, (random 5000)+2000,random 360] call BIS_fnc_relPos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;
						[_CreatedEnemy select 0] spawn RALLYUP_fnc_task_OpenDoors;
					};
					
					RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS + ( units _EnemyVehGroup);					
					diag_log format ["RallyUp : RALLYUP_fnc_create_reinforcements | %1 = %2",_typeArray,count ( units _EnemyVehGroup)];
					
					_VehGroupWP01 = _EnemyVehGroup addWaypoint [_position, 500];
					_VehGroupWP01 setWaypointType "TR UNLOAD";
					_VehGroupWP01 setWaypointBehaviour "CARELESS";
					_VehGroupWP01 setWaypointStatements ["true", "
						{(vehicle _x) land 'GET OUT'} foreach thisList;
						{
							{
								unassignVehicle _x;
								[_x] ordergetin false;
							} forEach (assignedcargo vehicle _x);
						} forEach thisList;
					"];
											
						
					_VehGroupWP02 = _EnemyVehGroup addWaypoint [_position, 100];		
					_VehGroupWP02 setWaypointType "Loiter";
					_VehGroupWP02 setWaypointLoiterType "CIRCLE";				
					_VehGroupWP02 setWaypointLoiterRadius 500;
					_VehGroupWP01 setWaypointBehaviour "AWARE";	
					
					_VehGroupWP03Despawn = [_position, 2000, 4000, 2, 0, 45, 0] call BIS_fnc_findSafePos;
					_VehGroupWP03 = _EnemyVehGroup addWaypoint [_VehGroupWP03Despawn, 500];
					_VehGroupWP03 setWaypointType "MOVE";
					_VehGroupWP03 setWaypointStatements ["true", "
						{deleteVehicle vehicle _x} forEach thislist;
						{deleteVehicle _x} forEach thislist;
						deleteGroup (group this);
					"];
					
				
					
				};
				
				if (_typeArray == "ParaTroops") then {
					_EnemyParaGroup = createGroup (RallyUpOpFor select 0);
					_height = 300;
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyHelicopters select floor random count RALLYUP_Groups_EnemyHelicopters) select 1;
						_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
						_foundLocation = [_position, (random 2000)+1000, random 360] call BIS_fnc_relPos;
						_foundLocationZ = [_foundLocation select 0,_foundLocation select 1,_height];
						
						_CreatedEnemy = [_foundLocationZ, 180,_SelectEnemyGroup, _EnemyParaGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;
						(_CreatedEnemy select 0) flyinheight _height;
						
					RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS + ( units _EnemyParaGroup);	
					diag_log format ["RallyUp : RALLYUP_fnc_create_reinforcements | %1 = %2",_typeArray,count ( units _EnemyParaGroup)];	
						
					_VehGroupWP01 = _EnemyParaGroup addWaypoint [_position, 750];
					_VehGroupWP01 setWaypointType "MOVE";
					_VehGroupWP01 setWaypointCompletionRadius 100;
					_VehGroupWP01 setWaypointBehaviour "CARELESS";					
					_VehGroupWP01 setWaypointStatements ["true", "
						{(vehicle _x) flyinheight _height} foreach thisList;
						{
							{		
								[_x] spawn RALLYUP_fnc_task_Paratroopers
							} forEach (assignedcargo vehicle leader _x);
						} forEach thisList;
						
					"];				
					
					_VehGroupWP02Despawn = [_position, (random 2000)+1000, random 360] call BIS_fnc_relPos;
					_VehGroupWP02 = _EnemyParaGroup addWaypoint [_VehGroupWP02Despawn, 500];
					_VehGroupWP02 setWaypointType "MOVE";
					_VehGroupWP02 setWaypointStatements ["true", "
						{deleteVehicle vehicle _x} forEach thislist;
						{deleteVehicle _x} forEach thislist;
						deleteGroup (group this);
					"];	
				};
			};
		};
	

	