/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,min,max,[AP or AT],amount] spawn RALLYUP_fnc_create_MineField
	Example: [position player,0,300,["AP","AT"],5] spawn RALLYUP_fnc_create_MineField;
	Returns: N/A
*/	


	_position = _this select 0;	
	_min = _this select 1;
	_max = _this select 2;
	_type = _this select 3;
	_amount = _this select 4;
	
	_Mine = objNull;
	_SpawnPosition = [0,0,0];
	_PickPosition = [0,0,0];
	_PickType = "";
					
		for "_i" from 1 to _amount do {		
			_typeArray = _type select floor random count _type;	
			
			switch (_typeArray) do {
				case "AP": {
					if ((random 100) >75) then {
						_PickPosition = [_position] call RALLYUP_fnc_position_LocationsSpots;
						_SpawnPosition = (_PickPosition select 0);
					} else {	
						_SpawnPosition = [_position, _min, -1, 1, 0.1, 20, 0] call BIS_fnc_findSafePos;
					};
					_PickType = RALLYUP_MinesAP select floor random count RALLYUP_MinesAP;
					_Mine = _PickType createVehicle _SpawnPosition;	
				};
				case "AT": {
					_SpawnPosition = [_position,_min,_max] call RALLYUP_fnc_position_LocationsRoad;

					_PickType = RALLYUP_MinesAT select floor random count RALLYUP_MinesAT;
					_Mine = _PickType createVehicle _SpawnPosition;
				};
			};
			
_markerDebug = createMarkerLocal [format["RALLYUP_%1",(random 2000)],position _Mine];
_markerDebug setMarkerShapelocal "ICON";
_markerDebug setMarkerText _PickType;	
_markerDebug setMarkerTypelocal "mil_dot";
_markerDebug setMarkercolor "ColorRed";

		
			
		};			




