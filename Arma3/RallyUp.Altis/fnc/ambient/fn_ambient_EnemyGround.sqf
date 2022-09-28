
/*
	Author: CodeRedFox	
	Function: Ambient Flybys system	
	Usage: [] spawn RALLYUP_fnc_ambient_EnemyGround;
	Returns: N/A
*/ 
if (["RALLYUP_param_ambientGround"] call BIS_fnc_getParamValue == 0) exitwith {true};	
diag_log format ["RallyUpDiag Starting : RALLYUP_fnc_ambient_EnemyGround | %1 | %2",time,serverTime];

	waituntil {
		
		_Enemy = (RALLYUP_Groups_EnemyMech select floor random count RALLYUP_Groups_EnemyMech) select 1;	
	
	
		_CenterALL = [AllPlayers] call RALLYUP_fnc_Position_3dCenter;
		_Center = [_CenterALL,0,500] call RALLYUP_fnc_position_LocationsRoad;		
		_Start = [_Center,1000,2000] call RALLYUP_fnc_position_LocationsRoad;		
		_End = [_Center,1000,2000] call RALLYUP_fnc_position_LocationsRoad;
		
		_ambiantGroup = createGroup (RallyUpOpFor select 0);
		
		
		{
			_StartClose = [_Start,0,300] call RALLYUP_fnc_position_LocationsRoad;			
			_ambiant = [_StartClose, (random 360), _x, _ambiantGroup] call bis_fnc_spawnvehicle;	
			(_ambiant select 0) setCombatMode "GREEN";
			(_ambiant select 0) setBehaviour "SAFE";
			[_ambiant select 1] join _ambiantGroup;
			
		} foreach _Enemy;	
		
			_Waypoint_Center = _ambiantGroup addWaypoint [_center,1000];
				_Waypoint_Center setWaypointBehaviour "SAFE";
				_Waypoint_Center setWaypointType "MOVE";
			
			_Waypoint_End = _ambiantGroup addWaypoint [_end,100];
				_Waypoint_End setWaypointBehaviour "SAFE";
				_Waypoint_End setWaypointType "MOVE";
			_Waypoint_End setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
				[] spawn RALLYUP_fnc_ambient_EnemyGround;
			"];		
	
		waituntil {
			sleep 10;
			count units _ambiantGroup < 1;			
		};	
		
		sleep (random 120);
		false	
	};	

