/*
	Author: CodeRedFox	
	Function: Find the centre position of all players and their AI
	Usage: [array] call RALLYUP_fnc_Position_3dCenter;
	Example : [AllPlayers] call RALLYUP_fnc_Position_3dCenter;
	Returns: Center Position = _mathmeanpos
*/

	_type = _this select 0; // allplayers
	_test = 0;
	
	_position = [0,0,0];
	
	//_UnitsArray = {units group _x} foreach _type;
	_UnitsArray = _type;
	_mathmeanpos = _position;
	
	waitUntil {
		if (count _UnitsArray > 0) then {
			{
				_position = [
					(_position select 0)+(getpos _x select 0),
					(_position select 1)+(getpos _x select 1),
					(_position select 2)+(getpos _x select 2)
				];
			
			} forEach _UnitsArray;

			_UnitsArrayCount = count _UnitsArray;	
			_mathmeanpos = [
				(_position select 0) / _UnitsArrayCount,
				(_position select 1) / _UnitsArrayCount,
				(_position select 2) / _UnitsArrayCount
			];		
		};
			if (str _mathmeanpos != "[0,0,0]") exitwith {true};
			false;
	};
	
	_POSITIONRETURN = _mathmeanpos;
	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_Position_3dCenter | _POSITIONRETURN = %1",_POSITIONRETURN];		
_POSITIONRETURN
