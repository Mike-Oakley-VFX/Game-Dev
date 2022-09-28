
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
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));		
		_SearchIntel = RALLYUP_MissionItems select floor random count RALLYUP_MissionItems;
		
		
	// Create Tasking Location
	
		_SearchPositionbuilding = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
			if (_SearchPositionbuilding distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};	// Will cancel if the task to to far away	
		
		_SearchPosition = [_SearchPositionbuilding] call RALLYUP_fnc_position_LocationsSpots;
		_Search_LocationName = [(_SearchPosition select 0)] call RALLYUP_fnc_position_LocationsName;				
	
		_SearchItem = _SearchIntel createVehicle (_SearchPosition select 0);		
		_SearchItem enableSimulationGlobal false;
		_SearchItem setpos (_SearchPosition select 0);		
		
		sleep 2;
			
		_addactionRescue = _SearchItem addAction ["<t color='#ff8000' t size='2'>Recover Intel</t>",
			{	
				deletevehicle (_this select 0);			
			} , "",1.5,true,true,"","true",	5,	false,"",""
		];
		
	// Create Guard	
	
		_Enemy = [(_SearchPosition select 0),10,300,["Group"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
		[(_SearchPosition select 0),_Enemy] call BIS_fnc_taskDefend;
		
		[(_SearchPosition select 0),10,50,["Static"],(random 7),"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	
		_EnemyInfGroup = createGroup (RallyUpOpFor select 0);
		
		_FindBuildings = nearestObjects [getpos _SearchItem, ["Building"], 150];
		{
			[_x,RALLYUP_Groups_EnemyInf,10] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;

		// Assign intel		
		sleep 5;
		{
			if (side _x == east) then {[_x,'' , 20] call RALLYUP_fnc_create_intel;}
		
		} forEach allunits;		
		
		
	// Diary
		_taskInformation = ([_SearchItem] call RALLYUP_fnc_text_GetInfo);

	
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_TaskingPosition, (random 300)+100, 0] call BIS_fnc_relPos;
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
	
		_searchradius = _taskPosition distance (getpos _SearchItem);
		
		
		waituntil {
			
			sleep 1;			
			if (RALLYUP_Intel_Updated == true) then {
				if (_searchradius > 1) then {_searchradius = _searchradius / 2;};
				_target = [getpos _SearchItem, _searchradius, random 360] call BIS_fnc_relPos;				
				[_Task_Name,_Target] call BIS_fnc_taskSetDestination;				
				RALLYUP_Intel_Updated = false;
			};				
			
			if (isNull _SearchItem) exitWith {_Task_Status = "Succeeded";true};
				false
		};
		
		deleteVehicle _SearchItem;	

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
