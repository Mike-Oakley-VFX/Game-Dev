
/*
	Author: CodeRedFox
	Uses: 
	Note: Dont modify this file
	Usage: #include "data\params.hpp"

*/

class Params {
	class RALLYUP_param_missions_title {
		title = "Rally Up | Options";
		values[]= {0};
		texts[]= {" "};
		default = 0;
		code = "";
		
	};
		class RALLYUP_param_WAVENUMBER
		{
			title = "Starting strength";
			texts[] = {"Easy","Normal","Hard"};
			values[] = {1,2,5};
			default = 1;
		};
		class RALLYUP_param_minDistance
		{
			title = "Min Mission Distance";
			texts[] = {"200","300","400","500"};
			values[] = {200,300,400,500};
			default = 200;
		};
		class RALLYUP_param_maxDistance
		{
			title = "Max Mission Distance";
			texts[] = {"1000","2000","5000","Unlimited"};
			values[] = {1000,2000,5000,20000};
			default = 2000;
		};
		class RALLYUP_param_ambientGround
		{
			title = "Ambient Ground";
			texts[] = {"Off","On"};
			values[] = {0,1};
			default = 1;
		};
		class RALLYUP_param_ambientAir
		{
			title = "Ambient Air";
			texts[] = {"Off","On"};
			values[] = {0,1};
			default = 1;
		};		
		
	class RALLYUP_param_Enviroment {
		title = "Rally Up | Enviroment";
		values[]= {0};
		texts[]= {" "};
		default = 0;
		code = "";
	};
		class RALLYUP_param_Daytime
		{
			title = "Time";
			texts[] = {"Morning","Day","Evening","Night"};
			values[] = {6,12,16,20};
			code = "if(%1==0)then{%1=random 24}";
			default = 9;
			function = "BIS_fnc_paramDaytime";
	 		isGlobal = 1;
		};
		class RALLYUP_param_Weather
		{
			title = "Weather";
			texts[] = {"Clear","Clouds","Overcast","Rain"};
			values[] = {25,50,75,100};
			default = 50;
			function = "BIS_fnc_paramWeather";
	 		isGlobal = 1;
		};
		class RALLYUP_param_Time
		{
			title = "Time Acceleration";
			texts[] = {"Normal","x2","x5","x10"};
			values[] = {1,2,5,10};
			default = 2;
			function = "BIS_fnc_paramTimeAcceleration";
	 		isGlobal = 1;
		};
}; 
