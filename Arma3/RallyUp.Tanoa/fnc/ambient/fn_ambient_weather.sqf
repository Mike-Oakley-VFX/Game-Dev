/*
	Author: CodeRedFox	
	Function: MP Compatable weather	
	Usage: [] spawn RALLYUP_fnc_ambient_weather
	Returns: N/A
*/ diag_log format ["RallyUp : RALLYUP_fnc_ambient_weather | %1 | %2",time,serverTime];	
	
	_windLevel = wind;
	_rainLevel= rain;		
	_overcastLevel = ["RALLYUP_param_WEATHER"] call BIS_fnc_getParamValue;
	_fogArray = fogParams;
	_weatherTime = 1800;
	0 setRain 1;

	waituntil {
		sleep 1;		

		/*
		_text = format["
				<br/>Next weather Change : %1
				<br/>Overcast : %2
				<br/>Rain : %3
				<br/>Wind : %4
				<br/>Fog : %5
			",_weatherTime,overcast,rain,Wind,fogParams];
		hintSilent parseText _text;
		*/

			_weatherTime = _weatherTime - 1;
			if (_weatherTime == 0) then {

				1000 setOvercast (random 1);

				30 setRain (random 1) ;

				300 setFog ( random [0, 0.3, 1] )  ;
				
				_weatherTime = 1800;
				simulWeatherSync;
			};			

			if(1>2) exitWith {false};
		false
	} ;