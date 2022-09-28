/*
	Author: CodeRedFox	
	Function: Adds AI to team wityh a limit
	Usage: [] spawn RALLYUP_fnc_create_requestteammates
	Returns: N/A
*/ 

	
	_object = _this select 0;
		
	_object addAction ["<t color='#ffb400'>Request a teammate</t>",
		'
			_Unit = _this select 1;
			if (count units group _Unit < 5) then {			
				
				_RALLYUP_UnitsArray = RALLYUP_Random_FriendlyInf select floor random count RALLYUP_Random_FriendlyInf;
				
				_yourteammate = _RALLYUP_UnitsArray createUnit [getpos _Unit, (group _Unit)];				
										
			} else {hint "Maximum Fireteam Reached"};
		', player
	];
	
