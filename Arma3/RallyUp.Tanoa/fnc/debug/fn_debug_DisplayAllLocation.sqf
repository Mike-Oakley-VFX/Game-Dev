
/*

	Author: CodeRedFox
	Uses: Visually show all locations on a map. Will take a LONGGGGG TIME

	Usage:	[] call RALLYUP_fnc_debug_DisplayAllLocation;
	
	https://community.bistudio.com/wiki/cfgMarkers
*/
if (!isServer) exitwith {}; 
diag_log format ["RallyUp : RALLYUP_fnc_debug_DisplayAllLocation | %1 | %2",time,serverTime];




_WorldSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
_WorldSizeCenter = [_WorldSize/2,_WorldSize/2,0];

_type = ["NameCity","NameVillage","NameLocal","NameMarine","Hill"];
    

_MarkerIcon = "ICON";
_MarkerText = "";
_MarkerType = "mil_dot";
_MarkerColor = "ColorBlack";
_FindAllLocations = [];
  
  {
		_FindAllLocations = _FindAllLocations + nearestLocations [_WorldSizeCenter, [_x], _WorldSize];
		
  } foreach _type; 
  
   {
  		switch (type _x) do {
					case "NameCity":	{_MarkerType = "selector_selectable";_MarkerColor = "ColorRed"};
					case "NameVillage":	{_MarkerType = "selector_selectedFriendly";_MarkerColor = "ColorBlue"};
					case "NameLocal":	{_MarkerType = "selector_selectedMission";_MarkerColor = "ColorYellow"};
					case "NameMarine":	{_MarkerType = "c_ship";_MarkerColor = "ColorOrange"};
					case "Hill":	{_MarkerType = "loc_Rock";_MarkerColor = "ColorWhite"};
					case "Mount":	{_MarkerType = "mil_dot";_MarkerColor = "ColorBlack"};
			};  		
		
		_markerDebug = createMarkerLocal [format["RALLYUP_%1",(random 1000)],position _x];
		_markerDebug setMarkerShapelocal _icon;
		_markerDebug setMarkerTypelocal _MarkerType;
		_markerDebug setMarkercolor _MarkerColor;
  
  } foreach _FindAllLocations;
