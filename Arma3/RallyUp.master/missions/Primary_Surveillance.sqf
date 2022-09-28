
/*
	Author: CodeRedFox
	Uses: Creates a Defend Task
	Note: 
	Usage: [position] execVM "missions\Primary_Surveillance.sqf"
	Examples:[position player] execVM "missions\Primary_Surveillance.sqf"

*/ diag_log format ["RallyUpDiag Starting : Primary_Surveillance.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_currentLocation = _this select 0;
		_Task_Status = "Canceled";
		
		_minDistance = RALLYUP_minDistance+((count allplayers)*50);
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);			
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
		_SurveillanceGroup = createGroup (RallyUpOpFor select 0);
		
	// Create UAV's	
		_SurveillancefoundLocation = [_currentLocation, 1000, 2000, 10, 0, 5, 0] call BIS_fnc_findSafePos;
		_SurveillanceVehArray = (RALLYUP_Groups_EnemyJets select floor random count RALLYUP_Groups_EnemyJets) select 1;
		_SurveillanceVehSelect = _SurveillanceVehArray select floor random count _SurveillanceVehArray;	
		_SurveillanceVeh = [_SurveillancefoundLocation, random 360,_SurveillanceVehSelect, _SurveillanceGroup] call bis_fnc_spawnvehicle;
		
		(_SurveillanceVeh select 0) flyinheight 500;
		(_SurveillanceVeh select 0) disableAi "TARGET";	
		(_SurveillanceVeh select 0) disableAi "AUTOTARGET";
		(_SurveillanceVeh select 0) setCombatMode "BLUE";
		(_SurveillanceVeh select 0) setBehaviour "CARELESS";		
		
		
	// Wait until UAV flies over players	
		waituntil {	
			sleep 10;
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

	sleep 1;		
	// Create tasking
		waituntil {	
			_foundunits = [];
			
			_Searchfound =[allplayers] call RALLYUP_fnc_Position_3dCenter;
			
			_EnemySurveillanceWP = _SurveillanceGroup addWaypoint [_Searchfound, 0];
			_EnemySurveillanceWP setWaypointBehaviour "CARELESS";
			_EnemySurveillanceWP setWaypointType "LOITER";
			_EnemySurveillanceWP setWaypointLoiterType "CIRCLE";
			_EnemySurveillanceWP setWaypointLoiterRadius 400;
			
			{
				_UAVLookat = lineintersects [ aimPos (_SurveillanceVeh select 0), eyePos _x];
				if ((!_UAVLookat) and (side _x == (RallyUpBluFor select 0))) then {
					_foundunits  pushBack _x;					
				};				
			} foreach AllUnits;

			if (count _foundunits > 0) then {
				{					
						_mortarVeh = vehicle _x;
						_mortarVeh setvehicleammo 1;
						_mortardLocation = [_Searchfound, (random 400), (random 360)] call BIS_fnc_relPos;		
						_mortarRounds = random 3;					
						_x commandArtilleryFire [_mortardLocation,getArtilleryAmmo [_mortarVeh] select 0,_mortarRounds];							
				} foreach units _mortarGroup;			
			};					

			sleep (random 60);
			
			deleteWaypoint [_SurveillanceGroup, 1];
	
			
			if ((count units _mortarGroup <= 0) or (!alive (_SurveillanceVeh select 0)))exitWith {_Task_Status = "Succeeded";true};
			if (!isNil "RALLYUP_SkipMissions") exitWith {RALLYUP_SkipMissions = nil;_Task_Status = "Canceled";true};			
				false				
		};
		
		if (alive (_SurveillanceVeh select 0)) then {
			_DeSpawnPosition = [_currentLocation, (random 400), (random 360)] call BIS_fnc_relPos;
			_EnemySurveillanceWP = _SurveillanceGroup addWaypoint [_DeSpawnPosition,1000];
			_EnemySurveillanceWP setWaypointBehaviour "CARELESS";
			_EnemySurveillanceWP setWaypointType "MOVE";
			_EnemySurveillanceWP setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
			"];
		}
		
		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
