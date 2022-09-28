
/*
	Author: CodeRedFox
	Uses: 
	Note: Dont modify this file
	Usage: #include "data\params.hpp"

*/

class Params {
// RALLY UP
    	class RALLYUP_param_PlayerSide
		{
			title = "RallyUP : Player side";
			texts[] = {"WEST", "EAST"};
			values[] = {0, 1};
			default = 0;
			isGlobal = 1;
		};
		class RALLYUP_param_BLUFORFaction
		{
			title = "RallyUP : BLUFOR Faction to use";
			texts[] = {"NATO", "FIA", "Pacific NATO", "Pacific CTRG", "Gendarmerie", "Woodland NATO"};
			values[] = {0, 1, 2, 3, 4, 5};
			default = 0;
			isGlobal = 1;
		};		
		class RALLYUP_param_OPFORFaction
		{
			title = "RallyUP : OPFOR Faction to use";
			texts[] = {"Iranian CSAT", "FIA", "Chinese CSAT", "Spetznatz"};
			values[] = {0,1,2,3};
			default = 0;
			isGlobal = 1;
		};
		class RALLYUP_param_WAVENUMBER
		{
			title = "RallyUP : Starting strength";
			texts[] = {"Easy","Normal","Hard"};
			values[] = {1,2,5};
			default = 1;
			isGlobal = 1;
		};
		class RALLYUP_param_MINDISTANCE
		{
			title = "RallyUP : Min mission distance";
			texts[] = {"500","750","1000"};
			values[] = {500,750,1000};
			default = 750;
			isGlobal = 1;
		};
		class RALLYUP_param_MAXDISTANCE
		{
			title = "RallyUP : Max mission distance";
			texts[] = {"2000","5000","Unlimited"};
			values[] = {2000,5000,20000};
			default = 2000;
			isGlobal = 1;
		};
		class RALLYUP_param_AINVG
		{
			title = "RallyUP : Remove NVG from AI";
			texts[] = {"No","Yes"};
			values[] = {0,1};
			default = 1;
			isGlobal = 1;
		};
		/*
		class RALLYUP_param_AMBIENTGROUND
		{
			title = "Ambient ground";
			texts[] = {"Off","On"};
			values[] = {0,1};
			default = 1;
		};
		*/
		class RALLYUP_param_AMBIENTAIR
		{
			title = "RallyUP : Ambient air";
			texts[] = {"Off","On"};
			values[] = {0,1};
			default = 1;
		};		
// ARMA 
		class Daytime
		{
			title = "ARMA3 : Time";
			texts[] = {"Morning","Day","Evening","Night","Random"};
			values[] = {6,12,16,20,99};
			default = 12;
			code = "if(%1==99)then{%1=random 23};";
			function = "BIS_fnc_paramDaytime";
	 		isGlobal = 1;
		};
		class RALLYUP_param_WEATHER
		{
			title = "ARMA3 : Weather";
			texts[] = {"Clear","Clouds","Overcast","Rain","Random"};
			values[] = {0,0.25,0.75,1,99};
			default = 99;
			code = "if(%1==99)then{%1=random 1};";
			function = "BIS_fnc_paramWeather";
	 		isGlobal = 1;
		};
		class RALLYUP_param_TIME
		{
			title = "ARMA3 : Time Acceleration";
			texts[] = {"x1","x2","x5","x10"};
			values[] = {1,2,5,10};
			default = 2;
			function = "BIS_fnc_paramTimeAcceleration";
	 		isGlobal = 1;
		};

		// Adds in new Revive options
		#include "\a3\Functions_F\Params\paramRevive.hpp"
}; 
