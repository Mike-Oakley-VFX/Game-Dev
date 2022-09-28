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
		
		_minDistance = RALLYUP_minDistance+((count allplayers)*50);
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);		
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_AmmoCacheGroup = createGroup (RallyUpOpFor select 0);
		
	// Find Tasking Location
		_AmmoCache_Building = [_TaskingPosition,_minDistance,_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
		if (_AmmoCache_Building distance2d _TaskingPosition > _maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of _maxDistance"];true};	// Will cancel if the task to to far away	
		
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
		
		_FindBuildings = nearestObjects [getpos _AmmoCache, ["Building"], 150];
		{
			[_x,RALLYUP_Groups_EnemyInf,10] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;
		
	// Diary
		_taskInformation_Name = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 0;
		_taskInformation_displayName = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 1;
		_taskInformation_displaypicture = ([_AmmoCache] call RALLYUP_fnc_text_GetInfo) select 2;
		
		
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_AmmoCache_Building, (random _minDistance), 0] call BIS_fnc_relPos;	
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
			
			_EnemyTrigger = [allunits,(RallyUpOpFor select 0),_taskPosition,_minDistance,10] call RALLYUP_fnc_task_isTriggered;
			
			if (_EnemyTrigger) then {[_taskPosition,_waveamount] spawn RALLYUP_fnc_create_reinforcements;};			
			if (!alive _AmmoCache) exitWith {_Task_Status = "Succeeded";true};
			if ({alive _x && side _x == (RallyUpBluFor select 0)} count allplayers < 0) exitWith {_Task_Status = "Failed";true};
				false		
		};		
		
	
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	

if(true) exitWith {};
