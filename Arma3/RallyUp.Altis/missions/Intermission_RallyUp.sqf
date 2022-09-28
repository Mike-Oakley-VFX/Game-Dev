
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
				
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		
	// Find Tasking Location
		_TaskLocation = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance,RALLYUP_LocationsPoints,5] call RALLYUP_fnc_position_Locations; 
		if (_TaskLocation distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};
		
	// Diary
			_taskTitle = "Rally Up!";
			_taskStatus = "Canceled";
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
			if (_areaTrigger) exitWith {_taskStatus = "Succeeded";true};
			
			if ((getMarkerPos "respawn_West") distance _taskPosition > RALLYUP_maxDistance) exitWith {_taskStatus = "Canceled";true};
				false
		};	
		
// Task End Events
[_Task_Mission,_taskStatus] call BIS_fnc_taskSetState;
sleep 5;
if(true) exitWith {[_Task_Mission] call BIS_fnc_deleteTask};
