/*
	Author: CodeRedFox
	Uses: Creates a PayDay Mission. 
	Note: 
	Usage: [position] execVM "missions\Primary_PayDay.sqf"
	Examples:[position player] execVM "missions\Primary_PayDay.sqf"
*/ diag_log format ["RallyUpDiag Starting : Primary_PayDay.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	
	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";	
				
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_EnemyVehGroup = [];
		
	// Find Tasking Location
		_Ambush_Location = [_TaskingPosition,RALLYUP_minDistance,RALLYUP_maxDistance] call RALLYUP_fnc_position_LocationsRoad;
			if (_Ambush_Location distance2d _TaskingPosition > RALLYUP_maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of RALLYUP_maxDistance"];true};;	// Will cancel if the task to to far away
		
		_LocationNamed = [_Ambush_Location] call RALLYUP_fnc_position_LocationsName;

	// Create Starting Enemy's
	
		// Create Broken-down
		_EnemySupportGroup = (RALLYUP_Groups_EnemyMech select floor random count RALLYUP_Groups_EnemyMech) select 1;
		_nearRoads = _Ambush_Location nearRoads 100;
		_roadnum = 1;
		{
			_roadnum = _roadnum +1;			
			_AmbushvehX = _x createVehicle (position (_nearRoads select _roadnum));			
			_lookat = [_AmbushvehX,(roadsConnectedTo ((_AmbushvehX nearRoads 50) select 0) select 0)] call BIS_fnc_DirTo;		
			_AmbushvehX setDir _lookat; 			
			_AmbushvehX setFuel 0;			
			_AmbushvehX Lock true;
			_EnemyVehGroup pushback _AmbushvehX;
			["AmmoboxInit",[_AmbushvehX,true]] call BIS_fnc_arsenal;		
		
			[_AmbushvehX] spawn RALLYUP_fnc_task_RandomDamage;
			
		
		} foreach _EnemySupportGroup;

		// Create Guards

		[_Ambush_Location,10,100,["Group","Static"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;		
		[_Ambush_Location,_waveamount] spawn RALLYUP_fnc_create_reinforcements;
sleep 10;
	// Diary
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = _Ambush_Location;
		_taskType = "Destroy";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Destroy_ca.paa' width='50px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	A enemy group has broken down somewhere near %1.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Destroy %2 of the vehicles
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>
			<br/>	All the supply vehicles have 'Arsenal' i.e Unlimited weapons.
			
		",_LocationNamed,count _EnemySupportGroup];	
		
		_Task_Name = str formatText ["%1%2",_taskType,time];
		
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
		
		
		
		waituntil {	
			sleep 10;
				if (({side _x != (RallyUpBluFor select 0)} count allUnits) <= 1) then {
					[_TaskLocation,1] spawn RALLYUP_fnc_create_reinforcements;
				};
			
			if ({alive _x} count _EnemyVehGroup == 0) exitWith {_Task_Status = "Succeeded";true};
			if (!isNil "RALLYUP_SkipMissions") exitWith {RALLYUP_SkipMissions = nil;_Task_Status = "Canceled";true};
				false
		};		

// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status =  "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
