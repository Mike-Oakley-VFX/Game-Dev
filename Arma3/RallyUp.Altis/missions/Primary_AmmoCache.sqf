/*
	Author: CodeRedFox
	Uses: Creates a classic Ammo Cache mission. Find and destory the ammo cache.
	Note: 
	Usage: [position] execVM "missions\Primary_AmmoCache.sqf"
	Examples:[position player] execVM "missions\Primary_AmmoCache.sqf";

*/ diag_log format ["CRFDiag Starting : Mission_AmmoCache.sqf | %1 ",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_AmmoCacheGroup = createGroup (RallyUpOpFor select 0);
		
	// Find Tasking Location
		_AmmoCache_Building = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
		if (_AmmoCache_Building distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};	// Will cancel if the task to to far away	
		
		_AmmoCache_BuildingSpot = [_AmmoCache_Building] call RALLYUP_fnc_position_LocationsSpots;		
		_AmmoCache_LocationName = [_AmmoCache_Building] call RALLYUP_fnc_position_LocationsName;	
		
	//create AmmoCache	
		_AmmoCachePosition = _AmmoCache_BuildingSpot select 0;
		
		_AmmoCache = (RALLYUP_AmmoCrates select floor random count RALLYUP_AmmoCrates) createVehicle _AmmoCachePosition;
		//_AmmoCache enableSimulationGlobal false;
		_AmmoCache setpos _AmmoCachePosition;
		
		
		_DestroyedAmmoCache = _AmmoCache addEventHandler ["Explosion",{
			_TheAmmoCache = _this select 0;
			if (!isNull _TheAmmoCache) then 
			{	
				"Bo_GBU12_LGB" createVehicle getPos _TheAmmoCache;
				deleteVehicle _TheAmmoCache;				
			};			
		}];
		
		sleep 1;
	// Create Guard	
	
		_Enemy = [_AmmoCache_Building,10,50,["Group"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
		[_AmmoCache_Building,_Enemy] call BIS_fnc_taskDefend;
		
		[_AmmoCache_Building,10,50,["Static"],(random 7),"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	
		_EnemyInfGroup = createGroup (RallyUpOpFor select 0);
	
		_FindBuildings = nearestObjects [getpos _AmmoCache, ["Building"], 200];
		
		{
			[_x,RALLYUP_Groups_EnemyInf,random 200] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;
		
		// Assign intel		
		sleep 10;
		{if (side _x == east) then {[_x,'' , 20] call RALLYUP_fnc_create_intel;}} forEach allunits;
		
	// Diary
		_taskInformation_Name = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 0;
		_taskInformation_displayName = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 1;
		_taskInformation_displaypicture = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 2;
		
		
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_AmmoCache_Building, (random RALLYUP_minDistance), 0] call BIS_fnc_relPos;	
		_taskType = "Search";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Destroy_ca.paa' width='50px' />
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	An %1 is being stored in a building 
			<br/>
			<br/>	Intel suggests the target will be in the %2 area.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Look for and destroy the %1.
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>
			<br/>	- Ammocaches can produce large explosions!
			<br/>	- Explosions will detonate the ammobox (gernades, C4, rockets)
			<br/>
			<br/>
			",
			_taskInformation_displayName,
			_AmmoCache_LocationName
		];
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
			
		
		waituntil{
			sleep 10;
			
			if (RALLYUP_Intel_Updated == true) then {
				_FindBuildings = nearestObjects [getpos _AmmoCache, ["Building"], 100];
				_selectBuildings = (_FindBuildings select floor random count _FindBuildings);
				[_Task_Name,getpos _selectBuildings] call BIS_fnc_taskSetDestination;
				RALLYUP_Intel_Updated = false;
			};
			
			_EnemyTrigger = [allunits,(RallyUpOpFor select 0),_taskPosition,RALLYUP_minDistance,10] call RALLYUP_fnc_task_isTriggered;
			
			if (_EnemyTrigger) then {[_taskPosition,_waveamount] spawn RALLYUP_fnc_create_reinforcements;};			
			if (!alive _AmmoCache) exitWith {_Task_Status = "Succeeded";true};
				false
		};				
	
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	

if(true) exitWith {};
