/*
	Author: CodeRedFox	
	Function: Finds random building from position
	Usage: [position,min,max] call RALLYUP_fnc_position_LocationsBuilding;
	Example : [position player,100,500] call RALLYUP_fnc_position_LocationsBuilding;
	Returns: Building position = _PickLocation		
*/

	_position = _this select 0;
	_min = _this select 1;
	_max = _this select 2;
	
	_BuildingTypes = RALLYUP_BuildingTypes;
	_FindLocations = [];
	_FoundLocations = [];	

	_PickLocation = [0,0,0];
	
	While {str _PickLocation == "[0,0,0]"} do {
		While {count _FindLocations < 25} do {		
			_FindLocations = nearestObjects [_Position, _BuildingTypes, _max];	
			_max = _max + 100;
		};
				
		{
			if (_x call BIS_fnc_isBuildingEnterable) then {
				if ((_position distance _x > _min) and (_position distance _x < _max)) then {
					_FoundLocations pushBack _x;
				};
			};
		} foreach _FindLocations;		
		
		_PickFindLocations = _FoundLocations select floor random count _FoundLocations;

		_PickLocation = [position _PickFindLocations select 0,position _PickFindLocations select 1,0];

	};

	_POSITIONRETURN = _PickLocation;
	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_position_LocationsBuilding | _POSITIONRETURN = %1",_POSITIONRETURN];		
_POSITIONRETURN
