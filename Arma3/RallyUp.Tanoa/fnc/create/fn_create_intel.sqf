/*
	Author: CodeRedFox	
	Function: Adds AI to team wityh a limit
	Usage: [unit, side, chance] call RALLYUP_fnc_create_intel;
	Example: [RALLYUP_Enemy_Side, 1] call RALLYUP_fnc_create_intel;
	Returns: N/A
*/

	if ( !isServer) exitwith {};

	// Variables
	  _side = _this select 0;
	  _chance = _this select 1;
	
	{		
		if ( (random 1 <= _chance) && (side _x == _side) ) then {
			_x addAction [
				"<t color=RALLYUP_COLORHEX  t size='2'>Search</t>",
				{
					params ["_target", "_caller", "_actionId", "_arguments"];			

					_intelType = RALLYUP_Intel select floor random count RALLYUP_Intel;
					//_intel = _intelType createVehicle [getpos _target select 0,getpos _target select 1,5];
					_intel = createVehicle [_intelType, [getpos _target select 0,getpos _target select 1,1], [], 0, "CAN_COLLIDE"];
					_intel setVelocity [(random 1)-2, (random 1)-2, 2];	
					_intel addAction ["<t color=RALLYUP_COLORHEX  t size='2'>Take Intel</t>",
						{
							params ["_target"];
							RALLYUP_Intel_Updated = true;
							deletevehicle _target;
						},nil,1.5,true,true,"","true",5,false,"",""
					];								
					removeAllActions _target;
				} ,	nil,1.5,true,true,"","!alive _target",5,false,"",""
				
			];
		};
	} foreach allUnits;