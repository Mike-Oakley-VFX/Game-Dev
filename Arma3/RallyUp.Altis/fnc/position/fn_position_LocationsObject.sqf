/*
	Author: CodeRedFox	
	Function: Finds random Object from position
	Usage: [position,type] call RALLYUP_fnc_position_LocationsObject;
	Example : [position player,"Land_HelipadSquare_F"] call RALLYUP_fnc_position_LocationsObject;
	Returns: [object position, Objects Direction]

*/

	_position = _this select 0;
	_objectsArray = _this select 1;
	_max = 500;
	
	_FindLocations = [];
	
	_Object = _objectsArray select floor random count _objectsArray;
	
	While {count _FindLocations <= 1} do {
			_FindLocations = _position nearObjects [_Object, _max];	
			_max = _max + 1000;
	};		
	
	_PickFindLocations = _FindLocations select 0;		
	
	_objectPositon = [position _PickFindLocations select 0,position _PickFindLocations select 1,1],	
		
	_objectDirection = direction _PickFindLocations;
	
		_PickLocation = [_objectPositon,_objectDirection];
					
	_ARRAYRETURN = _PickLocation;
		

// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_position_LocationsBuilding | _ARRAYRETURN = %1",_ARRAYRETURN];		
_ARRAYRETURN
