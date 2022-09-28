/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [position] execVM "missions\mission_DestroyMortars.sqf";
	Examples: [position player] execVM "missions\mission_DestroyMortars.sqf"; 
	Return: N/A

*/ 

diag_log format ["RallyUpDiag Starting : mission_DestroyMortars.sqf | START %1",serverTime];

if (!isServer) exitwith {};

	// Variables
		_providedPos = _this select 0;
		_multiplyer = RALLYUP_EnemyMultiplier;		
		_Task_Status = "Canceled";
		

	// Finding location		
		_missionLocation = [_providedPos, RALLYUP_minDist,RALLYUP_maxDist, 1 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		if( ( _missionLocation select 0 == -100) or (_providedPos distance _missionLocation > RALLYUP_maxDist)) exitWith {diag_log format ["RallyUp : mission_DestroyMortars.sqf | FAILED %1 | %2",_missionLocation select 0,_providedPos distance _missionLocation];true}; // exits if non


	// Island check
		[_providedPos, _missionLocation ] execVM "missions\mission_boatTransport.sqf"; 

	// Create Target
		_missionGroup = createGroup RALLYUP_Enemy_Side;
		_spawnMin = RALLYUP_minDist; _spawnMax = RALLYUP_maxDist; _isWater = 0; _direction=0;
		_foundLocation = [_missionLocation, _spawnMin, _spawnMax, 1 , _isWater, 0.1 ] call BIS_fnc_findSafePos;
		for "_i" from 1 to (random [1,3,5]) do {			
			_mortarPit = [_foundLocation, 1, RALLYUP_minDist, 1 , _isWater, 0.1 ] call BIS_fnc_findSafePos;	
			_classRandomPick = RALLYUP_Random_EnemyMortars select floor random count RALLYUP_Random_EnemyMortars;
			[_mortarPit, _direction,_classRandomPick, _missionGroup] call bis_fnc_spawnvehicle;
		};
		_missionGroupVeh =( [_missionGroup, true] call BIS_fnc_groupVehicles);
		_mortarTypes = ["8Rnd_82mm_Mo_shells","8Rnd_82mm_Mo_Flare_white", "8Rnd_82mm_Mo_Smoke_white" ];

	// Create Surveillance
		_uavGroup = createGroup RALLYUP_Enemy_Side;
		_spawnMin = RALLYUP_minDist*2; _spawnMax = RALLYUP_maxDist; _isWater = 0; _direction=0;
		_classRandomPick = (RALLYUP_Random_EnemyUAV+RALLYUP_Random_EnemyHeliTrans) select floor random count (RALLYUP_Random_EnemyUAV+RALLYUP_Random_EnemyHeliTrans);
		_uavLocation = [_missionLocation, _spawnMin, _spawnMax, 1 , _isWater, 0.1 ] call BIS_fnc_findSafePos;
		[_uavLocation, _direction,_classRandomPick, _uavGroup] call bis_fnc_spawnvehicle;
		_uavVeh = assignedVehicle (leader _uavGroup);

		_uavVeh disableAi "TARGET";	
		_uavVeh disableAi "AUTOTARGET";
		_uavVeh setCombatMode "BLUE";
		_uavVeh setBehaviour "CARELESS";	

		//_uavVeh flyinheight 500;
		_EnemySurveillanceWP = _uavGroup addWaypoint [_foundLocation, 10];		
		_EnemySurveillanceWP setWaypointBehaviour "CARELESS";
		_EnemySurveillanceWP setWaypointType "LOITER";
		_EnemySurveillanceWP setWaypointLoiterType "CIRCLE";
		_EnemySurveillanceWP setWaypointLoiterRadius 400;

	
	// Create Gaurds
		sleep 1;
		_guardDefendGroup = createGroup RALLYUP_Enemy_Side;
		_guardDefend = [_missionLocation,["Unit"],"DEFEND",_guardDefendGroup,(random 3)+1] call RALLYUP_fnc_create_Enemy;	

	// Create Patrols	
		sleep 1;
		_guardPatrolsGroup = createGroup RALLYUP_Enemy_Side;
		_guardPatrols = [_missionLocation,["Unit"],"PATROL",_guardPatrolsGroup,(random 3)+1] call RALLYUP_fnc_create_Enemy;			
		
	// Create reenforcement triggers		
		_triggerReinforcements = createTrigger ["EmptyDetector", _missionLocation];
		_triggerReinforcements setTriggerArea [RALLYUP_minDist, RALLYUP_minDist, 0, false];
		_triggerReinforcements setTriggerActivation [str RALLYUP_Friend_Side, "PRESENT", true];
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
				<br/>	- Disabled enemy mortar assets. These assests will need to be disabled (Small arms fire will normally disabled them)	
				<br/>
				<br/>	EQUIPMENT REQUIRED
				<br/>	- Gather intel on dead or captured enemy could provide furter location info.
				<br/>	- Mortars can be destroyed by small arms fire.
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
			_Task_Mission = [RALLYUP_Friend_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"AUTOASSIGNED",-1,true,_taskType] call BIS_fnc_taskCreate;
			//[_Task_Mission,_taskType] call BIS_fnc_taskSetType;		

				// SUB TASK				
				_subTaskCount = [];		
				{			
					
					sleep 2;
					_subTaskID = str formatText ["%1_SUBTASK_%2",_taskMissionName,_forEachIndex];
					_subTaskCount pushback _subTaskID;
					_subTaskInfo = [_x] call RALLYUP_fnc_text_GetInfo;
					_subTaskDisplayName = _subTaskInfo select 1;
					_subTaskPicture = _subTaskInfo select 2;		
					_subTaskLastLoc = [getpos _x, (random RALLYUP_minDist), random 360] call BIS_fnc_relPos;
					_subTaskType = "destroy";

					_subTaskText = str formatText ["
						<br/>	ASSET : %1
						<br/>
						<br/>   <img image='%2' width='128px'/>
						<br/>
						<br/>	Last known location : %3
						",
						_subTaskDisplayName,
						_subTaskPicture,
						_subTaskLastLoc	];					

					_subTask_Mission = [RALLYUP_Friend_Side, [_subTaskID,_taskID], [_subTaskText,format ['Destroy %1', _subTaskDisplayName] ,''] ,_subTaskLastLoc, "AUTOASSIGNED", -1, true,_subTaskType]call BIS_fnc_taskCreate;

					_x setVariable [ 'SUBTASK',_subTaskID];
					_x addeventhandler ["killed",{ _subTask =  (_this select 0) getVariable 'SUBTASK'; [_subTask,'SUCCEEDED'] call BIS_fnc_taskSetState; }];

					// intel tasking		
					//[_subTaskID, RALLYUP_Enemy_Side, _x, 1, 2 ] call RALLYUP_fnc_task_intel;

				} foreach _missionGroupVeh;


	// Setup subTaskID_UAV
		_subTaskID_UAV = str formatText ["%1%2",_taskType,time];
		_subTaskInfo_UAV = [_uavVeh] call RALLYUP_fnc_text_GetInfo;
		_subTaskDisplayName_UAV = _subTaskInfo_UAV select 1;
		_subTaskType_UAV = "danger";
		_subTaskText_UAV = str formatText ["
			<br/>	ASSET : %1
			<br/>
			<br/>	Intel is reporting a %1 is tracking your position.
			<br/>
			<br/>	EXPECT ARTILLERY FIRE!!!
			<br/>
			",
		_subTaskDisplayName_UAV];
			
	// Start MISSION ----------------------------------------------------------------------------
		_MST = serverTime; // Mission Start Time
		waitUntil {			

			
			if ( damage _uavVeh < 0.9 ) then {
				_SearchPos = [getpos _uavVeh, RALLYUP_Friend_Side, allUnits, 2] call RALLYUP_fnc_position_distCheck; 
				_SearchDistance = [getpos _uavVeh, RALLYUP_Friend_Side, allUnits, 1] call RALLYUP_fnc_position_distCheck;
				_EnemySurveillanceWP setWaypointPosition [_SearchPos,100] ;

				{
					
					_UAVLookat = lineIntersects [ eyePos _x, eyePos _uavVeh,_uavVeh];				
					if ( (!_UAVLookat) && (side _x == RALLYUP_Friend_Side) && (_SearchDistance < RALLYUP_maxDist )) then {
						_foundunit = _x;
						_spottedName = name _x;

						[RALLYUP_Friend_Side, [_subTaskID_UAV,_taskID], [_subTaskText_UAV , format ['%1 was spotted', _spottedName,_subTaskType_UAV] , getpos _foundunit ] ,getpos _foundunit, "AUTOASSIGNED", -1, true,_subTaskType_UAV] call BIS_fnc_taskCreate;
						
						// commands and resuppys mortar team
						[ _missionGroup , _foundunit, _mortarTypes ] spawn RALLYUP_fnc_task_commandArtillery;

						sleep 15;
						[_subTaskID_UAV,RALLYUP_Friend_Side ] call BIS_fnc_deleteTask;
					};
				} foreach allUnits;	
			};
			

			// Mission SUCCEEDED	
			if ( [ _taskID , 1, "SUCCEEDED" ] call RALLYUP_fnc_task_TaskStatus ) exitWith { _Task_Status = "SUCCEEDED";	_EnemySurveillanceWP setWaypointPosition [[0,0],100];true; };				

			sleep 10; // Default sleep for all missions
				false // Loop this until true
		};

		// Finalize task status
		[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState;

	
// EXIT
if(true) exitWith { 
	diag_log format ["RallyUpDiag Starting : mission_DestroyMortars.sqf | END %1",serverTime];
};