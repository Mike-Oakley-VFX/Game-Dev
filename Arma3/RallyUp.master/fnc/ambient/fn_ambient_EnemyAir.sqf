
/*
	Author: CodeRedFox	
	Function: Ambient Flybys system	
	Usage: [] spawn RALLYUP_fnc_ambient_EnemyAir;
	Returns: N/A
*/ 
if (["RALLYUP_param_ambientAir"] call BIS_fnc_getParamValue == 0) exitwith {true};

diag_log format ["RallyUpDiag Starting : RALLYUP_fnc_ambient_EnemyAir | %1 | %2",time,serverTime];


	private ["_ambiant"];
	_flyheight = 500;
	
	//_types = ["Flyby","BombRun"];
	_types = ["Flyby"];
	_vehicleArray = RALLYUP_Groups_EnemyJets;
	
	
	waituntil {
 
		_typePicked = _types select floor random count _types;
		
		_centerPOS = getpos RallyPointBackpack;
			_center = [_centerPOS select 0,_centerPOS select 1,_flyheight];	
		_startPOS = [_center, 5000, (random 360)] call BIS_fnc_relPos;	
			_start = [_startPOS select 0,_startPOS select 1,_flyheight];	
		_endPOS = [_center, 5000, (random 360)] call BIS_fnc_relPos;	
			_end = [_endPOS select 0,_endPOS select 1,_flyheight];
			
		_pickedvehicleArray = (_vehicleArray select floor random count _vehicleArray) select 1;	
		_pickedvehicleType = _pickedvehicleArray select floor random count _pickedvehicleArray;
		
		_ambiantGroup = createGroup (RallyUpOpFor select 0); 
		_ambiant = [_start, (random 360), _pickedvehicleType, _ambiantGroup] call bis_fnc_spawnvehicle;
		_ambiantVeh = _ambiant select 0;
		_ambiantPilot = (_ambiant select 1) select 0;
		
		_ambiantVeh flyinheight _flyheight;
		_ambiantVeh disableAi "TARGET";	
		_ambiantVeh disableAi "AUTOTARGET";
		_ambiantVeh setCombatMode "BLUE";
		_ambiantVeh setBehaviour "CARELESS";
		//_ambiantVeh setCaptive true;

			
			_Waypoint_Center = _ambiantGroup addWaypoint [_center,1000];
				_Waypoint_Center setWaypointBehaviour "CARELESS";
				_Waypoint_Center setWaypointType "MOVE";
			
			_Waypoint_End = _ambiantGroup addWaypoint [_end,100];
				_Waypoint_End setWaypointBehaviour "CARELESS";
				_Waypoint_End setWaypointType "MOVE";
				
				
			_Waypoint_End setWaypointStatements ["true", "
				{deleteVehicle vehicle _x} forEach thislist;
				{deleteVehicle _x} forEach thislist;
				deleteGroup (group this);
				true
			"];	
			
		waituntil {
			sleep 15;
			_foundunits = [];
			{								
				_UAVLookat = lineintersects [ aimPos _ambiantVeh, eyePos _x];				

				if ((!_UAVLookat) && _x distance _ambiantVeh < 1200) then {						
					_target = [getpos _ambiantVeh select 0, getpos _ambiantVeh select 1,(getpos _ambiantVeh select 2)-10];
					_bomb = "Bo_GBU12_LGB" createVehicle _target;						
					_dir = [_ambiantVeh, _x] call BIS_fnc_dirTo;					
					_bomb setDir _dir;
					
				};
				sleep 1;		
			} foreach allplayers;			

			isNull _ambiantVeh;

		};
		
		sleep (random 300);
			false
	};
