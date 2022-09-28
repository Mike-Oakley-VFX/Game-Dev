class RscTitles
{
	class Default
	{
		idd = -1;
		fadein = 0;
		fadeout = 0;
		duration = 0		
	};
	class GameWave_Display
	{
		idd= 1000;
		movingEnable = true; 
		enableSimulation = true;
		enableDisplay = true;
		duration = 99999;
		fadein = 0.1;
		fadeout = 2;
		name = "GameWave_Display";
		onLoad = "with uiNamespace do { GameWave_Display = _this select 0}";		
		
		class control
		{
			class structuredText
			{
				access = 0;
				type = 13;
				idc=1001;
				style = 0X00;
				lineSpace = 1;
				x = 0.10 * safezoneW + safezoneX;
				y = 0.75 * safezoneH + safezoneY;
				w = 0.77 * safezoneW;
				h = 0.06 * safezoneH;
				size = 0.020;
				colorBackground[]={0,0,0,0};
				ColorText[]={1,1,1,1};
				text = "";
				font = "PuristaSemiBold";
				class Attributes
				{
					font = "PuristaSemiBold";
					color = "#FFFFFF";
					align = "Center";
					valign = "top"
					shadow = false;
					shadowcolor = "#000000";
					underline = false;
					size = "4";					
				};				
			};			
		};
	};
}
