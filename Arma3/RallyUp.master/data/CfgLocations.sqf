
/*
	Author: CodeRedFox
	Uses: Creates new locations in Altas
	Note: Special notes?
	Usage: #include "data\CfgLocations.hpp"

*/ 

RALLYUP_newLocations = [];

// Only adds these location if the map is equal
	if (worldName == "Altis") then { 
		RALLYUP_newLocations = [
		  ["Camp Oakley",			[17394,13185,0]],
		  ["Zaros Military Outpost",		[8303,10085,0]],
		  ["Sagonisi Military Outpost",		[14254,13027.7,0]],
		  ["Vikos Military Outpost",		[12286,8907,0]],
		  ["Quarry Military Outpost",		[4746,12498,0]],
		  ["Kore Military Outpost",		[6839,16064,0]],
		  ["Frini Military Outpost",		[14208,21223,0.00143433]],
		  ["Galati Military Outpost",		[9958,19353,0.00143433]],
		  ["Sytra Military Outpost",		[8386,18244,0.00135803]],
		  ["Pefkas Bay Military Outpost",	[20596,20110,0.00151062]],
		  ["Agios Georgios Base",		[20992,19271,0.00143814]],
		  ["Cap Strigla Military Outpost",	[28322,25772,0.00142479]],
		  ["Agia Pelagia Military Outpost",	[23064,7283,0.00159454]],
		  ["Selakano Military Outpost",		[20082,6731,0.00146484]],
		  ["Stavros Military Outpost",		[12495,15188,0.00147247]],
		  ["Zaros Military Outpost",		[10012,11240,0.00123215]],
		  ["Kalithea Military Outpost",		[16608,19010,0.00146866]],
		  ["Neri Military Outpost",		[3921,12290,0.00153732]],
		  
		  ["Munitions Storage Complex",		[5228,14180,0.00138474]],
		  
		  ["Feres Airport",			[20882,7293.12,0.00147438]],
		  ["Abdera Airport",			[9177,21582.7,0.00142288]],
		  ["Almyra Salt Flats Airport",		[23148,18701,0.00143886]],
		  
		  ["Kastro Solar Array",		[16984,18103,0.00131702]],
		  ["Therisa Solar Array",		[11036,12688.8,0.0015564]],
		  
		  ["Iraklia Hotel & Spa",		[22022,21068.7,0.00121689]],	  
		  ["Neri Bay Hotel & Spa",		[3819,11121.2,0.00145674]],	  
		  ["Anemoessa Resort",			[16109,16213.4,0.00156593]],
		  ["Kavala Resort",			[3369,14270.3,0.0013504]],
		  
		  ["Gori Logging Company",		[5415,17912.1,0.00141907]],	  
		  ["Agios Logging Company",		[9520,15126.2,0.0015564]],
			
		  ["Edessa Power Plant",		[8263,10902.5,0.00168991]],
		  ["Kalochori Power Plant",		[20689,15688.6,0.00141907]],	
		  ["Feres Power",			[22679,7791.97,0.00145721]],	
		  ["Oreokastro Wind Farm",		[4317,20633.1,0.0015564]],
		  ["Fotia Wind Farm",			[4071,19236,0.00143433]],
		  
		  ["Ekklisia Agia field",		[19657,7769,0.00152969]],
		  ["Edessa water reservoir",		[6999,11637,0.00143814]],
		  
		  ["Kavala Hospital",			[3730,13010.6,0.00152969]],
		  ["Katalaki Bay Hospital",		[11392,14211,0.00141907]],
		  ["Katalaki Storage",			[10220,14865,0.00117493]],	 
		  ["Tactical Bacon Inc.",		[10120,15060.2,0.00157166]],
		  ["RedGull Inc.",			[3242,12462.6,0.00123024]],
		  ["Franta Inc.",			[3782,12390.7,0.00144577]],
		  ["Franta Storage",			[4648,14229.1,0.00170517]],
		
		
		  ["Bomos Estates",			[3135,21977.5,0.00132942]],
		  ["Artsti Estates",			[8545,20915,0.00143433]],
		  ["Agios Georgios Estates",		[11221,21031.5,0.00273132]],
		  ["Aggelochori Estates",		[5659,19550,0.00134277]],
		  ["Kategidia Estates",			[22100,13635.5,0.00165176]],
		  ["Panagia Fishing Village",		[10591,22171.8,0.000598907]],	  
		  ["Tonos Fishing Village",		[12094,22743.7,0.00148201]],
		  ["Iremi Docks",			[5090,9971.18,0.00180864]],	  
		  ["Makrynisi Ferry Terminal",		[12478,12709.2,0.0014534]],	
			
			
		  ["Vikos Castle",			[11199,8716.79,0.00143433]],
		  ["Choros Archea Ruins",		[20104,20033.3,0.00149155]],
		  ["Alos Lookout",			[2834,20169,0.000930786]], 
		  ["Pyrsos Lookout",			[7106,19449,0.00164795]],
		  ["Xirolimni Lookout",			[8257,13411,0.00137329]],
		  
		  
		  ["Stadium gas station",		[6205,15094.2,0.00150108]],
		  ["Anthrakia gas station",		[16860,15490.8,0.00143147]],
		  
		  ["Panagia Radio Station",		[19351,9670.99,0.00132751]],
		  ["Didymos Radio Station",		[18731,10221,0.00137329]],
		  ["Pyrgos Radio Station",		[17868,11733.2,0.00158691]]
		];  
	};

	if (worldName == "Stratis") then { 
		RALLYUP_newLocations = [];
	};
	
	/* Custom Island Additions
		if (worldName == "Stratis") then { 
			RALLYUP_newLocations = [
				 ["THE NAME", [positionxyz]],
			];
		};
	*/
	
	 // add new Locations
	 {
	_name = _x select 0;_position = _x select 1;
		_forEachIndex = createLocation ["NameLocal",_position,100,100];_forEachIndex setText _name;
	 } foreach RALLYUP_newLocations;
	 
diag_log format ["RallyUp : data\CfgLocations.hpp | Location Amount : %1",count RALLYUP_newLocations];	 
	 
	 
	 
