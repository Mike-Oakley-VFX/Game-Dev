/*
	Author: CodeRedFox	
	Function: Updates Intel
	Usage: 		[_intelName, _side, _targetObj, _chance, _strength ] call RALLYUP_fnc_task_intel;
	Example:	[_intelName, RALLYUP_Enemy_Side, unit, 1, 2 ] call RALLYUP_fnc_task_intel;
	
	Returns: NA
*/
diag_log format ["RallyUp : RALLYUP_fnc_task_intel | START %1",serverTime];
// 1 Create Intel, 2 Update Intel


	_intelName = _this select 0; // Intel name
	_side = _this select 1;
	_targetObj  = _this select 2;	
	_chance = _this select 3;
	_strength = _this select 4;

	RALLYUP_Intel = ["Land_File1_F","Land_File2_F","Land_FilePhotos_F","Land_Map_F","Land_Map_unfolded_F","Land_Notepad_F",	"Land_Photos_V1_F"];


	if ( (random 1 <= _chance) && (side _x == _side) ) then {
		{	

			_randomTime = random 5+1;

			[
				_x,											// Object the action is attached to
				"Search",										// Title of the action
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
				"_this distance _target < 3",						// Condition for the action to be shown
				"!alive _this",						// Condition for the action to progress
				{},													// Code executed when action starts
				{
						_intelType = RALLYUP_Intel select floor random count RALLYUP_Intel;						
						_intel = createVehicle [_intelType, [getpos _target select 0,getpos _target select 1,getpos _target select 2], [], 0, 'CAN_COLLIDE'];
						_intel setVelocity [ random [-5, 0, 5] , random [-5, 0, 5], 3];
									
				},													// Code executed on every progress tick
				{
					_oldPOS = _intelName call BIS_fnc_taskDestination;

					_oldPOS distance (( getpos _targetObj ) / _strength) ;

					_newPos = [ getpos _targetObj, _radius, random 360 ] call BIS_fnc_relPos;

					[_intelName,_newPos] call BIS_fnc_taskSetDestination;

				},				// Code executed on completion
				{},													// Code executed on interrupted
				[],													// Arguments passed to the scripts as _this select 3
				_randomTime,													// Action duration [s]
				0,													// Priority
				true,												// Remove on completion
				false												// Show in unconscious state
			] call bis_fnc_holdActionAdd;

			diag_log format ["RallyUp : RALLYUP_fnc_task_intel | %1 | %2 | %3",_x,_intelName,_targetObj];
					
		} foreach allUnits;
	};