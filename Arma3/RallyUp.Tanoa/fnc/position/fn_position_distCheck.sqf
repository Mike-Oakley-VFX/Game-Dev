/*
	Author: CodeRedFox	
	Function: Find the centre position of all players and their AI
	Usage: [_location, _side] call RALLYUP_fnc_position_distCheck;
	Example : [position Player, West,AllPlayers,0 ] call RALLYUP_fnc_position_distCheck;
	Returns: Center Position = _mathmeanpos
*/

	_location = _this select 0;
	_side = _this select 1;
	_type = _this select 2; // allPlayers, allUnits, allUnitsUAV, allDead, or playableUnits
	_returntype = _this select 3; // 0 = all select dist and pos. 1 = just first distance, 2 = just first position
	
	_unitArray = [];
	{
		if (alive _x) then {
				if (  side _x ==  _side) then { _unitArray pushBack [ (_x distance _location), getpos _x ]; };
		};
	} foreach _type;	
	if (count _unitArray == 0) then {_unitArray = [ [999,[0,0,0]] ];};

	_unitArray sort true;

	_RETURN = _unitArray;
	if (_returntype == 1) then { _RETURN = (_unitArray select 0) select 0 }; // 1 = just first distance,
	if (_returntype == 2) then { _RETURN = (_unitArray select 0) select 1 }; // 2 = just first position
	if (_returntype == 3) then { _RETURN = (_unitArray select (count _unitArray - 1)) select 0;	}; // 3 = farthest distance
	if (_returntype == 4) then { _RETURN = (_unitArray select (count _unitArray - 1)) select 1;	}; // 4 = farthest distance


diag_log format ["RallyUp : RALLYUP_fnc_Position_distCheck | _RETURN = %1 : %2 ",_RETURN, _side];	
_RETURN