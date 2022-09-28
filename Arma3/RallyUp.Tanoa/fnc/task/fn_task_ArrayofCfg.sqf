/*
	Author: CodeRedFox	
	Function: Gets array of CfgVehicles
	USEAGE:	_var = [SIDE, Faction, ARRAY Types, ARRAY Excluded names , ARRAY Must Contain Attrib] call RALLYUP_fnc_task_ArrayofCfg;
	EXAMPLE: _var = [RALLYUP_Friend_Side, RALLYUP_Friend_Faction, ["Men"], ["_unarmed_"] , [""]] call RALLYUP_fnc_task_ArrayofCfg;
	Returns: Array list of objects		
	
*/

// Varibles

	_pickedSide = _this select 0; // WEST
	_pickedFaction = _this select 1; // BLU_F
	_pickedClass = _this select 2; // ARRAY vehicleClass = Men, Static, Ship, Car, Air, Ammo, Autonomous
	_pickedRemove = _this select 3; // ARRAY ["_unarmed_"]
	_pickedMustHave = _this select 4; // ARRAY	["transportSoldier"]
	
	_hasList= [];
	_removeList =  [];
	_ARRAYRETURN = [];
	_classNames = '';
	_configs	= [];
	_pickedSideInt = _pickedSide;

	// Converts TEXT to INT
	switch ( _pickedSide ) do
	{
		case EAST : { _pickedSideInt = 0 };
		case WEST :{ _pickedSideInt = 1 };
		case Independent : { _pickedSideInt = 2 };
		case Civilian : { _pickedSideInt = 3 };
	};

// Get all _pickedSide, _pickedFaction and _pickedClass
	_configs = 
	" 
		getNumber (_x >> 'scope') >= 2 &&
		getNumber (_x >> 'side') == _pickedSideInt &&
		getText (_x >> 'faction') == _pickedFaction &&
		getText (_x >> 'vehicleClass') == _pickedClass
	" configClasses (configFile >> "CfgVehicles");
	_classNames = _configs apply {configName _x};


// Find and remove _pickedRemove
	_pickedRemoveList =  [];
	{
		_findType = _x;
			{
				if ( [_findType,_x ] call BIS_fnc_inString == true) then {	
					_pickedRemoveList pushBack _x;
					};
			} foreach _classNames;
	} foreach _pickedRemove;
	_pickedRemoveListFinal = _classNames - _pickedRemoveList;

// Find and keep only _pickedMustHave
	_pickedMustHaveList =  [];
	{
		_findType = _x;
			{
				if ( (getNumber (configFile >> "CfgVehicles" >> _x >> _findType )) == 0 ) then {
					_pickedMustHaveList pushback _x;	
				};
			} foreach _pickedRemoveListFinal;
	} foreach _pickedMustHave;
	
	_FinalList = _pickedRemoveListFinal - _pickedMustHaveList;

_ARRAYRETURN = _FinalList;
	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_task_ArrayofCfg | Return %1 %2 %3 : %4 : %5",_pickedSideInt,_pickedSide,_pickedFaction, count _ARRAYRETURN,_ARRAYRETURN];
_ARRAYRETURN