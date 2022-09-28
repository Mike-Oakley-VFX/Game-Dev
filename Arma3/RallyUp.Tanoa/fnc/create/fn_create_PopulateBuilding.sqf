/*
	Author: CodeRedFox	
	Function: Fills empty spots in a building with units
	Usage: [building,percentage] call RALLYUP_fnc_create_PopulateBuilding;
	Example : [nearestBuilding player,100] call RALLYUP_fnc_create_PopulateBuilding;
	Returns: Enemy Group

*/

// Variables
  _building = _this select 0;
  _percentage = _this select 1;
    
  _buildingSpots = [];
  _EnemyGroup = createGroup RALLYUP_Enemy_Side;  

// Function
if (count allunits < 50) then {
  _buildingSpots = [_building] call BIS_fnc_buildingPositions;
  	{
		_Randompercentage = random 50;
		if(_Randompercentage < _percentage) then {
			
			_SelectEnemyUnit = RALLYUP_Random_EnemyInf select floor random count RALLYUP_Random_EnemyInf;
			
			_Zfix = [_x select 0,_x select 1,(_x select 2) + 0.5];
				_Enemy = _EnemyGroup createUnit [_SelectEnemyUnit, _Zfix, [], 0, "NONE"];
			
			_Enemy setdir (random 360);
			
			diag_log format ["RallyUp : RALLYUP_fnc_create_PopulateBuilding | _EnemyGroup = %1",count (units _Enemy)];
		};
	} foreach _buildingSpots;
};	




