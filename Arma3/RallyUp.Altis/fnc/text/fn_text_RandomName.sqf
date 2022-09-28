/*
	Author: CodeRedFox	
	Function: Generates a random Military names
	Usage: ["Mission" or "Squade"] call RALLYUP_fnc_text_RandomName;
	Example: ["Mission"] call RALLYUP_fnc_text_RandomName;
	Returns: _RALLYUP_RandomName	
*/ 
		_type = _this select 0;
		
		_RALLYUP_RandomName = "None";
	
		switch (_type) do {
			case "Mission": {
				_RALLYUP_MissionVerb = ["Stinky","Provide","Echo","Kinetic","Ace","Northern","Southern","Eagle","Pig","Lucky","Grand","Trident","Terrible","Silver","Clear","Enduring",
					"Eclipse","Garden","Midnight","Parched","Absolute","Abused","Angry","Ballistic","Burning","Casino","Hairy","Mustard","Stuffed","Zero","Silent","Wheezing",
					"Inherent","Just","Magic","Bayonet","Urgent","Crescent","Spartan","Rolling","Nickel","Beaver","Killer"
				];
				
				_RALLYUP_MissionNoun = ["Comfort","Freedom","Storm","Dingo","Blowdown","Cyclone","Hearts","Light","Dart","Dragon","Thunder","Sabre","Firework","Victory","Count",
					"Wind","Weasel","Puppet","Nutcracker","Tolerance","Sunset","Deadly","Buffalo","Taco","Dog","Fox","Resolve","Cause","Carpet","Lightning","Guardian","Fury",
					"Claw","Scorpion","Overlord","Sentinel","Beastmaster","Grass","Rainbow","Cage","Mincemeat","Spear","Defence","Shield"];	
			
				_RALLYUP_RandomName = ("OP : " + (_RALLYUP_MissionVerb select floor random count _RALLYUP_MissionVerb) + " " + (_RALLYUP_MissionNoun select floor random count _RALLYUP_MissionNoun));
			};			
			case "Squade": {		
				_RALLYUP_Numbers_array = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th"];
				_RALLYUP_Nouns_array = ["The Angels","Golden Talon","Sky Soldiers","All-Americans","The Screaming Eagles","Old Ironsides","Hell on Wheels","Spearhead",
					"Breakthrough","Name Enough","Rolling Fourth","Victory","Super Sixth","Lucky Seventh","Thundering Herd","Iron Deuce","Iron Snake","Show Horse",
					"Tornado","Thundering Herd","Phantom","Remagen","Tiger Division","Thunderbolt","Hellcat","Black Cat","Liberators","Armoraiders","Empire","Volunteers",
					"Grizzly","Hurricane","Lone Star","Jersey Blues","The First Team","Hell for Leather","The Black Horse","The Big Red One","The Fighting First"
				];		
				_RALLYUP_RandomName = ("" + (_RALLYUP_Numbers_array select floor random count _RALLYUP_Numbers_array) + " " + (_RALLYUP_Nouns_array select floor random count _RALLYUP_Nouns_array));
			};
			default {_RALLYUP_RandomName = "Unknown"};
		};
		
diag_log format ["RallyUp : RALLYUP_fnc_text_RandomName | Random Name : %1 ",_RALLYUP_RandomName];		
_RALLYUP_RandomName
