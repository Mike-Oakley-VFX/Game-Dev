/*

	Author: CodeRedFox
	Uses: Debug with markers
	Note:
	Usage:		[Ammocrate] spawn RALLYUP_fnc_task_FillAmmocrate;

*/

	_Ammocrate = _this select 0;

	
		clearWeaponCargo _Ammocrate;
		clearMagazineCargo _Ammocrate;
		clearItemCargo _Ammocrate;
		clearBackpackCargo _Ammocrate;
		
		_ammoboxPostitions = 15;
		
		
		for "_i" from 0 to _ammoboxPostitions do {

			_CargoarrayWeapon = RALLYUP_ResupplyWeapons select floor random count RALLYUP_ResupplyWeapons;
			_CargoarrayMagazine = RALLYUP_ResupplyMagazines select floor random count RALLYUP_ResupplyMagazines;
			_CargoarrayItem = RALLYUP_ResupplyItems select floor random count RALLYUP_ResupplyItems;
			_CargoarrayBackpack = RALLYUP_ResupplyBackpacks select floor random count RALLYUP_ResupplyBackpacks;
			
			
			
			_WeaponCargo = _Ammocrate addWeaponCargoGlobal [_CargoarrayWeapon, 1];
			_MagazineCargo = _Ammocrate addWeaponCargoGlobal [_CargoarrayMagazine, 1];
			_ItemCargo = _Ammocrate addWeaponCargoGlobal [_CargoarrayItem, 1];
			_BackpackCargo = _Ammocrate addWeaponCargoGlobal [_CargoarrayBackpack, 1];

			hint str[_CargoarrayWeapon,_CargoarrayMagazine,_CargoarrayItem,_CargoarrayBackpack];sleep 1;	
		};

		
	
	
diag_log format ["RallyUp : RALLYUP_fnc_task_OpenDoors | doors : %1",count _doors];	

