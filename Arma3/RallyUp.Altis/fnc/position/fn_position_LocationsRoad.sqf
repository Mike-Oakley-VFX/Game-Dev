/*
	Author: CodeRedFox	
	Function: Finds a minimum of 100 closest roads
	Usage: [position,min,max] call RALLYUP_fnc_position_LocationsRoad;
	Example : [position player,10,500] call RALLYUP_fnc_position_LocationsRoad;
	Returns: position
*/
	
	_position = _this select 0;
	_min = _this select 1;
	_max = _this select 2;
	
	_FindLocations = [];
	_FoundLocations = [];	
	
	_PickLocation = [0,0,0];
	
	While {str _PickLocation == "[0,0,0]"} do {	
		While {count _FindLocations < 10} do {		
			_FindLocations = _Position nearRoads _max;
			_max = _max + 100;
		};
				
		{
			if ((_position distance _x > _min) and (_position distance _x < _max)) then {
				_FoundLocations pushBack _x;
			};	
		} foreach _FindLocations;		
		
		_PickFindLocations = _FoundLocations select floor random count _FoundLocations;

		_PickLocation = [position _PickFindLocations select 0,position _PickFindLocations select 1,0];	
	
	};
	
	_POSITIONRETURN = _PickLocation;

// RETURN ------------------------------				
diag_log format ["RallyUp : RALLYUP_fnc_position_LocationsRoads | _POSITIONRETURN = %1",_POSITIONRETURN];		
_POSITIONRETURN
