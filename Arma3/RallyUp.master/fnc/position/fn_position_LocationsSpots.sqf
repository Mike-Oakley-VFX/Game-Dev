/*
	Author: CodeRedFox	
	Function: Finds the closest building and returns the position locations inside
	Usage: [position] call RALLYUP_fnc_position_LocationsSpots;
	Example : [position player] call RALLYUP_fnc_position_LocationsSpots;
	Returns: 
		_PickLocation select 0 = Randomly picked position
		_PickLocation select 1 = The amount of positions
		_PickLocation select 2 = Array of all positions
*/

	_position = _this select 0;
	
	_BuildingTypes = RALLYUP_BuildingTypes;

	_ARRAYRETURN = [];	
	_FoundLocations = [];	
	_PickLocation = [];
	_Location = [];
	_PickSpots = [];
	_max = 100;	
		

		While {count _FoundLocations < 10} do {	
			_FoundLocations = nearestObjects [_position, _BuildingTypes, _max];
			_max = _max + 100;
		};

		While {count _PickSpots < 3} do { 	
		
			_PickedLocations = _FoundLocations select floor random count _FoundLocations;
					
			_PickSpots = [_PickedLocations] call BIS_fnc_buildingPositions;
			
			_PickLocation = _PickSpots select floor random count _PickSpots;
		};
		
		_Location = [_PickLocation,count _PickSpots,_FoundLocations];	
		
	_ARRAYRETURN = _Location;

	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_position_LocationsSpots | _ARRAYRETURN = %1",_ARRAYRETURN select 0];	
_ARRAYRETURN
