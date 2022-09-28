
/*
	Author: CodeRedFox	
	Function: Adds
	Usage: [] spawn RALLYUP_fnc_task_addaction
	[[OBJECT,"TEXT","GlobalVAR = true;publicVariableServer 'GlobalVAR'"],"RALLYUP_fnc_task_addaction", true,true] call BIS_fnc_MP;		
	Returns: N/A
*/ diag_log format ["RallyUp : RALLYUP_fnc_task_addaction | %1 | %2",time,serverTime];

	_object = _this select 0;
	_text = _this select 1;
	_variable = _this select 2;
	
	_object addAction [_text,_variable];
	

