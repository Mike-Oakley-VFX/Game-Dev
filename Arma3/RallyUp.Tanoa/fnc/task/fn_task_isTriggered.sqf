/*
	Author: CodeRedFox	
	Function: Bool if the things are met
	Usage: [[array of units],side,position,distance to test,percentage to completion] call RALLYUP_fnc_task_isTriggered;
	Example: [Allunits,(RallyUpBluFor select 0),position player,150,75] call RALLYUP_fnc_task_isTriggered;
	Returns: Bool
*/



_units = _this select 0;	// array of units per passed variable, Allplayers, Allunits, allGroups
_side = _this select 1; // side for easy sorting
_position = _this select 2; // current position
_distance = _this select 3; // How far out 100,500,1000
_percentage = _this select 4; // percentage that need to activate the trigger event

_istriggered = false;
_counted = 0;
_countPercentage = 0;

	_unitsCounted = {_position distance _x <= _distance} count _units;		
	
	if (_unitsCounted > 0) then {
		
		{
			if(
				alive _x &&	side _x == _side &&	(_position distance _x <= _distance)
			) then {
				_counted = _counted + 1;
			};
		} forEach _units;
		
		_countPercentage = (_counted / _unitsCounted) * 100;
		if (_countPercentage >= _percentage) then {_istriggered = true};				
	};	

diag_log format ["RallyUp : RALLYUP_fnc_task_isTriggered | Bool : %1",_istriggered];	
_istriggered