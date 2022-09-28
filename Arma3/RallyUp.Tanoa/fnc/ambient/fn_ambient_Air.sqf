
/*
	Author: CodeRedFox	
	Function: Ambient Flybys system	
	Usage: [] spawn RALLYUP_fnc_ambient_Air;
	Returns: N/A
*/ 
if (!isServer) exitwith {};

	_vehicleType = RALLYUP_Random_CivAir+RALLYUP_Random_EnemyJet+RALLYUP_Random_EnemyHeliTrans+RALLYUP_Random_EnemyUAV;
	
	_flyheight = random [400, 700, 1500];
		
	_centerPOS = [allplayers] call RALLYUP_fnc_Position_3dCenter;
	_startPOS = [_centerPOS, 3000, (random 360)] call BIS_fnc_relPos;	
	_endPOS = [_centerPOS, 3000, (random 360)] call BIS_fnc_relPos;	

	_pickedvehicleType = _vehicleType  select floor random count _vehicleType;
	
	_ambiantGroup = createGroup RALLYUP_CIV_Side; 
	_ambiant = [ _startPOS, (random 360), _pickedvehicleType, _ambiantGroup] call bis_fnc_spawnvehicle;
	_ambiantVeh = _ambiant select 0;
	_ambiantPilot = (_ambiant select 1) select 0;
	
	_ambiantVeh flyinheight _flyheight;
	_ambiantVeh disableAi "TARGET";	
	_ambiantVeh disableAi "AUTOTARGET";
	_ambiantVeh setCombatMode "BLUE";
	_ambiantVeh setBehaviour "CARELESS";
		
		_Waypoint_Center = _ambiantGroup addWaypoint [_centerPOS,1000];
			_Waypoint_Center setWaypointBehaviour "CARELESS";
			_Waypoint_Center setWaypointType "MOVE";
		
		_Waypoint_End = _ambiantGroup addWaypoint [_endPOS,1000];
			_Waypoint_End setWaypointCompletionRadius 500;
			_Waypoint_End setWaypointBehaviour "CARELESS";
			_Waypoint_End setWaypointType "MOVE";
			_Waypoint_End setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
			"];
	
	diag_log format ["RallyUp : RALLYUP_fnc_ambient_Air | %1 | %2 | %3",serverTime, _ambiantVeh];

	// loop when dead or removed	
	waitUntil {	
		sleep 300;
		if (!alive _ambiantVeh) exitWith { [] spawn RALLYUP_fnc_ambient_Air; true };
			false
	};
	
	