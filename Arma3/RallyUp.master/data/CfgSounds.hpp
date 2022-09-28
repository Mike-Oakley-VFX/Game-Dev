/*
	Author: CodeRedFox
	Uses: 
	Note: 
	Usage: #include "data\CfgSounds.hpp"

*/

class CfgSounds	{
	sounds[] = {};
	class Supply_Inbound
	{
		name = "Supply_Inbound";
		sound[] = {"@a3\dubbing_f\modules\supports\drop_acknowledged.ogg", db+0, 1.0};
		titles[] = {0,""};
	};
	class Supply_Dropped
	{
		name = "Supply_Dropped";
		sound[] = {"@a3\dubbing_f\modules\supports\drop_accomplished.ogg", db+0, 1.0};
		titles[] = {0,""};
	};
	
	class Transport_Inbound
	{
		name = "Transport_Inbound";
		sound[] = {"@a3\dubbing_f\modules\supports\transport_acknowledged.ogg", db+0, 1.0};
		titles[] = {0,""};
	};
	class Transport_accomplished
	{
		name = "Transport_accomplished";
		sound[] = {"@a3\dubbing_f\modules\supports\transport_accomplished.ogg", db+0, 1.0};
		titles[] = {0,""};
	};

};
