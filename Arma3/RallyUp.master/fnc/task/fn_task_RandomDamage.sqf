/*
	Author: CodeRedFox	
	Function: Finds and assigns random damage to parts of a vehicle
	Usage: [vehicle] spawn RALLYUP_fnc_task_RandomDamage;
	Returns: randomly damages vehicle
*/ 


	_vehicle = _this select 0;		
	
	{
		_vehicle setHit [(((getAllHitPointsDamage _vehicle) select 1) select _forEachIndex),random 0.95];	
	} foreach (getAllHitPointsDamage _vehicle select 1);

diag_log format ["RallyUp : RALLYUP_fnc_task_RandomDamage | Vehicle : %1",_vehicle];	