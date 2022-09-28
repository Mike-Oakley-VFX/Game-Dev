/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [position] execVM "missions\mission_DestroyPOI.sqf";
	Examples: [position player] execVM "missions\mission_DestroyPOI.sqf"; 
	Return: N/A

*/ 

diag_log format ["RallyUp : mission_DestroyPOI.sqf | START %1",serverTime];

if (!isServer) exitwith {};

	// Variables
		_providedPos = _this select 0;
		_multiplyer = RALLYUP_EnemyMultiplier;		
		_Task_Status = "Canceled";
		
	// Finding location		
		_missionLocation = [_providedPos, RALLYUP_minDist,RALLYUP_maxDist, 0 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		if( ( _missionLocation select 0 == -100) or (_providedPos distance _missionLocation > RALLYUP_maxDist)) exitWith {
			diag_log format ["RallyUp : mission_DestroyPOI.sqf | FAILED %1",serverTime];
			true
		}; // exits if non

	// Island check
		[_providedPos, _missionLocation ] execVM "missions\mission_boatTransport.sqf"; 

	// Create Target
		_MissionPOI =(RALLYUP_BldObjectives select floor random count RALLYUP_BldObjectives) createVehicle _missionLocation;

	// Create AmmoCache
		_missionGroup = createGroup RALLYUP_Enemy_Side;
		_ammoLocation = [_missionLocation, RALLYUP_minDist,RALLYUP_minDist*2, 1 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		_ammoSupply =(RALLYUP_AmmoCrates select floor random count RALLYUP_AmmoCrates) createVehicle _ammoLocation;
		clearItemCargo _ammoSupply;
		ClearWeaponCargo _ammoSupply;
		ClearMagazineCargo _ammoSupply;
		_ammoSupply additemcargo ["ToolKit", 2];
		_ammoSupply additemcargo ["SatchelCharge_Remote_Mag", 10];
		_ammoSupply additemcargo ["DemoCharge_Remote_Mag", 10];

	// Create Gaurds
		sleep 1;
		_guardDefendGroup = createGroup RALLYUP_Enemy_Side;
		_guardDefend = [_missionLocation,["Unit","Unit","Mech"],"DEFEND",_guardDefendGroup,(random 3)+1] call RALLYUP_fnc_create_Enemy;	

	// Create Patrols	
		sleep 1;
		_guardPatrolsGroup = createGroup RALLYUP_Enemy_Side;
		_guardPatrols = [_missionLocation,["Unit"],"PATROL",_guardPatrolsGroup,(random 3)+1] call RALLYUP_fnc_create_Enemy;			
		
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
				<br/>	- Destroy enemy assets.	
				<br/>
				<br/>	EQUIPMENT REQUIRED
				<br/>	- Gather intel on dead or captured enemy could provide furter location info.
				<br/>	- Assets destruction will require a large weapon. ( ex Explosives )
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
			_Task_Mission = [RALLYUP_Enemy_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"AUTOASSIGNED",-1,true] call BIS_fnc_taskCreate;
			[_Task_Mission,_taskType] call BIS_fnc_taskSetType;		

				// SUB TASK 01 	
				sleep 2;
				_subTaskID_target = str formatText ["%1%2",_taskType,time];
				_subTaskInfo_target = [_MissionPOI] call RALLYUP_fnc_text_GetInfo;
				_subTaskDisplayName_target = _subTaskInfo_target select 1;
				_subTaskLastLoc_target = [getpos _MissionPOI, (random RALLYUP_minDist), random 360] call BIS_fnc_relPos;
				_subTaskType_target = "destroy";

				_subTaskText_target = str formatText ["
					<br/>	ASSET : %1
					<br/>
					<br/>	Last known location : %2
					",
					_subTaskDisplayName_target,
					_subTaskLastLoc_target	];					

				_subTask_Mission_target = [RALLYUP_Friend_Side, [_subTaskID_target,_taskID], [_subTaskText_target,format ['Destroy %1', _subTaskDisplayName_target] ,_subTaskType_target] ,_subTaskLastLoc_target, "AUTOASSIGNED", -1, true] call BIS_fnc_taskCreate;
				[_subTaskID_target,_subTaskType_target] call BIS_fnc_taskSetType;

				// intel tasking
				[_subTaskID_target, 0 , RALLYUP_Friend_Side , _subTaskLastLoc_target , _MissionPOI , 1 , nil ] call RALLYUP_fnc_task_intel;

				// stores the task ID number
				_MissionPOI setVariable [ 'SUBTASKID',_subTaskID_target];


				// SUB TASK 02
				sleep 5;
				_subTaskID_ammo = str formatText ["%1%2",_taskType,time];
				_subTaskInfo_ammo = [_ammoSupply] call RALLYUP_fnc_text_GetInfo;
				_subTaskDisplayName_ammo = _subTaskInfo_ammo select 1;
				_subTaskLastLoc_ammo = getpos _ammoSupply;
				_subTaskType_ammo = "rearm";

				_subTaskText_ammo = str formatText ["
					<br/>	ASSET : %1
					<br/>
					<br/>	This Asset will need to be destroyed so it doesnt fall into enemy hands!
					<br/>
					<br/>	Last known location : %2
					",
					_subTaskDisplayName_ammo,
					_subTaskLastLoc_ammo	];					

				_subTask_Mission_ammo = [RALLYUP_Friend_Side, [_subTaskID_ammo,_taskID], [_subTaskText_ammo,format ['Demo %1', _subTaskDisplayName_ammo] ,_subTaskType_ammo] ,_subTaskLastLoc_ammo, "AUTOASSIGNED", -1, true] call BIS_fnc_taskCreate;
				[_subTaskID_ammo,_subTaskType_ammo] call BIS_fnc_taskSetType;

				// stores the task ID number
				_ammoSupply setVariable [ 'SUBTASKID',_subTaskID_ammo];				

				// intel tasking
				[_subTaskID_ammo, 0 , RALLYUP_Friend_Side , _subTaskLastLoc_ammo , _MissionPOI , 1 , nil ] call RALLYUP_fnc_task_intel;			
		
	_newarray = [];
	// Start MISSION ----------------------------------------------------------------------------
		_MST = serverTime; // Mission Start Time
		waitUntil {
			sleep 30;

			// Mission COMPLETE
			if ( ([_subTaskID_ammo] call BIS_fnc_taskState == "SUCCEEDED") and ( [_subTaskID_target] call BIS_fnc_taskState == "SUCCEEDED") ) exitWith { _Task_Status = "Succeeded";{ if (side _x == RALLYUP_Enemy_Side) then {_x allowFleeing 1;} } forEach allGroups;[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState;true };

			// Mission COMPLETE
			if ((damage _MissionPOI) > 0.9) then { [ _MissionPOI getVariable "SUBTASKID","SUCCEEDED"] call BIS_fnc_taskSetState; };
			if ((damage _ammoSupply) > 0.9) then { [ _ammoSupply getVariable "SUBTASKID","SUCCEEDED"] call BIS_fnc_taskSetState; };
			if ( (_taskID call BIS_fnc_taskState == "SUCCEEDED") && (_subTaskID_ammo call BIS_fnc_taskState == "SUCCEEDED") ) exitWith {{if (side _x == RALLYUP_Enemy_Side) then {_x allowFleeing 1;};} forEach allGroups;[_Task_Mission,"SUCCEEDED"] call BIS_fnc_taskSetState;true};
			// Mission FAILED

				false // Loop this until true
		};
		
	
diag_log format ["RallyUp : mission_DestroyPOI.sqf | END %1",serverTime];	
if(true) exitWith {};