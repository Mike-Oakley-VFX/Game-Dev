/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [_providedPos, _missionPos] execVM "missions\support_HeliTransport.sqf";
	Examples: [position player, [0,0,0]] execVM "missions\support_HeliTransport.sqf";
	Return: N/A

*/ 

if (!isServer) exitwith {};


	// Variables
		_providedPos = _this select 0;
		_missionPos = _this select 1;
		_Task_Status = "Canceled";
		
	// Finding location
		_SpawnPosition = [_providedPos, RALLYUP_maxDist, (random 360)] call BIS_fnc_relPos;
		_missionLocation = [ _providedPos, RALLYUP_maxDist, RALLYUP_maxDist*4, 1 , 2 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;

	// Create Support Helo
		_heloGroup = createGroup [RALLYUP_Friendly_Side,true];
		_pickedvehicleType = RALLYUP_Random_FriendlyHeliTrans select floor random count RALLYUP_Random_FriendlyHeliTrans;
		_Helo = createVehicle [_pickedvehicleType, _missionLocation, [], 0, "NONE"];
		[_SpawnPosition, 0,_pickedvehicleType, _heloGroup] call bis_fnc_spawnvehicle;
		

	// Create waypoints
		_VehGroupWP01  = _heloGroup addWaypoint [_providedPos,RALLYUP_minDist];
		_VehGroupWP01  setWaypointType "Move";
		_VehGroupWP01  setWaypointBehaviour "CARELESS";
		_VehGroupWP01  setWaypointStatements ["true", "
			{(vehicle _x) land 'LAND'} foreach thisList;
		"];

/*

	

	// DIARY --------------------------------------------------------------------------------------------------------------------
		// Main TASK			
			_taskMissionName = "Boat Transport";
			_taskDate = format ["%4%5 / %2%3 / %1 ",date select 0,["", "0"] select (date select 1 < 10),date select 1,["", "0"] select (date select 2 < 10),date select 2];						
			_TaskInfo = [_boat] call RALLYUP_fnc_text_GetInfo;
			_taskPosition = _missionLocation;	
			_taskNearLocation = ( text nearestLocation [_taskPosition, "NameLocal"]+ ", " + worldName);
			_taskType = "boat";

			_taskText = str formatText ["
				<br/>	OPSEC (Operational Security) 
				<br/>
				<br/>	MISSION: %1
				<br/>	DATE: %2
				<br/>	LOCATION : %3
				<br/>	 
				<br/>	MISSION
				<br/>	- Optional %4 avaliable.
				<br/>
				<br/>	NOTES
				<br/>	- This is an option mission and will cancel if you get to far away.
				",
				_taskMissionName,
				_taskDate,
				_taskNearLocation,
				_TaskInfo select 0
			];

			_taskID = str formatText ["%1%2",_taskType,serverTime];	
			_Task_Mission = [RALLYUP_Friend_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"AUTOASSIGNED",-1,true] call BIS_fnc_taskCreate;
			[_Task_Mission,_taskType] call BIS_fnc_taskSetType;	
	
	// Start MISSION ----------------------------------------------------------------------------
		waitUntil {
			sleep 60;

			// Mission COMPLETE
			_SearchDistance = [_taskPosition, RALLYUP_Friend_Side, allUnits, 1] call RALLYUP_fnc_position_distCheck;
			if (_SearchDistance < 100 ) exitWith { [_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;true};
			if (_SearchDistance > RALLYUP_minDist ) exitWith { [_taskID,"Canceled"] call BIS_fnc_taskSetState;true};
			
				false // Loop this until true
		};
		
	
diag_log format ["RallyUp : mission_boatTransport.sqf | END %1",serverTime];	
if(true) exitWith {
	sleep 10;
	[_Task_Mission] call BIS_fnc_deleteTask;
	[RALLYUP_Enemy_Side,_taskPosition] call RALLYUP_fnc_task_UpdateSpawns;	
};
