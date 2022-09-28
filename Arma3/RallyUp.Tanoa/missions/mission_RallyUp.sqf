/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [position] execVM "missions\mission_RallyUp.sqf";
	Examples: [position player] execVM "missions\mission_RallyUp.sqf"; 
	Return: N/A

*/ 

diag_log format ["RallyUp : mission_RallyUp.sqf | START %1",serverTime];

if (!isServer) exitwith {};

	// Variables
		_providedPos = getMarkerPos RALLYUP_Respawn_MRK;
		_Task_Status = "Canceled";
		
	// Finding location		
		_missionLocation = [_providedPos, RALLYUP_minDist/2,RALLYUP_minDist, 0 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		if( (_missionLocation select 0 == -100) or (_providedPos distance _missionLocation > RALLYUP_maxDist ) ) exitWith {
			diag_log format ["RallyUp : mission_RallyUp.sqf | FAILED %1 | %2",_missionLocation,_providedPos];
			true
		}; // exits if no

	// Island check
		[_providedPos, _missionLocation ] execVM "missions\mission_boatTransport.sqf"; 
	
	// DIARY --------------------------------------------------------------------------------------------------------------------
	sleep 10;
		// Main TASK			
			_taskMissionName = "Rally Up";
			_taskDate = format ["%4%5 / %2%3 / %1 ",date select 0,["", "0"] select (date select 1 < 10),date select 1,["", "0"] select (date select 2 < 10),date select 2];						
			_taskPosition = _missionLocation;	
			_taskNearLocation = ( text nearestLocation [_taskPosition, "NameLocal"]+ ", " + worldName);
			_taskType = "navigate";

			_taskText = str formatText ["
				<br/>	OPSEC (Operational Security) 
				<br/>
				<br/>	MISSION: %1
				<br/>	DATE: %2
				<br/>	LOCATION : %3
				<br/>	 
				<br/>	MISSION
				<br/>	- Move to this location and Rally Up.
				<br/>
				<br/>	NOTES
				<br/>	- All players and units need to move to this position.
				",
				_taskMissionName,
				_taskDate,
				_taskNearLocation
			];

			_taskID = str formatText ["%1%2",_taskType,serverTime];	
			_Task_Mission = [RALLYUP_Friend_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"ASSIGNED",1,true] call BIS_fnc_taskCreate;
			[_Task_Mission,_taskType] call BIS_fnc_taskSetType;	
	
	// Start MISSION ----------------------------------------------------------------------------
		waitUntil {
			sleep 10;

			// Mission COMPLETE
			_SearchDistance = [_taskPosition, RALLYUP_Friend_Side, allUnits, 3] call RALLYUP_fnc_position_distCheck;
			if (_SearchDistance < 50 ) exitWith { _Task_Status = "SUCCEEDED";true};
				false // Loop this until true
		};
		
		[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState;

diag_log format ["RallyUp :  mission_RallyUp.sqf | END %1",serverTime];
if(true) exitWith {	[_Task_Mission] call BIS_fnc_deleteTask; [RALLYUP_Enemy_Side,_taskPosition] call RALLYUP_fnc_task_UpdateSpawns; };
