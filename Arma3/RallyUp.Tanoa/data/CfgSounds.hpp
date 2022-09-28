/*
	Author: CodeRedFox
	Uses: 
	Note: 
	Usage: #include "data\CfgSounds.hpp"

*/

class CfgSounds	{
	sounds[] = {};
	// Supply Radio Audio
	class Supply_Inbound
	{
		name = "Supply_Inbound";
		sound[] = {"@a3\dubbing_f\modules\supports\drop_acknowledged.ogg", db+0, 1.0};
		titles[] = {0,"Supply drop acknowledged"};
	};
	class Supply_Dropped
	{
		name = "Supply_Dropped";
		sound[] = {"@a3\dubbing_f\modules\supports\drop_accomplished.ogg", db+0, 1.0};
		titles[] = {0,"Supply drop complete"};
	};
		class Supply_Destroyed
	{
		name = "Supply_Destroyed";
		sound[] = {"@a3\dubbing_f\modules\supports\drop_destroyed.ogg", db+0, 1.0};
		titles[] = {0,"Supply drop was destroyed"};
	};
	// Transport Radio Audio
	class Transport_Inbound
	{
		name = "Transport_Inbound";
		sound[] = {"@a3\dubbing_f\modules\supports\transport_acknowledged.ogg", db+0, 1.0};
		titles[] = {0,"Transport inbound"};
	};
	class Transport_accomplished
	{
		name = "Transport_accomplished";
		sound[] = {"@a3\dubbing_f\modules\supports\transport_accomplished.ogg", db+0, 1.0};
		titles[] = {0,"Transport finished"};
	};
	class Transport_destroyed
	{
		name = "Transport_destroyed";
		sound[] = {"@a3\dubbing_f\modules\supports\transport_destroyed.ogg", db+0, 1.0};
		titles[] = {0,"Transport destroyed"};
	};

};
