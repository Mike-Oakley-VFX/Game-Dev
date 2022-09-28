/*
	Author: CodeRedFox
	Uses: Creates a PayDay Task
	Note: 
	Usage: [position] execVM "missions\Primary_Reward.sqf"
	Examples:[position player] execVM "missions\Primary_Reward.sqf"
*/ 

// Server Info
diag_log format ["RallyUpDiag Starting : Primary_Reward.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	
	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
				
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		
	// Find Tasking Location	
		_Reward_Location = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance,RALLYUP_LocationsPoints,5] call RALLYUP_fnc_position_Locations;
			if (_Reward_Location distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};	// Will cancel if the task to to far away	
	
		_LocationNamed = [_Reward_Location] call RALLYUP_fnc_position_LocationsName;
		
	// Create Reward	
		_theRewards = RALLYUP_Groups_FriendlyMech+RALLYUP_Groups_FriendlyHelicopters;
		_RewardGroups = (_theRewards select floor random count _theRewards) select 1;
		_RewardSelects = _RewardGroups select floor random count _RewardGroups;
				
		_Reward = _RewardSelects createVehicle _Reward_Location;	
		_Reward lock true;
	
	// Create Guards		
		//[_Reward_Location,0,300,["Group","Static","Vehicles"],_waveamount*2,"PATROL"] spawn RALLYUP_fnc_create_Enemy;	
	
	
	// Diary
		_taskInformation = ([_Reward] call RALLYUP_fnc_text_GetInfo);
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_Reward_Location, 300, 0] call BIS_fnc_relPos;
		_taskType = "Defend";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Defend_ca.paa' width='50px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	Hostile forces are guarding an abandoned friendly vehicle in the %3 AO.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>	<img image='%4' width='50px'/>
			<br/>	- Kill all the defenders in the area.
			<br/>	- Recover %2. Its your!
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>	- Vehicle is locked until missions is completed.
			<br/>	- Static weapons need to be destroyed as well.
			<br/>
			<br/>
			<br/>		
		",_LocationNamed,_taskInformation select 1,_LocationNamed,_taskInformation select 3];	
		
		_Task_Name = str formatText ["%1%2",_taskType,time];
		
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
			
		
		// Task Event
		waituntil {
			sleep 5;			
			_areaTrigger = [allplayers,(RallyUpBluFor select 0),_Reward_Location,RALLYUP_minDistance,75] call RALLYUP_fnc_task_isTriggered;							
			if (_areaTrigger or !Alive _Reward) exitWith {true;};
				false
		};
		
		[_Reward_Location,_waveamount] spawn RALLYUP_fnc_create_reinforcements;
		
		waituntil {
			sleep 5;			
			_EnemyTrigger = [RALLYUP_TOTAL_ENEMY_UNITS,(RallyUpOpFor select 0),_Reward_Location,RALLYUP_minDistance,10] call RALLYUP_fnc_task_isTriggered;						
			if (!_EnemyTrigger && Alive _Reward) exitWith {_Task_Status = "Succeeded";true};
			if (!Alive _Reward) exitWith {_Task_Status = "Failed";true};
				false
		};
		
		_Reward lock false;

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status =  "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
