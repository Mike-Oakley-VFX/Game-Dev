/*
	Author: CodeRedFox	
	Function: Gets the info about a target
	Usage: [] call RALLYUP_fnc_text_GetInfo;
	Returns: 
		Name = ([] call RALLYUP_fnc_text_GetInfo) select 0
		Picture/Image = ([] call RALLYUP_fnc_text_GetInfo) select 1;		
*/ 

_target = _this select 0;

	_Name = name _target;	
	_displayName = getText (configFile >> "CfgVehicles" >> (typeOf _target) >> "displayName");
	_displaypicture = getText (configFile >> "cfgVehicles" >> typeOf _target >> "picture");
	_displayGenericNames = getText (configFile >> "cfgVehicles" >> typeOf _target >> "genericNames");
	_displayIcon = getText (configFile >> "cfgVehicles" >> typeOf _target >> "Icon");
	_rank = rank _target;
  
		_targetInfo = [
			_Name,
			_displayName,
			_displaypicture,
			_displayIcon,
			_rank			
		];
	
//diag_log format ["RallyUp : RALLYUP_fnc_text_GetInfo | %1 | %2",serverTime,_targetInfo];	
_targetInfo
