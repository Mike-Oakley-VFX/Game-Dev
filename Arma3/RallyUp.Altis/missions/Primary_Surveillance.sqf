
/*
	Author: CodeRedFox
	Uses: Creates a Defend Task
	Note: 
	Usage: [position] execVM "missions\Primary_Surveillance.sqf";
	Examples:[position player] execVM "missions\Primary_Surveillance.sqf";

*/ diag_log format ["RallyUpDiag Starting : Primary_Surveillance.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_currentLocation = _this select 0;
		_Task_Status = "Canceled";			
		_waveamount = random 8+1;		
		_SurveillanceGroup = createGroup (RallyUpOpFor select 0);
		
		_RALLYUP_Random_UAV = [1,["UAV_01_F","UAV_02"], "" ] call RALLYUP_fnc_task_ArrayofCfg;
		_RALLYUP_Random_Mortars = [1,["Mortar_01_F"], "" ] call RALLYUP_fnc_task_ArrayofCfg;
		
	// Create UAV's	
		_SurveillancefoundLocation = [_currentLocation, 1000, 2000, 10, 0, 5, 0] call BIS_fnc_findSafePos;
		_SurveillanceVehSelect = _RALLYUP_Random_UAV select floor random count _RALLYUP_Random_UAV;	
		_SurveillanceVeh = [_SurveillancefoundLocation, random 360,_SurveillanceVehSelect, _SurveillanceGroup] call bis_fnc_spawnvehicle;
		
		//(_SurveillanceVeh select 0) flyinheight 300;
		(_SurveillanceVeh select 0) disableAi "TARGET";	
		(_SurveillanceVeh select 0) disableAi "AUTOTARGET";
		(_SurveillanceVeh select 0) setCombatMode "BLUE";
		(_SurveillanceVeh select 0) setBehaviour "CARELESS";	

		_EnemySurveillanceWP = _SurveillanceGroup addWaypoint [_currentLocation, 0];
		
		_EnemySurveillanceWP setWaypointBehaviour "CARELESS";
		_EnemySurveillanceWP setWaypointType "LOITER";
		_EnemySurveillanceWP setWaypointLoiterType "CIRCLE";
		_EnemySurveillanceWP setWaypointLoiterRadius 400;	
		
		
	// Wait until UAV flies over players	
		waituntil {	
			_Searchfound =[allplayers] call RALLYUP_fnc_Position_3dCenter;
			((_SurveillanceVeh select 1) select 0) domove _Searchfound;
			if ((_SurveillanceVeh select 0) distance _Searchfound < 1000 or (!alive (_SurveillanceVeh select 0))) exitWith {true};
			false
		};			

		
	// Create Enemy's
		_mortarCount = ceil (random 5);
		_mortarGroup = createGroup (RallyUpOpFor select 0);
		_SurveillancefoundLocation = [getpos (_SurveillanceVeh select 0), 500, 1000, 10, 0, 5, 0] call BIS_fnc_findSafePos;
		
		for "_i" from 1 to _mortarCount do {	
			_MortarfoundLocation = [_SurveillancefoundLocation, 5, 300, 10, 0, 30, 0] call BIS_fnc_findSafePos;		
			_MortarVehArray = (RALLYUP_Groups_EnemyStatic select 4) select 1;		
			_MortarVehSelect = _MortarVehArray select floor random count _MortarVehArray;		
			[_MortarfoundLocation, 180,_MortarVehSelect, _mortarGroup] call bis_fnc_spawnvehicle;
		};
		
	// Create Guard		
		_Enemy = [_SurveillancefoundLocation,10,50,["Group"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
		[_SurveillancefoundLocation,_Enemy,1000] call BIS_fnc_taskPatrol;	
				
	// Tasking Start
		_taskInformation = [_SurveillanceVeh select 0] call RALLYUP_fnc_text_GetInfo;
		
		_Surveillance_LocationName = ([_SurveillancefoundLocation] call RALLYUP_fnc_position_LocationsName);
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;	
		_taskPosition = [_SurveillancefoundLocation, 0, 500, 0, 0, 5, 0] call BIS_fnc_findSafePos;	
		_taskType = "Search";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Search_ca.paa' width='50px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	You are being tracked and targeted by a %1.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------			
			<img image='%3' width='100px'/>
			<br/>
			<br/>	- Search the area around %2 and eliminate the mortar team.	
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>
			<br/>	- Destroying the %1 or mortars will end the mission.
			<br/>	- Hiding will cease the targeting ability.
			<br/>	- Sometimes the mortars themselves have to be destroyed!
			<br/>
		",_taskInformation select 1,_Surveillance_LocationName,_taskInformation select 3];	
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
	// Tasking End	
	
			
	// Create tasking						
		waituntil {	
			_foundunits = [];			
			_Searchfound = [allPlayers] call RALLYUP_fnc_Position_3dCenter;
			
			_EnemySurveillanceWP setWaypointPosition [_Searchfound,0];			
			
			{
				if ( side _x == (RallyUpBluFor select 0) ) then {
					_UAVLookat = lineIntersects [ eyePos (_SurveillanceVeh select 0), eyePos _x,(_SurveillanceVeh select 0) ,_x];
					
					if ((!_UAVLookat) && (_x distance (_SurveillanceVeh select 0) < 1000)) then {
						_foundunits pushBack _x;
						hint format ["%1 was spotted!",name _x];	
						_target = [getpos _x, random 100, random 360] call BIS_fnc_relPos;					
						{
							_mortarVeh = vehicle _x;
							_mortarVeh setvehicleammo 1;
							_mortarRounds = random 3;
							_x commandArtilleryFire [_target ,"8Rnd_82mm_Mo_shells",_mortarRounds];
						} foreach units _mortarGroup;
					};
					//sleep (random 30)+10;
					sleep 1;
				};
			} foreach allUnits;				
			
			
		// Conditions
			if ((count units _mortarGroup <= 0) or (!alive (_SurveillanceVeh select 0)))exitWith {_Task_Status = "Succeeded";true};
			if (!isNil "RALLYUP_SkipMissions") exitWith {RALLYUP_SkipMissions = nil;_Task_Status = "Canceled";true};			
				false				
		};	
		
		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // "Succeeded","Failed","Canceled"
	
// Clean up
	_cleanup = [_SurveillanceGroup,_mortarGroup];	
	{
		{deleteVehicle vehicle _x} forEach (units _x);
		{deleteVehicle _x} forEach (units _x);
		deleteGroup _x;
	} foreach _cleanup;	
	
if(true) exitWith {};
