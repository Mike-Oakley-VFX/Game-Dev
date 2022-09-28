/*
	Author: CodeRedFox	
	Function: Adds inherit velocity
	Usage: [parent,child,speed] call RALLYUP_fnc_task_inheritvelocity;
	Example: 
*/ diag_log format ["RallyUp : RALLYUP_fnc_task_CleanUp | %1 | %2",time,serverTime];
	
	_parentobj = _this select 0;
	_childobj = _this select 1;
	_speed = _this select 2;
	
	_vel = velocity _parentobj;
	_dir = direction _parentobj;
	
	_childobj setVelocity [
		(_vel select 0) + (sin _dir * _speed), 
		(_vel select 1) + (cos _dir * _speed), 
		(_vel select 2)
	];

if(true) exitWith {};
