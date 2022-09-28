
/*
	Author: CodeRedFox
	Uses: Creates a Search Task
	Note: 
	Usage: [position] execVM "missions\Primary_Search.sqf"
	Examples:[position player] execVM "missions\Primary_Search.sqf";

*/ diag_log format ["RallyUpDiag Starting : Primary_Search.sqf | %1",_this select 0];
if (!isServer) exitwith {};
	
	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
				
		_minDistance = RALLYUP_minDistance+((count allplayers)*50);
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);		
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_SearchIntel = RALLYUP_Intels select floor random count RALLYUP_Intels;
	
	// Create Tasking Location
	
		_SearchPositionbuilding = [_TaskingPosition,_minDistance,_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
			if (_SearchPositionbuilding distance2d _TaskingPosition > _maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of _maxDistance"];true};	// Will cancel if the task to to far away	
		
		_SearchPosition = [_SearchPositionbuilding] call RALLYUP_fnc_position_LocationsSpots;
		_Search_LocationName = [(_SearchPosition select 0)] call RALLYUP_fnc_position_LocationsName;	
			
	
		_SearchItem = _SearchIntel createVehicle (_SearchPosition select 0);		
		_SearchItem enableSimulationGlobal false;
		_SearchItem setpos (_SearchPosition select 0);		
		
		sleep 2;
			
		_addactionRescue = _SearchItem addAction ["<t color='#ff8000' t size='2'>Recover Intel</t>",
			{	
				deletevehicle (_this select 0);			
			},'', 0, true, true, '', '_this distance cursortarget < 30'
		];
		
	// Diary
		_taskInformation = ([_SearchItem] call RALLYUP_fnc_text_GetInfo);

	
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = _TaskingPosition;
		_taskType = "Search";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Search_ca.paa' width='50px' />
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	A %1 containing OPSEC data is being held by enemy forces. Intel suggest its located around the %3 AO
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Find or destroy the %1
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>	
		",_taskInformation select 1,_taskInformation select 2,_Search_LocationName];
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
		
		
	// Task Event
		_SearchingLocation = [(_SearchPosition select 0),0,200,(RALLYUP_LocationsLocal+RALLYUP_LocationsPoints),5] call RALLYUP_fnc_position_Locations; 
		[_Task_Mission,_SearchingLocation] call BIS_fnc_taskSetDestination;
		
		
		
		[_SearchPosition select 0,300,1000,["Group","Vehicles","Helicopters"],1] spawn RALLYUP_fnc_create_Enemy;		
		
		_FindBuildings = nearestObjects [_SearchPosition select 0, ["Building"], 200];
		{
			[_x,RALLYUP_Groups_EnemyInf,25] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;
		
	
		waituntil {	
			sleep 10;			
			if (({side _x != (RallyUpBluFor select 0)} count allUnits) <= 1) then {
				[_SearchingLocation,_waveamount] spawn RALLYUP_fnc_create_reinforcements;
			};	
			
			[_Task_Mission,_SearchingLocation] call BIS_fnc_taskSetDestination;
				
			
			if (isNull _SearchItem) exitWith {_Task_Status = "Succeeded";true};
				false
		};
		
		deleteVehicle _SearchItem;	

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
