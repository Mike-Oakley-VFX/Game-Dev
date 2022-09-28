/*
	Author: CodeRedFox	
	Function: Gets array of CfgVehicles
	Usage: 
	Example: [1,["_Soldier_"], ["_VR_"] ] call RALLYUP_fnc_task_ArrayofCfg;
	Returns: N/A	
	
	0 East 1 West 2 Independent	3 Civillian
	
	Helicopters
	- Heli_Attack Heli_Light Heli_Transport UAV
*/

// Varibles
	_pickedside = _this select 0;
	_pickedType = "AllVehicles";
	_pickedClass = _this select 1;
	_pickedRemove = _this select 2;
	_foundList =  [];
	_finalList =  [];
	_ARRAYRETURN = [];	

// Search and return
	_configs = 
		"	
			getNumber (_x >> 'scope') >= 2 && getNumber (_x >> 'side') == _pickedside && configName _x isKindof _pickedType
		" 
	configClasses (configFile >> "CfgVehicles");
	_classNames = _configs apply {configName _x};
	
		
// Pick only the type Type 	
	{ 
		_findType = _x;
		{
			if ( [_findType,_x ] call BIS_fnc_inString ) then {
				_foundList pushback _x;	
			};
		} foreach _classNames;		
	} foreach _pickedClass;
	
	_originallist = _foundList;
	
// Remove unwanted
	
	if (count _pickedRemove > 0) then {
		{ 
			_findType = _x;
			{
				if ( [_findType,_x ] call BIS_fnc_inString ) then {
				_foundList = _foundList - [_foundList select _forEachIndex];					
			};
			} foreach _foundList;		
		} foreach _pickedRemove;
	};	

	//hint format ["Original : %1 | Found: %2 | Unwantedlist: %3 | Final %4",count _classNames,count _originallist,count _pickedRemove,count _foundList];	
	_ARRAYRETURN = _foundList;
	
// RETURN ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_position_LocationsBuilding | %1",_ARRAYRETURN];
_ARRAYRETURN