/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,TYPE,min,max,amount] spawn RALLYUP_fnc_create_Enemy
	Example: [position player,200,300,["Helicopters"],1] spawn RALLYUP_fnc_create_Enemy;
	Returns: N/A
*/	

	_position = _this select 0;	
	_min = _this select 1;
	_max = _this select 2;
	_type = _this select 3;
	_amount = ceil random (_this select 4);
	_actions = _this select 5;

	
	
	_foundLocation = _position;
	_direction = 180;
	
	_EnemyGroup = createGroup (RallyUpOpFor select 0);	
	if (count allunits < 50) then {
		
		_combatMode = RALLYUP_combatMode;
		_formationMode = RALLYUP_formationMode;		
		
		_typeArray = _type select floor random count _type;	
		
		_SetcombatMode = (RALLYUP_combatMode select floor random count RALLYUP_combatMode);
		_SetformationMode = (RALLYUP_formationMode select floor random count RALLYUP_formationMode);	
		_SetSpeedMode = (RALLYUP_SpeedMode select floor random count RALLYUP_SpeedMode);
				
		for "_i" from 1 to _amount do {		
		
			_direction = random 360;
			if (_max != 0) then {
				_foundLocation = [_position, 0, _max, 2, 0, 45, 0] call BIS_fnc_findSafePos;
				_direction = ([_foundLocation, _position] call BIS_fnc_dirTo)-180;
			};				

			switch (_typeArray) do {
				case "Unit": {
					_SelectEnemyGroup = (RALLYUP_Groups_EnemyInf select floor random count RALLYUP_Groups_EnemyInf) select 1;
					_SelectEnemyUnit = _SelectEnemyGroup select floor random count _SelectEnemyGroup;
					_Enemy = _EnemyGroup createUnit [_SelectEnemyUnit, _foundLocation, [], 0, "NONE"];

				};
				case "Group": {
					_SelectEnemyGroup = (RALLYUP_Groups_EnemyInf select floor random count RALLYUP_Groups_EnemyInf) select 1;
					_Enemy = [_foundLocation, (RallyUpOpFor select 0), _SelectEnemyGroup] call BIS_fnc_spawnGroup;
					{
						[_x] join _EnemyGroup;
					} foreach units _Enemy;
				};
				case "Static": {
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyStatic select floor random count RALLYUP_Groups_EnemyStatic) select 1;
					_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
					_Enemy = [_foundLocation, _direction,_SelectEnemyGroup, _EnemyGroup] call bis_fnc_spawnvehicle;

				};
				case "Vehicles": {
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyMech select floor random count RALLYUP_Groups_EnemyMech) select 1;
					_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
					_Enemy = [_foundLocation, _direction,_SelectEnemyGroup, _EnemyGroup] call bis_fnc_spawnvehicle;
					[_Enemy select 0,0.5,_position] spawn RALLYUP_fnc_create_fillcargo;

				};
				case "Boats": {	
							
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyBoats select floor random count RALLYUP_Groups_EnemyBoats) select 1;
					_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;						
					_foundLocation = [_position, 0, 1000, 5, 2, 45, 0] call BIS_fnc_findSafePos;					
					_Enemy = [_foundLocation, _direction,_SelectEnemyGroup, _EnemyGroup] call bis_fnc_spawnvehicle;
					[_Enemy select 0,1,_position] spawn RALLYUP_fnc_create_fillcargo;

				};				
				
				case "Helicopters":	{
					_foundLocation = [_position, 3000, (random 360)] call BIS_fnc_relPos;
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyHelicopters select floor random count RALLYUP_Groups_EnemyHelicopters) select 1;
					_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
					_Enemy = [_foundLocation, _direction,_SelectEnemyGroup, _EnemyGroup] call bis_fnc_spawnvehicle;
					[_Enemy select 0,0.3,_position] spawn RALLYUP_fnc_create_fillcargo;
					[_Enemy select 0] spawn RALLYUP_fnc_task_OpenDoors;
					
				};
				case "Jets": {
					_foundLocation = [_position, 5000, (random 360)] call BIS_fnc_relPos;
					_SelectEnemyGroupArray = (RALLYUP_Groups_EnemyJets select floor random count RALLYUP_Groups_EnemyJets) select 1;
					_SelectEnemyGroup = _SelectEnemyGroupArray select floor random count _SelectEnemyGroupArray;
					_Enemy = [_foundLocation, _direction,_SelectEnemyGroup, _EnemyGroup] call bis_fnc_spawnvehicle;

				};
			};
			
			if (_actions == "NONE") then { (leader (group _EnemyGroup) ) commandMove _position};	
			if (_actions == "PATROL") then { [_EnemyGroup, _position, _min] call bis_fnc_taskPatrol;};
			if (_actions == "DEFEND") then { [_EnemyGroup, _position, _min] call bis_fnc_taskDefend;};
			
			_EnemyGroup setBehaviour _SetcombatMode;
			_EnemyGroup setformation _SetformationMode;
		
		};			
	};

// SERVER ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_create_EnemyForces | _EnemyGroup = %1",count units _EnemyGroup];
RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS+(units _EnemyGroup);

