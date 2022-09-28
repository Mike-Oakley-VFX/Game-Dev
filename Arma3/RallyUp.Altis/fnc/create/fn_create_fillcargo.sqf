/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,chance] spawn RALLYUP_fnc_create_fillcargo
	Example : [position player,0.2] spawn RALLYUP_fnc_create_fillcargo;
	Returns: N/A

*/

	_Vehicle = _this select 0;	
	_Chance = _this select 1;
	_destination = _this select 2;	
			
	_EnemyGroup = createGroup (RallyUpOpFor select 0);	
	_emptyPositions = _Vehicle emptyPositions "cargo";
	
	for "_i" from 1 to _emptyPositions do {		
		if (_Chance >= random 1) then {
			
			_SelectEnemyGroup = [RALLYUP_EnemySide,["_Soldier_"], ["_VR_","_crew_","VirtualCurator_F","_diver_"] ] call RALLYUP_fnc_task_ArrayofCfg;	
			_SelectEnemyUnit = _SelectEnemyGroup select floor random count _SelectEnemyGroup;

			_Enemy = _EnemyGroup createUnit [_SelectEnemyUnit, getpos _Vehicle, [], 0, "NONE"];	
				
			_Enemy assignAsCargo _Vehicle;
			_Enemy moveinCargo _Vehicle;
			
			_Enemy unassignItem "NVGoggles";
			_Enemy removeItem "NVGoggles";
			_Enemy addPrimaryWeaponItem "acc_flashlight";
			
		};		
		
	};
	

	if (!isNil "_destination") then {
		_SetcombatMode = (RALLYUP_combatMode select floor random count RALLYUP_combatMode);
		_SetformationMode = (RALLYUP_formationMode select floor random count RALLYUP_formationMode);		
		_EnemyGroup setBehaviour _SetcombatMode;
		_EnemyGroup setformation _SetformationMode;				
						
		[_EnemyGroup, _destination,(random 300)+100]  call bis_fnc_taskDefend;
	};

// SERVER ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_create_fillcargo | Vehicle : %1 %2",_Vehicle,count units _EnemyGroup];
RALLYUP_TOTAL_ENEMY_UNITS = RALLYUP_TOTAL_ENEMY_UNITS+(units _EnemyGroup);

