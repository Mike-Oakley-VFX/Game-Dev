/*
	Author: CodeRedFox	
	Function: Adds AI to team wityh a limit
	Usage: [unit, information, chance] call RALLYUP_fnc_create_intel
	Example: [player, information, 100] call RALLYUP_fnc_create_intel
	Returns: N/A
*/

	if ( !isServer) exitwith {};

	// Variables
	  _unit = _this select 0;
	  _information = _this select 1;
	  _chance = _this select 2;
	  
	  
	_intelItems = [RALLYUP_EnemySide,["Land_Laptop_","Land_PortableLongRangeRadio_F","Land_MobilePhone","Land_File","Land_FilePhotos_F","Land_Map_F","Land_Suitcase_F","Land_HandyCam_F","Land_SatellitePhone_F"], [] ] call RALLYUP_fnc_task_ArrayofCfg;
			
			
	if ( (random 100 < _chance) ) then {
		_unit addAction [
			"<t color=RALLYUP_COLORHEX  t size='2'>Search</t>",
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				

				
				_intel = (_intelItems select floor random count _intelItems) createVehicle position _target;		
				_intel addAction ["<t color=RALLYUP_COLORHEX  t size='2'>
					Take Intel</t>",
					{
						params ["_target"];
						RALLYUP_Intel_Updated = true;
						deletevehicle _target;
					} , "",1.5,true,	true,"","true",	5,	false,"",""
				];			
							
				removeAllActions _target;
			} , "",1.5,true,	true,"","true",	5,	false,"",""
			
		];
	};