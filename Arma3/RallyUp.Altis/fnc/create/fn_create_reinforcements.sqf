/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,amount,["type"]] spawn RALLYUP_fnc_create_reinforcements;
	Example: [position player,5,["Units"]] spawn RALLYUP_fnc_create_reinforcements;
	Returns: N/A
	
	_type ["Units","Vehicles","Helicopters","ParaTroops"]
*/
		//private ["_Enemy","_CreatedEnemy"];
		
		
		_position = _this select 0;	
		_amount = ceil random (_this select 1);
		_type = _this select 2;			
		
		//_type = ["Units","Vehicles","Helicopters","ParaTroops"];
		_combatMode = RALLYUP_combatMode;
		_formationMode = RALLYUP_formationMode;		
		
		_RALLYUP_Random_EnemyInf = [RALLYUP_EnemySide,["_Soldier_"], ["_VR_","_crew_","VirtualCurator_F","_diver_"] ] call RALLYUP_fnc_task_ArrayofCfg;	
		_RALLYUP_Random_EnemyMech = [RALLYUP_EnemySide,["_Apc_","Truck_F","Offroad_","MRAP"], "" ] call RALLYUP_fnc_task_ArrayofCfg;
		_RALLYUP_Random_Static = [RALLYUP_EnemySide,["StaticAAWeapon","StaticATWeapon","StaticGrenadeLauncher","StaticMGWeapon",""], "StaticMortar" ] call RALLYUP_fnc_task_ArrayofCfg;	
		_RALLYUP_Random_HelicoptersTransport = [RALLYUP_EnemySide,["Heli_Transport_"], "" ] call RALLYUP_fnc_task_ArrayofCfg;
		_RALLYUP_Random_Jets = [RALLYUP_EnemySide,["Plane_Base_F"], "" ] call RALLYUP_fnc_task_ArrayofCfg;
		_RALLYUP_Random_Boats = [RALLYUP_EnemySide,["Boat_F"], "" ] call RALLYUP_fnc_task_ArrayofCfg;	
		

		
		if (count allunits < 50) then {
			for "_i" from 1 to _amount do {	
				_typeArray = _type select floor random count _type;					
				hint format ["%1",_typeArray];
				if (_typeArray == "Units") then {

					_SelectEnemyGroup = _RALLYUP_Random_EnemyInf select floor random count _RALLYUP_Random_EnemyInf;
					hint format ["Array: %1 Picked: %2",_typeArray,_SelectEnemyGroup];
					_foundLocation = [_position, 300, 1000, 2, 0, 45, 0] call BIS_fnc_findSafePos;			
					_Enemy = [_foundLocation, RALLYUP_EnemySide, _SelectEnemyGroup] call BIS_fnc_spawnGroup;					
					[_Enemy, _position, (random 100)+50] call bis_fnc_taskPatrol;					
					RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS + (units _Enemy);		
					diag_log format ["RallyUp : RALLYUP_fnc_create_reinforcements | %1 = %2",_typeArray,count (units _Enemy)];	
				};			
				
				
				if (_typeArray == "Vehicles" or _typeArray == "Helicopters" or _typeArray == "Boats") then {	
					_EnemyVehGroup = createGroup RALLYUP_EnemySide;
					if (_typeArray == "Vehicles") then {
						_SelectEnemyGroup = _RALLYUP_Random_EnemyMech select floor random count _RALLYUP_Random_EnemyMech;
						_foundLocation = [_position, 1000, 2000, 2, 0, 45, 0] call BIS_fnc_findSafePos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;						
						[_EnemyVehGroup, _position, (random 100)+50] call bis_fnc_taskPatrol;
					};
					
					if (_typeArray == "Boats") then {
						_SelectEnemyGroup = _RALLYUP_Random_Boats select floor random count _RALLYUP_Random_Boats;
						_foundLocation = [_position, 1000, 2000, 2, 2, 45, 0] call BIS_fnc_findSafePos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;						
						[_EnemyVehGroup, _position, (random 100)+50] call bis_fnc_taskPatrol;
					};					
					
					if (_typeArray == "Helicopters") then {	
						
						_SelectEnemyGroup = _RALLYUP_Random_HelicoptersTransport select floor random count _RALLYUP_Random_HelicoptersTransport;

						_foundLocation = [_position, (random 5000)+2000,random 360] call BIS_fnc_relPos;
						_CreatedEnemy = [_foundLocation, 180,_SelectEnemyGroup, _EnemyVehGroup] call bis_fnc_spawnvehicle;
						[_CreatedEnemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;
						[_CreatedEnemy select 0] spawn RALLYUP_fnc_task_OpenDoors;
					};
					
					RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS + ( units _EnemyVehGroup);					
					diag_log format ["RallyUp : RALLYUP_fnc_create_reinforcements | %1 = %2",_typeArray,count ( units _EnemyVehGroup)];
					
					_foundLocation = [_position, 1000, 2000, 2, 0, 45, 0] call BIS_fnc_findSafePos;
					_VehGroupWP01 = _EnemyVehGroup addWaypoint [_position, 500];
					_VehGroupWP01 setWaypointType "TR UNLOAD";
					//_VehGroupWP01 setWaypointBehaviour "CARELESS";
					_VehGroupWP01 setWaypointSpeed "FULL";
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
					_EnemyParaGroup = createGroup RALLYUP_EnemySide;
					_height = 300;					
					_SelectEnemyGroupArray = _RALLYUP_Random_HelicoptersTransport select floor random count _RALLYUP_Random_HelicoptersTransport;						
					
						_foundLocation = [_position, (random 2000)+1000, random 360] call BIS_fnc_relPos;
						_foundLocationZ = [_foundLocation select 0,_foundLocation select 1,_height];
						
						_CreatedEnemy = [_foundLocationZ, 180,_SelectEnemyGroupArray, _EnemyParaGroup] call bis_fnc_spawnvehicle;
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
	

	