/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [vehicle,chance] spawn RALLYUP_fnc_create_fillcargo
	Example : [vehicle,group] spawn RALLYUP_fnc_create_fillcargo;
	Returns: N/A

*/
	_vehicle = _this select 0;	
	_group = _this select 1;
			
	_emptyPositions = (_vehicle emptyPositions "cargo") ;

	while { _vehicle emptyPositions "cargo" > 0	} do {
		_SelectEnemyUnit = RALLYUP_Random_EnemyInf select floor random count RALLYUP_Random_EnemyInf;
		_Enemy = _group createUnit [_SelectEnemyUnit, [0,0] , [], 0, "CARGO"];
		_Enemy moveInCargo _vehicle;
		_Enemy assignAsCargo _vehicle;
	};

	// sometimes cargo is not assigned correctly because of ["cargo", [turret path]]
	{ if (count assignedVehicleRole _x == 0) then {deleteVehicle _x;}; } forEach units _group;

	// Strip ai og NVG for fun
	if (RALLYUP_AINVG ==1) then {
		{
			_x unassignItem (hmd _x);
			_x removeItem (hmd _x);
			_x addPrimaryWeaponItem "acc_flashlight";
		} foreach units _group;
	};
	_group enablegunlights "forceOn";
	_group setBehaviour "SAFE";
	_group setformation (RALLYUP_formationMode select floor random count RALLYUP_formationMode);

	_RETURN = [ _vehicle,_emptyPositions,count units _group,_group,count units _group ];


diag_log format ["RallyUp : RALLYUP_fnc_create_fillcargo | Vehicle : %1 Cargo : %2 : Units : %3", _RETURN select 0, _RETURN select 1,_RETURN select 2];
//hint format ["RallyUp : RALLYUP_fnc_create_fillcargo | Vehicle : %1 Cargo : %2 : Units : %3",_RETURN select 0,_RETURN select 1,_RETURN select 2];
_RETURN