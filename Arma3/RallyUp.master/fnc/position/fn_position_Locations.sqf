/*
	Author: CodeRedFox	
	Function: Finds and picks a random location
	Usage: [_position,_min,_max,,] call RALLYUP_fnc_position_Locations;
	Example : [position player,500,1500,RALLYUP_LocationsPopulace,5] call RALLYUP_fnc_position_Locations; 
	Returns: Position w/ ATL Correction  = _PickLocation		
*/


	_position = _this select 0;
	_min = _this select 1;
	_max = _this select 2;
	_type = _this select 3;
	_amount = _this select 4;
	
	_PickLocation = [0,0,0];
	
	While {str _PickLocation == "[0,0,0]"} do {
		_FindLocations = []; _FoundLocations = [];	
		
			While {count _FindLocations < _amount} do {			
				_FindLocations = nearestLocations [_position, _type, _max];
				_max = _max + 100;
			};
					
			{
				if ((_position distance _x > _min) and (_position distance _x < _max) ) then {
					_FoundLocations pushBack _x;
				};	
			} foreach _FindLocations;		
			
			_FindLocation = _FoundLocations select floor random count _FoundLocations;
			_PickFindLocations = [position _FindLocation, 1, 100, 1, 0, 20, 0] call BIS_fnc_findSafePos;
			_PickLocation = [_PickFindLocations select 0,_PickFindLocations select 1,0];
	};
	
	_POSITIONRETURN = _PickLocation;
	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_position_Locations | _POSITIONRETURN = %1",_POSITIONRETURN];		
_POSITIONRETURN
