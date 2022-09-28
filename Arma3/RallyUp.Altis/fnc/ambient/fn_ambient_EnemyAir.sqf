
/*
	Author: CodeRedFox	
	Function: Ambient Flybys system	
	Usage: [] spawn RALLYUP_fnc_ambient_EnemyAir;
	Returns: N/A
*/ 
if (RALLYUP_DEBUG == true) then {hint "Loaded FN : RALLYUP_fnc_ambient_EnemyAir";};

if (["RALLYUP_param_ambientAir"] call BIS_fnc_getParamValue == 0) exitwith {true};

diag_log format ["RallyUpDiag Starting : RALLYUP_fnc_ambient_EnemyAir | %1 | %2",time,serverTime];

	private ["_ambiant"];
	if (!isServer) exitwith {};
	_flyheight = random [400, 700, 1500];
	
	_vehicleArray = RALLYUP_Groups_EnemyJets + RALLYUP_Groups_EnemyHelicopters;
	
	
	_centerPOS = getpos RallyPointBackpack;
	_startPOS = [_centerPOS, 5000, (random 360)] call BIS_fnc_relPos;	
	_endPOS = [_centerPOS, 5000, (random 360)] call BIS_fnc_relPos;	

			
	_pickedvehicleArray = (_vehicleArray select floor random count _vehicleArray) select 1 ;
	_pickedvehicleType = _pickedvehicleArray select floor random count _pickedvehicleArray;
	
	_ambiantGroup = createGroup (RallyUpOpFor select 0); 
	_ambiant = [_startPOS, (random 360), _pickedvehicleType, _ambiantGroup] call bis_fnc_spawnvehicle;
	_ambiantVeh = _ambiant select 0;
	_ambiantPilot = (_ambiant select 1) select 0;
	
	_ambiantVeh flyinheight _flyheight;
	_ambiantVeh disableAi "TARGET";	
	_ambiantVeh disableAi "AUTOTARGET";
	_ambiantVeh setCombatMode "BLUE";
	_ambiantVeh setBehaviour "CARELESS";
	//_ambiantVeh setCaptive true;
		
		_Waypoint_Center = _ambiantGroup addWaypoint [_centerPOS,1000];
			_Waypoint_Center setWaypointBehaviour "CARELESS";
			_Waypoint_Center setWaypointType "MOVE";
		
		_Waypoint_End = _ambiantGroup addWaypoint [_endPOS,1000];
			_Waypoint_End setWaypointCompletionRadius 500;
			_Waypoint_End setWaypointBehaviour "CARELESS";
			_Waypoint_End setWaypointType "MOVE";
			//_Waypoint_End setWaypointScript " [] spawn RALLYUP_fnc_ambient_EnemyAir;deleteGroup (group _ambiantVeh);";
			_Waypoint_End setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
				[] spawn RALLYUP_fnc_ambient_EnemyAir;
			"];
									
			
	sleep (random 300);
		
	if (RALLYUP_DEBUG == true) then {hint "End FN : RALLYUP_fnc_ambient_EnemyAir";};
	