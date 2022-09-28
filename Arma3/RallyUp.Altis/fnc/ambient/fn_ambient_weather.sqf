/*
	Author: CodeRedFox	
	Function: MP Compatable weather	
	Usage: [] spawn RALLYUP_fnc_ambient_weather
	Returns: N/A
*/ diag_log format ["RallyUp : RALLYUP_fnc_ambient_weather | %1 | %2",time,serverTime];
	
		
	_weatherTime = 90;
	_NewovercastLevel = 0;
	
	_WindLevel = wind;
	_RainLevel= rain;
	_OvercastLevel = overcast;
	_foglevel = fogParams;
	
	
	0 setOvercast _OvercastLevel;
	0 setRain _RainLevel;	
	0 setFog [_foglevel select 0, _foglevel select 1, _foglevel select 2];	
	setWind [_windLevel select 0, _windLevel select 0, false];		
	forceWeatherChange;
	
	
	if (isServer) then {
		waituntil {
		
			_text = format["
				<br/>NewovercastLevel : %1
				<br/>Next weather Change : %2
				<br/>Overcast : %3
				<br/>Rain : %4
				<br/>Wind : %5
				<br/>Fog : %6
			",_NewovercastLevel,ceil nextWeatherChange,overcast,Rain,Wind,fogParams];
			hintSilent parseText _text ;
			if (nextWeatherChange <= 0) then { 
			
				_weatherTime = nextWeatherChange;				
				_NewovercastLevel = (random 0.8);
				
				_weatherTime setOvercast _NewovercastLevel;
				
				//_weatherTime setRain (random _NewovercastLevel);	
				//setWind [(random _NewovercastLevel)*((random 5)-2.5), (random _NewovercastLevel)*((random 5)-2.5), false];
				
				_weatherTime setFog [random _NewovercastLevel, 0.1, 0];
				simulWeatherSync;
			};
		};
		false
	};
	
	
		