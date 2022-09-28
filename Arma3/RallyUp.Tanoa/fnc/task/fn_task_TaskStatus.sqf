/*
	Author: CodeRedFox	
	Function: Cleans up the scene of any left over units and vehicles.	
	Usage: [ TaskID , INT, status, offset ] call RALLYUP_fnc_task_TaskStatus;
	Example:
		[ TaskID , 0, "SUCCEEDED", 0 ] call RALLYUP_fnc_task_TaskStatus; // Return true if main task status 
		[ TaskID , 1,  "SUCCEEDED" , 0] call RALLYUP_fnc_task_TaskStatus; // Return true if all sub tasks
*/ 

	_taskID = _this select 0;
	_type = _this select 1;
	_status = _this select 2;

	_RETURN = false;
	_subtaskCount = [];
	_subtaskStatus = 0;

	if (_type == 0) then {
			if (  ( ( [_taskID] call BIS_fnc_taskState ) == _status) && ([_taskID] call BIS_fnc_taskExists)) then {_RETURN = true;};
	};
	if (_type == 1) then {
		
		_subtaskCount = ( [_taskID] call BIS_fnc_taskChildren );
		{
			if ([_x] call BIS_fnc_taskExists==false) then {_subtaskStatus = _subtaskStatus+1;};		
			if ( [_x] call BIS_fnc_taskCompleted  ) then { _subtaskStatus = _subtaskStatus +1; };
		} foreach _subtaskCount;
		if ( _subtaskStatus ==  count _subtaskCount ) then { _RETURN = true; }
	};

diag_log format ["RallyUp : RALLYUP_fnc_task_TaskStatus | %1 : %2 : %3",_RETURN,_subtaskStatus,count _subtaskCount];
_RETURN