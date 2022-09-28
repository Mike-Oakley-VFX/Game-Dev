/*
	Author: CodeRedFox	
	Function: Adds AI to team wityh a limit
	Usage: [] spawn RALLYUP_fnc_create_requestteammates
	Returns: N/A
*/ 


	_object = _this select 0;	
	
	_object addAction ["<t color=RALLYUP_COLORHEX  t size='2'>Request a teammate</t>",
		'
			_Unit = _this select 1;
			if (count units group _Unit < 4) then {			
				
				_RALLYUP_UnitsArray = RALLYUP_Reinforcements select floor random count RALLYUP_Reinforcements;
				
				_yourteammate = _RALLYUP_UnitsArray createUnit [getpos _Unit, (group _Unit)];
										
			} else {hint "Maximum Fireteam Reached"};
		', player
	];
	
