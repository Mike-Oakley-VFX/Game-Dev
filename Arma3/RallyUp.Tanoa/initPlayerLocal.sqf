	
// Client only Settings		
params ["_playerUnit", "_didJIP"];

diag_log format ["RallyUp : initPlayerLocal.sqf | START _playerUnit : %1 | _didJIP %2",_playerUnit,_didJIP];

	// Switched Civ character to BLUFOR
		_group = createGroup [RALLYUP_Friend_Side, true];
		_type = RALLYUP_Random_FriendlyInf select floor random count RALLYUP_Random_FriendlyInf;		
		[_playerUnit] joinSilent _group;			
		_type createUnit [position _playerUnit, group _playerUnit, "newChar = this"]; 
		selectPlayer newChar; 		
		deleteVehicle _playerUnit;

		_NewPlayer = player;

	// Creates dynamic groups and assign
		["InitializePlayer", [_NewPlayer, true]] call BIS_fnc_dynamicGroups;
		_squadName = ["Squade"] call RALLYUP_fnc_text_RandomName;
		_GroupAssign = [nil, _squadName, false];
		["RegisterGroup", [_group, leader _group, _GroupAssign]] call BIS_fnc_dynamicGroups;	

		diag_log format ["RallyUp : initPlayerLocal.sqf | Player  %1 %2",_NewPlayer,_type];


	// Other Things
		_NewPlayer addEventhandler ["killed",{[_this select 0, [_this select 0, "mySavedLoadout"]] call BIS_fnc_saveInventory}]; 
		_NewPlayer addEventhandler ["respawn",{[_this select 0,[_this select 0, "mySavedLoadout"]] call BIS_fnc_loadInventory}];

		[] call BIS_fnc_groupIndicator;  // Enables Group indicator	

		_NewPlayer = player;

		_info = [_NewPlayer] call RALLYUP_fnc_text_GetInfo;	

	


diag_log format ["RallyUp : initPlayerLocal.sqf | END _NewPlayer : %1 | _didJIP %2 | Group %3 | Name %4 | Type %5",_NewPlayer,_didJIP,_squadName, _info select 0,_info select 1];	