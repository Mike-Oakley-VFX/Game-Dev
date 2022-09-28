/*
	Author: CodeRedFox	
	Function: Updates Intel
	Usage: [IntelName, Type, [x,y], [x,y], Strength] call RALLYUP_fnc_update_intel;
	Example: [IntelName, _targetPos, ] call RALLYUP_fnc_create_intel;
	Returns: Position [x,y,z]
*/

	// Variables



		_intelName = _this select 0;
		_type = _this select 1; 
		_taskPos = _this select 2;
		_targetPos  = _this select 3;
		_strength = = _this select 4;
		_radius = 0;


		// 1 Create Intel, 2 Update Intel
		switch (_type) do
		{
			default { hint "default" };
			
			case 1: { hint "1" };
			case 2: { 
				_radius =() _taskPos distance _targetPos) \ _strength;
				_newPos = [_targetPos, _radius, random 360] call BIS_fnc_relPos;
				_intelName = false;

				_RETURN = _newPos;			
			};
 

_RETURN // return
