/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [start pos, end pos] call RALLYUP_fnc_Position_islandCheck; 
	Example : [getpos player, [0,0,0] ] execVM "fnc\position\fn_position_islandCheck.sqf"; 
	Returns: N/A

*/
	_startPosition = _this select 0;
	_endPosition = _this select 1;
	_RETURN = [0,0,0];

	_diffX = (_endPosition select 0) - (_startPosition select 0) ;
	_diffY = (_endPosition select 1) - (_startPosition select 1) ;
	_pointNum = 1000;
	_interval_X = _diffX / (_pointNum + 1);
    _interval_Y = _diffY / (_pointNum + 1);

			
	for "_i" from 1 to _pointNum do {
		_pos = [ ( _startPosition select 0 ) + _interval_X * _i, ( _startPosition select 1 ) + _interval_Y * _i	];

		_marker1 = createMarker ["Marker1"+ str _i, _pos];
		_marker1 setMarkerColor "ColorBlack";

		if ( (surfaceIsWater _pos) && (getTerrainHeightASL _pos < -15)) exitWith {		
			_marker1 setMarkerColor "ColorRed";
			_RETURN = _pos;
		};	
	};

diag_log format ["RallyUp : fn_position_islandCheck |  Boat %1",_RETURN];
_RETURN