
/*
	Author: CodeRedFox
	Uses: Creates a Overwatch mission. Attack and kill all units in the area of a structure.
	Note: 
	Usage: [position] execVM "missions\Primary_Overwatch.sqf"
	Examples:[position player] execVM "missions\Primary_Overwatch.sqf";

*/ diag_log format ["RallyUpDiag Starting : Primary_Overwatch.sqf | %1",_this select 0];
if (!isServer) exitwith {};
 

 
	// Variables	
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
				
	
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
	// Find Tasking Location
		
		_Overwatch_Location = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance,RALLYUP_LocationsPoints,7] call RALLYUP_fnc_position_Locations; 
			if (_Overwatch_Location distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};;	// Will cancel if the task to to far away
		_LocationName = [_Overwatch_Location] call RALLYUP_fnc_position_LocationsName;		
		
	// Create Starting Enemy's

		_OverwatchBldPicked = RALLYUP_BldObjectives select floor random count RALLYUP_BldObjectives;
		
		_OverwatchBld = _OverwatchBldPicked createVehicle _Overwatch_Location;	
		_OverwatchBld setdir (random 360);
		
		sleep 2;
		
				
		[nearestBuilding _OverwatchBld,RALLYUP_Groups_EnemyInf,75] call RALLYUP_fnc_create_PopulateBuilding;		
		[_Overwatch_Location,0,100,["Group","Static","Vehicles"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	
		
		
	// Diary
		_taskInformation_displayName = ([_OverwatchBld] call RALLYUP_fnc_text_GetInfo) select 1;
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_Overwatch_Location, 300, 0] call BIS_fnc_relPos;
		_taskType = "Attack";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Attack_ca.paa' width='50px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	OPFOR are occupying a %1 at %2 near %3.
			<br/>	Attack the area and kills all units.
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Attack %2 until all enemies are defeated.
			<br/>
			<br/>
			<br/>TIPS:
			<br/>	Mission will be complete after all hostile are eliminated.
			<br/>			
		",_taskInformation_displayName,_Overwatch_Location,_LocationName];	
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
	
	
	// Task Event
		waituntil {
			sleep 30;
			_distance = ([AllPlayers] call RALLYUP_fnc_Position_3dCenter) distance _Overwatch_Location;
			if ((_distance < 100) or (!isNil "RALLYUP_SkipMissions")) exitWith {true};
			false
		};
		
		[_Overwatch_Location,_waveamount] spawn RALLYUP_fnc_create_reinforcements;
		
		waituntil {
			sleep 10;
			
			_count = {alive _x && side _x != (RallyUpBluFor select 0) && _x distance _OverwatchBld < 500 } count allUnits;	
			
			if (_count < 1) exitWith {_Task_Status = "Succeeded";true};
			if (!isNil "RALLYUP_SkipMissions") exitWith {RALLYUP_SkipMissions = nil;_Task_Status = "Canceled";true};
				false
		};
			
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status =  "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
