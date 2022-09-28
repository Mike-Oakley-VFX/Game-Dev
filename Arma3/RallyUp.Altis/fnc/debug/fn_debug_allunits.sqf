/*

	Author: CodeRedFox
	Uses: Debug with markers
	Note:
	Usage:		[] spawn RALLYUP_fnc_debug_allunits;

*/ diag_log format ["RallyUp : RALLYUP_fnc_debug_allunits | %1 | %2",time,serverTime];


if (!isServer) exitwith {};

waituntil {!isnull player};

_allunits = [];
_MarkerArray = [];

_type = "mil_dot";
_text = "";
_color = "ColorBlack";

	waituntil {
		if (!alive player) exitWith {true};
		_MarkerArray = [];
		_MarkerType = allunits+vehicles;		
		
		{
			switch (side _x) do {
				case (RallyUpBluFor select 0): {_color = "ColorGREEN"};	
				case (RallyUpOpFor select 0): {_color = "ColorRED"};
				case civilian: {_color = "ColorBlue"};
					default {_color = "ColorBlack"};
			};			
			
			_markerDebug = createMarkerLocal [format["RALLYUP_%1",_x],position _x];
			_markerDebug setMarkerShapelocal "ICON";			
			_markerDebug setMarkerTypelocal _type;	

			_name = ([_x] call RALLYUP_fnc_text_GetInfo) select 1;
			
			_markerDebug setMarkerText _name;
			_markerDebug setMarkercolor _color;
			_markerDebug setMarkerDir (getdir _x);
			
			_MarkerArray pushBack _markerDebug;	
		} foreach _MarkerType;
		
		sleep 1;
		
		{		
			deleteMarker _x;
			
		} foreach _MarkerArray;	
		
		false		
	};
	
