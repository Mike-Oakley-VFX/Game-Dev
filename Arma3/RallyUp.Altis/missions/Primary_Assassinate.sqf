/*
	Author: CodeRedFox
	Uses: Creates a Assassinate task. Find the units and kill them.
	Note: 
	Usage: [position] execVM "mission\Primary_Assassinate.sqf"
	Examples:[position player] execVM "missions\Primary_Assassinate.sqf";

*/ diag_log format ["RallyUpDiag Starting : Mission_Assassinate.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
			
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
	// Find Tasking Location
		_Target_Location = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance,RALLYUP_LocationsLocal,5] call RALLYUP_fnc_position_Locations;
		if (_Target_Location distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {hint str ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};;

		_Target_LocationArea = [_Target_Location, (random 300)+100, 0] call BIS_fnc_relPos;		
		_Target_LocationName = [_Target_Location] call RALLYUP_fnc_position_LocationsName;		
		_Target_LocationSpots = [_Target_Location] call RALLYUP_fnc_position_LocationsSpots;
		
		_TargetGroup = createGroup (RallyUpOpFor select 0);	
	//create Target	
		_TargetPosition = _Target_LocationSpots select 0;

		_Target = _TargetGroup createUnit [RALLYUP_POI select floor random count RALLYUP_POI, [_TargetPosition select 0,_TargetPosition select 1,(_TargetPosition select 2)+0.5], [], 0, "NONE"];
		[_Target] joinSilent _TargetGroup;
		
		_TargetvehPos = [getpos _Target, 1, 60, 10, 0, 35, 0] call BIS_fnc_findSafePos;
		_Targetveh = (RALLYUP_POIVehicles select floor random count RALLYUP_POIVehicles) createVehicle _TargetvehPos;
		_Target assignAsDriver _Targetveh;		

		
		sleep 1;
	// Create Guard	
	
		_Enemy = [(_Target_LocationSpots select 0),10,50,["Group"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
		[(_Target_LocationSpots select 0),_Enemy] call BIS_fnc_taskDefend;
		
		[(_Target_LocationSpots select 0),10,50,["Static"],(random 7),"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	
		_EnemyInfGroup = createGroup (RallyUpOpFor select 0);
		
		_FindBuildings = nearestObjects [getpos _Target, ["Building"], 150];
		{
			[_x,RALLYUP_Groups_EnemyInf,10] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;
	
	// Assign intel		
		sleep 10;
		{if (side _x == east) then {[_x,'' , 20] call RALLYUP_fnc_create_intel;}} forEach allunits;
		
	// Diary
		_taskInformation_Name = ([_Target] call RALLYUP_fnc_text_GetInfo) select 0;
		_taskInformation_displayName = ([_Target] call RALLYUP_fnc_text_GetInfo) select 1;
		_taskInformation_displaypicture = ([_Target] call RALLYUP_fnc_text_GetInfo) select 2;
		
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = _Target_LocationArea;
		_taskType = "Search";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Search_ca.paa' width='50px' />
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	We need a target eliminated. A %1 by the name of %2 has been selling information to the enemies. 
			<br/>
			<br/>	Intel Suggests the target will be in the %4 area.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Look for and kills %2.
			<br/>
			<br/>
			<br/>R U L E S  O F  E N G A G M E N T : -----------------	
			<br/>
			<br/>	- All units in the %4 AO are hostle.
			<br/>
			<br/>T I P S : -----------------
			<br/>
			",
			_taskInformation_displayName,
			_taskInformation_Name,
			_taskInformation_displaypicture,
			_Target_LocationName
		];
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
		
		_isfleeingnow = "false";
		waituntil{
			sleep 5;

			if (RALLYUP_Intel_Updated == true) then {
				[_Task_Name,getpos _Target] call BIS_fnc_taskSetDestination;
				RALLYUP_Intel_Updated = false;
				hint "done";
			};		
			
			if ((!isNull(_Target findNearestEnemy _Target)) and (_isfleeingnow == "false")) then {
				[(_Target_LocationSpots select 0),_waveamount] spawn RALLYUP_fnc_create_reinforcements;				
				_isfleeingnow = "true";
				_EscapeLocation = [_Target, 5000, (random 360)] call BIS_fnc_relPos;
				_Target domove _EscapeLocation;	
			};			
			
			if (!alive _Target) exitWith {_Task_Status = "Succeeded";true};
			if (_Target distance _TargetPosition > 1000) exitWith {_Task_Status = "Failed";true};
			if (!isNil "RALLYUP_SkipMissions") exitWith {RALLYUP_SkipMissions = nil;_Task_Status = "Canceled";true};
				false		
		};		
		
		sleep 5;
	
	
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	

if(true) exitWith {};
