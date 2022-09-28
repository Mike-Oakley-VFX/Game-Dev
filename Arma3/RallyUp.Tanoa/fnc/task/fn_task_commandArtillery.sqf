/*
	Author: CodeRedFox	
	Function: Cleans up the scene of any left over units and vehicles.	
	Usage: [ _group , _target,_mortarTypes ] spawn RALLYUP_fnc_task_commandArtillery;
	Example: [ _group , _target,_mortarTypes ] spawn RALLYUP_fnc_task_commandArtillery;
*/

	_group = _this select 0;
	_target = _this select 1;
	_mortarTypes = _this select 2;
	_mortarSelect = _mortarTypes select floor random count _mortarTypes;
	_randPOS = [0,0,0];

	{								
		
		_randPOS = [getpos _target, random 100, random 360] call BIS_fnc_relPos;
		_mortarVeh = vehicle _x;
		_mortarVeh setvehicleammo 1;
		_mortarRounds = random 3;	
		_x commandArtilleryFire [ _randPOS ,_mortarSelect,_mortarRounds];

	} foreach units _group;

diag_log format ["RallyUp : RALLYUP_fnc_task_commandArtillery |  _group %1 : _target %2 : _randPOS %3 : _mortarSelect %4",_group, _target,_randPOS,_mortarSelect];