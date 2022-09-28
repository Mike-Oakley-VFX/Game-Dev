
/*
	Author: CodeRedFox
	Uses: Creates a RallyUp Mission. All units move to the task position.
	Note: 
	Usage: [position] execVM "missions\Intermission_RallyUp.sqf"
	Examples:[position player] execVM "missions\Intermission_RallyUp.sqf"

*/ diag_log format ["RallyUpDiag Starting : Intermission_RallyUp.sqf | %1 | %2",time,serverTime];
if (!isServer) exitwith {};
	
	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
				
		_minDistance = RALLYUP_minDistance/2;
		_maxDistance = RALLYUP_maxDistance/2;	
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		
	// Find Tasking Location
		_TaskLocation = [_TaskingPosition,_minDistance,_maxDistance,RALLYUP_LocationsPoints,5] call RALLYUP_fnc_position_Locations; 
		if (_TaskLocation distance2d _TaskingPosition > _maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of _maxDistance"];true};
		
	// Diary
			_taskTitle = "Rally UP!";
			_taskPosition = _TaskLocation;
			_taskType = "Move";
			_taskDescription = str formatText ["
				<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Move_ca.paa' width='50px' />
				<br/>
				<br/>O P S E C : -----------------
				<br/>	All groups Rally Up! at %1
				<br/>
				<br/>
				<br/>O B J E C T I V E : -----------------
				<br/>
				<br/>	- Rally Up! at %1
				<br/>
				<br/>			
				<br/>TIPS:
				<br/>	The Objective is not finished until everyone is at the Rally Up point
			",_taskPosition];
			_Task_Name = str formatText ["%1%2",_taskType,time];			
			_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
		// Tasking End
		
	// Create Enemy's

		[_TaskingPosition,200,500,["Unit","Group"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;		
		
		
	// Task Event
		waituntil {
			sleep 10;
			
			_areaTrigger = [allplayers,(RallyUpBluFor select 0),_taskPosition,50,75] call RALLYUP_fnc_task_isTriggered;					
			if (_areaTrigger) exitWith {_Task_Status = "Succeeded";true};
			if ((getMarkerPos "respawn_West") distance _taskPosition > _maxDistance) exitWith {_Task_Status = "Canceled";true};
				false
		};	
		
// Task End Events
if(true) exitWith {[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState};
