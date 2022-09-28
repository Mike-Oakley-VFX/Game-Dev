
/*
	Author: CodeRedFox
	Uses: 
	Note: 
	Usage: [position] execVM "mission\Mission_Templet.sqf"
	Examples:[position player] execVM "mission\Mission_Templet.sqf"
	
*/ diag_log format ["RallyUpDiag Starting : Mission_Templet.sqf | %1 | %2",time,serverTime];

// Variables
	_Position = _this select 0;
	_Task_Status = "Canceled";
	
	_waveamount = ceil (random RALLYUP_EnemyMultiplier);
	
	
// Tasking Locations
	_Task_Location = 
	_Task_LocationName =
	
// Starting Enemy
	_Enemy = [_buildingPos,0,0,["Unit","Group","Static","Vehicles","Boats","Helicopters","Jets"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	_EnemyReEnforments = [_Task_Location,_waveamount] spawn RALLYUP_fnc_create_reinforcements;

// Diary

	_taskTitle = ([] call RALLYUP_fnc_text_RandomName) select 0; // Calls random mission name
	_taskPosition = _Task_Location;
	_taskType = "Defend"; // Attack, Defend, Destroy, Interact, Search, Support
	_taskDescription = str formatText ["
		<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Defend_ca.paa' width='50px'/>
		<br/>
		<br/>O P S E C : -----------------
		<br/>
		<br/>	Move and defend the position at %1 near %2
		<br/>
		<br/>
		<br/>O B J E C T I V E : -----------------
		<br/>
		<br/>	- Defend %1 until all enemies are defeated.
		<br/>
		<br/>
		<br/>TIPS:
		<br/>	Mission will be complete after all hostile are eliminated.
		<br/>			
	",_Task_Location,_Task_LocationName];	
	_Task_Name = str formatText ["%1%2",_taskType,time];
	_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;

// Task Event, Normally a waituntil loop
	waituntil {
		if () exitwith {_Task_Status = "Succeeded";true}
		if () exitWith {_Task_Status = "Failed";true};
		if () exitWith {_Task_Status = "Canceled";true};
			false
	};

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	
diag_log format ["RallyUpDiag End : Mission_Templet.sqf | %1 | %2",time,serverTime];
if(true) exitWith {};
