
/*
	Author: CodeRedFox
	Uses: Creates a Ambush task. A few vehicles are broken down and need to be destroyed.
	Note: 
	Usage: [position] execVM "missions\Primary_Ambush.sqf"
	Examples:[position player] execVM "missions\Primary_Ambush.sqf"

*/ diag_log format ["RallyUpDiag Starting: Mission_Ambush.sqf | %1",_this select 0];
if (!isServer) exitwith {};
	
	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
		
		_minDistance = RALLYUP_minDistance+((count allplayers)*50);
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);	
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_AmbushvehArray = [];
		
	// Find Tasking Location
	
		_Ambush_Location =[allplayers] call RALLYUP_fnc_Position_3dCenter;
		if (_Ambush_Location distance2d _TaskingPosition > _maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of _maxDistance"];true};	// Will cancel if the task to to far away	
		_LocationNamed = [_Ambush_Location] call RALLYUP_fnc_position_LocationsName;
	
	// Create Starting Enemy's
		// Create Guards
		[_Ambush_Location,_minDistance/2,_minDistance/4,["Unit","Group"],_waveamount,"DEFEND"] spawn RALLYUP_fnc_create_Enemy;
		[_Ambush_Location,150,_minDistance*2,["Vehicles"],_waveamount,"DEFEND"] spawn RALLYUP_fnc_create_Enemy;		
		[_Ambush_Location,_waveamount] spawn RALLYUP_fnc_create_reinforcements;
		
	// Diary
		_taskTitle = "Ambushed";
		_taskPosition = _Ambush_Location;
		_taskType = "Defend";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Defend_ca.paa' width='50px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	Your being amushed!
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Defend yourself fromthe ambush.
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>			
		"];		
		
		_Task_Name = str formatText ["%1%2",_taskType,time];		
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
			
		waituntil {	
			sleep 10;
			_EnemyTrigger = [RALLYUP_TOTAL_ENEMY_UNITS,(RallyUpOpFor select 0),_Ambush_Location,_minDistance,5] call RALLYUP_fnc_task_isTriggered;
			if ({alive _x} count allplayers < 0) exitWith {_Task_Status = "Failed";true};
			if (!_EnemyTrigger) exitWith {_Task_Status = "Succeeded";true};
				false
		};					
		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
