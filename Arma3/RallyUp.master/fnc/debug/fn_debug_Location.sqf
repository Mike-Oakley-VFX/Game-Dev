
if (!isServer) exitwith {};




_WorldSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
_WorldSizeCenter = [_WorldSize/2,_WorldSize/2,0];
_FindAllLocations = [];
_type = ["NameCity","NameVillage","NameLocal","NameMarine","Hill"];
 

	{
		_FindAllLocations = _FindAllLocations + nearestLocations [_WorldSizeCenter, [_x], _WorldSize];	
	} foreach _type; 
  
	{

		[position _x,"ICON","","mil_dot","ColorRed"] call RALLYUP_fnc_debug_marker;
	} foreach _FindAllLocations;