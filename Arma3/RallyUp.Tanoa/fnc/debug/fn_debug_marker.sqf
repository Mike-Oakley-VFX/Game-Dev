/*

	Author: CodeRedFox
	Uses: Debug with markers
	Note:
	Usage:		[position,icon,text,type,color] call RALLYUP_fnc_debug_marker;
	Example:	[[0,0,0],"ICON","Debug","mil_dot","ColorRed"] call RALLYUP_fnc_debug_marker;

*/ diag_log format ["RallyUp : RALLYUP_fnc_debug_hint | %1 | %2",time,serverTime];
if (!isServer) exitwith {};

_position = _this select 0;
_icon = _this select 1;
_text = _this select 2;
_type = _this select 3;
_color = _this select 4;

_markerDebug = createMarkerLocal [format["RALLYUP_%1",(random 2000)],_position];
_markerDebug setMarkerShapelocal _icon;
_markerDebug setMarkerText _text;	
_markerDebug setMarkerTypelocal _type;
_markerDebug setMarkercolor _color;
