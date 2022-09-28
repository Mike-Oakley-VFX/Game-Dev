/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [position] execVM "missions\mission_HVT.sqf";
	Examples: [position player] execVM "missions\mission_HVT.sqf"; 
	Return: N/A

*/ 

diag_log format ["RallyUp : mission_HVT.sqf | START %1",serverTime];

if (!isServer) exitwith {};

	// Variables
		_providedPos = _this select 0;
		_multiplyer = RALLYUP_EnemyMultiplier;
		_enemyGroup = createGroup RALLYUP_Enemy_Side;
		_Task_Status = "Canceled";
		
	// Finding location		
		_missionLocation = [_providedPos, RALLYUP_minDist,RALLYUP_maxDist, 0 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		if( ( _missionLocation select 0 == -100) or (_providedPos distance _missionLocation > RALLYUP_maxDist)) exitWith {  diag_log format ["RallyUp : mission_HVT.sqf | FAILED %1",serverTime];true}; // exits if no

	// Island check
		[_providedPos, _missionLocation ] execVM "missions\mission_boatTransport.sqf"; 	

	// Create Target
		sleep 1;
		_missionGroup = createGroup RALLYUP_Enemy_Side;
		_missionTarget = [_missionLocation,["Unit"],"DEFEND",_missionGroup,(random 3)+RALLYUP_EnemyMultiplier] call RALLYUP_fnc_create_Enemy;

	
	// Create Gaurds
		sleep 1;
		_guardDefendGroup = createGroup RALLYUP_Enemy_Side;
		_guardDefend = [_missionLocation,["Unit","Static"],"DEFEND",_guardDefendGroup,(random 3)+1] call RALLYUP_fnc_create_Enemy;		

	// Create Patrols	
		sleep 1;
		_guardPatrolsGroup = createGroup RALLYUP_Enemy_Side;
		_guardPatrols = [_missionLocation,["Unit","Mech","Air","Water"],"PATROL",_guardPatrolsGroup,(random 6)+1] call RALLYUP_fnc_create_Enemy;			
		
	// Create reenforcement triggers		
		_triggerReinforcements = createTrigger ["EmptyDetector", _missionLocation];
		_triggerReinforcements setTriggerArea [RALLYUP_minDist, RALLYUP_minDist, 0, false];
		_triggerReinforcements setTriggerActivation [str RALLYUP_Enemy_Side, "PRESENT", true];
		_triggerReinforcements setTriggerStatements ["this","
		[ getpos thisTrigger,['Paratroopers','FART'],'NONE',createGroup RALLYUP_Enemy_Side,3] spawn RALLYUP_fnc_create_Enemy;
		","deletevehicle thisTrigger;"];

	// DIARY --------------------------------------------------------------------------------------------------------------------
	
		// Main TASK
			_taskMissionName = ["Mission"] call RALLYUP_fnc_text_RandomName;	
			_taskDate = format ["%4%5 / %2%3 / %1 ",date select 0,["", "0"] select (date select 1 < 10),date select 1,["", "0"] select (date select 2 < 10),date select 2];						
			_taskPosition = [_missionLocation, (random RALLYUP_minDist), random 360] call BIS_fnc_relPos;	
			_taskNearLocation = ( text nearestLocation [_taskPosition, "NameLocal"]+ ", " + worldName);
			_taskType = "search";
			_taskTypePic = str 'A3\UI_F_MP_Mark\Data\Tasks\Types\' + _taskType + '_ca.paa';			
			_taskEnemyAmount = [ { (side _x == RALLYUP_Enemy_Side) } count allUnits,  { side _x == RALLYUP_Enemy_Side} count vehicles ];

			_taskText = str formatText ["
				
				<br/>	OPSEC (Operational Security) 
				<br/>
				<br/>	MISSION: %1
				<br/>	DATE: %2
				<br/>	LOCATION : %3
				<br/>	 
				<br/>	SUMMARY OF ENEMY SITUATION
				<br/>		a. Estimated %4 x Ground forces.
				<br/>		b. Estimated %5 x Vehicles assets
				<br/>		
				<br/>	MISSION
				<br/>	- Elimination of HVT(s).	
				<br/>
				<br/>	EQUIPMENT REQUIRED
				<br/>	- Gather intel on dead or captured enemy could provide furter location info.
				<br/>
				<br/>	Rules of engagement (ROE)
				<br/>	- Protect both combatants and non-combatants from unnecessary suffering.
				<br/>	
				<br/>	NOTES
				<br/>	- Look for intel on dead or captured enemys
				",
				_taskMissionName, 
				_TaskDate,
				_taskNearLocation,
				_taskEnemyAmount select 0,
				_taskEnemyAmount select 1
			];	

			_taskID = str formatText ["%1%2",_taskType,time];	
			_Task_Mission = [RALLYUP_Friend_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"AUTOASSIGNED",-1,true] call BIS_fnc_taskCreate;
			[_Task_Mission,_taskType] call BIS_fnc_taskSetType;		

				// SUB TASK	
			
				_subTaskCount = [];		
				{			
					sleep 2;
					_subTaskID = str formatText ["%1%2_SUBTASK_%3",_taskType,_taskMissionName,_forEachIndex];
					_subTaskCount pushback _subTaskID;
					_subTaskInfo = [_x] call RALLYUP_fnc_text_GetInfo;
					_subTaskName = _subTaskInfo select 0;
					_subTaskDisplayName = _subTaskInfo select 1;
					_subTaskPicture = _subTaskInfo select 2;
					_subTaskRank = _subTaskInfo select 4;					
					_subTaskLastLoc = [getpos _x, (random RALLYUP_minDist), random 360] call BIS_fnc_relPos;
					_subTaskType = "kill";

					_subTaskText = str formatText ["
						<br/>	NAME : %1
						<br/>	RANK : %2
						<br/>	ROLE : %3
						<br/>	
						<br/>	Last known location : %3
						",_subTaskName,_subTaskRank,_subTaskDisplayName,_subTaskLastLoc	];				
					

					_subTask_Mission = [RALLYUP_Friend_Side, [_subTaskID,_taskID], [_subTaskText,format ['Eliminate %1', _subTaskName] ,_subTaskType] ,_subTaskLastLoc, "AUTOASSIGNED", -1, true] call BIS_fnc_taskCreate;
					[_subTaskID,_subTaskType] call BIS_fnc_taskSetType;

					// intel tasking
					[_subTaskID, 0 , RALLYUP_Friend_Side , _subTaskLastLoc , _x , 1 , nil ] call RALLYUP_fnc_task_intel;

					// stores the task ID number
					_x setVariable [ 'SUBTASKID',_subTaskID ];

				} foreach units _missionGroup;
	
	// Start MISSION ----------------------------------------------------------------------------
		_MST = serverTime; // Mission Start Time
		waitUntil {
			sleep 30;

			// Mission COMPLETE
			{if (damage _x > 0.9) then {[ _x getVariable "SUBTASKID","SUCCEEDED"] call BIS_fnc_taskSetState;}} foreach units _missionGroup;
			if (({_x call BIS_fnc_taskCompleted;} count _subTaskCount) == count _subTaskCount) exitWith {{if (side _x == RALLYUP_Enemy_Side) then {_x allowFleeing 1;};} forEach allGroups;[_Task_Mission,"SUCCEEDED"] call BIS_fnc_taskSetState;true};
			
				false // Loop this until true
		};
		
	
diag_log format ["RallyUp : mission_HVT.sqf | END %1",serverTime];	
if(true) exitWith {};