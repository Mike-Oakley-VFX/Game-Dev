/*
	Author: CodeRedFox	
	Function: Creates and manages Enemy reinforcements
	Usage: [position,TYPE,actions,multiplyer] spawn RALLYUP_fnc_create_Enemy

	Function: [position,[array],word,group,amount] call RALLYUP_fnc_create_Enemy;
	Example : [position player,["Unit"],"PATROL",createGroup [RALLYUP_Enemy_Side,true],1] call "fnc\create\fn_create_Enemy.sqf";
	Returns: N/A
*/
	
diag_log format ["RallyUp : RALLYUP_fnc_create_EnemyForces | %1 ",serverTime];
//hint format ["RallyUp : RALLYUP_fnc_create_EnemyForces | %1",serverTime];

	_position = _this select 0;	
	_arrayType = _this select 1;
	_actions = _this select 2;
	_enemyGroup = _this select 3;
	_multiplyer = _this select 4;	


	// Different kinda of actions for AI
	_foundLocation =nil;
	_direction = nil;
	_classRandomPick = nil;
	_typeArray=nil;
	_EnemyVeh=nil;
	_posfound = _position;
	_enemyGroupNew=nil;	


	for "_i" from 1 to _multiplyer do {
		_typeArray = _arrayType select floor random count _arrayType;
		_direction = random 360;
		_enemyGroup setBehaviour "SAFE";
		_enemyGroup setformation (RALLYUP_formationMode select floor random count RALLYUP_formationMode);

		// Sets up defaults
		_spawnMin = RALLYUP_minDist;
		_spawnMax = RALLYUP_maxDist;
		_spawnSpace = 1;
		_isWater = 0;
		_dirFlipped=0;

		// UNIT
		if (_typeArray=="Unit") then { 
			_classRandomPick = RALLYUP_Random_EnemyInf select floor random count RALLYUP_Random_EnemyInf;
			_spawnMin = 1;
			_spawnMax = RALLYUP_minDist;
			_isWater = 0;
		};

		// STATICS
		if (_typeArray=="Static") then { 
			_classRandomPick = RALLYUP_Random_EnemyStatics select floor random count RALLYUP_Random_EnemyStatics;
			_spawnMin = 1;
			_spawnMax = RALLYUP_minDist;
			_spawnSpace = 1;
			_isWater = 0;
		};
		// Vehicle FART
		if (( _typeArray=="grdTransport") or ( _typeArray=="FART" )) then { 
			_classRandomPick = RALLYUP_Random_EnemyMechTrans select floor random count RALLYUP_Random_EnemyMechTrans;			
			_spawnSpace = 2;
		};

		// Vehicle FART
		if ( _typeArray=="Mech") then { 
			_classRandomPick = RALLYUP_Random_EnemyMech select floor random count RALLYUP_Random_EnemyMech;
			_spawnSpace = 2;
		};

		// Artillery Veh
		if ( _typeArray=="mechArtillery") then { 
			_classRandomPick = RALLYUP_Random_EnemyArtillery select floor random count RALLYUP_Random_EnemyArtillery;
			_spawnSpace = 2;
		};		

		// Boat
		if (_typeArray=="Water") then { 
			_classRandomPick = RALLYUP_Random_EnemyBoats select floor random count RALLYUP_Random_EnemyBoats;
			_spawnMax = RALLYUP_maxDist * 2;
			_spawnSpace = 5;
			_isWater = 2;
		};

		// Air Transport 
		if ( _typeArray=="airTransport") then {
			_classRandomPick = RALLYUP_Random_EnemyHeliTrans select floor random count RALLYUP_Random_EnemyHeliTrans;
			_spawnMin = RALLYUP_maxDist;
			_spawnMax = RALLYUP_maxDist * 2;
			_isWater = 1;
			_dirFlipped = 180;
		};

		// Attack Helo
		if (_typeArray=="Air") then { 
			_classRandomPick = RALLYUP_Random_EnemyHeli select floor random count RALLYUP_Random_EnemyHeli;
			_spawnMin = RALLYUP_maxDist;
			_spawnMax = RALLYUP_maxDist * 2;
			_isWater = 1;
		};

		// UAV
		if (_typeArray=="UAV") then { 
			_classRandomPick = RALLYUP_Random_EnemyUAV select floor random count RALLYUP_Random_EnemyUAV;
			_isWater = 1;
		};

		if ( _typeArray=="Paratroopers" ) then {
			_classRandomPick = RALLYUP_Random_EnemyPara select floor random count RALLYUP_Random_EnemyPara;
			_spawnMin = RALLYUP_maxDist;
			_spawnMax = RALLYUP_maxDist * 2;
			_isWater = 1;
			_dirFlipped = 180;
		};

		// Create Enemy -----------------------------------------------------------------------------------	
			waitUntil {
				_foundLocation = [_posfound, _spawnMin, _spawnMax, _spawnSpace , _isWater, 0.1 ] call BIS_fnc_findSafePos;
				_distCheck = [_foundLocation, RALLYUP_Friend_Side,allUnits,1 ] call RALLYUP_fnc_position_distCheck;
				if (_distCheck > RALLYUP_minDist ) exitWith {true};				
					false
			};

			_direction = (_posfound getDir _foundLocation) - _dirFlipped;

			if ( ( _typeArray=="FART" ) or (_typeArray=="Paratroopers") ) then {
				 _enemyGroup = createGroup [RALLYUP_Enemy_Side,true];
				[_foundLocation, _direction,_classRandomPick, _enemyGroup] call bis_fnc_spawnvehicle;
			} else {
				[_foundLocation, _direction,_classRandomPick, _enemyGroup] call bis_fnc_spawnvehicle;
			};

			_EnemyVeh = assignedVehicle (leader _enemyGroup);	

		// Reenforcements -----------------------------------------------------------------------------------
			_dropLocation=nil;
			_height = 500;		
		
			if ( ( _typeArray=="Paratroopers") or  ( _typeArray=="FART") ) then {
				_EnemyFillCargoGroup = createGroup [RALLYUP_Enemy_Side,true];

							
				if ( _typeArray=="Paratroopers") then {	
					
					{ 
						(vehicle _x) flyinheight _height;
						_veh = (assignedVehicle _x);
						_veh setPos [getpos _veh select 0,getpos _veh select 1,_height];				
					} foreach units _enemyGroup;


					_positionZ = [ _position select 0 , _position select 1 , _height ];
					_foundLocation = [ _foundLocation select 0 , _foundLocation select 1 , _height ];				
					_dropLocation = [  _positionZ, RALLYUP_minDist, random 360] call BIS_fnc_relPos;
					
					// Create Drop waypoints
						_VehGroupWP01 = _enemyGroup addWaypoint [ _positionZ, RALLYUP_minDist];
						_VehGroupWP01 setWaypointType "MOVE";
						_VehGroupWP01 setWaypointCompletionRadius 300;
						_VehGroupWP01 setWaypointBehaviour "CARELESS";	
						_VehGroupWP01 setWaypointSpeed "FULL";		
						_VehGroupWP01 setWaypointStatements ["true","
							{
								{
									[_x] spawn RALLYUP_fnc_task_Paratroopers;
								} forEach (assignedcargo vehicle leader _x);
							} forEach thisList;
						"];	

					// Create Exit Waypoint
					
						_VehGroupWP02 = _enemyGroup addWaypoint [ _foundLocation, RALLYUP_minDist];
						_VehGroupWP01 setWaypointType "MOVE";
						_VehGroupWP02 setWaypointCompletionRadius 300;
						_VehGroupWP02 setWaypointBehaviour "CARELESS";
						_VehGroupWP02 setWaypointSpeed "FULL";
						_VehGroupWP02 setWaypointStatements ["true","
							{deleteVehicle vehicle _x} forEach thislist;
							{deleteVehicle _x} forEach thislist;deleteGroup (group this);
						"];
											
				};

				if ( _typeArray=="FART") then {
						
					// Create Drop waypoints
						_VehGroupWP01 = _enemyGroup addWaypoint [_position, RALLYUP_minDist];
						_VehGroupWP01 setWaypointType "TR UNLOAD";
						_VehGroupWP01 setWaypointCompletionRadius 100;					
						_VehGroupWP01 setWaypointStatements ["true", "{	unassignVehicle _x;	[_x] ordergetin false;} forEach (assignedcargo vehicle _x);	"];	

					// Create Exit Waypoint
						_VehGroupWP02 = _enemyGroup addWaypoint [ _foundLocation, RALLYUP_minDist];
						_VehGroupWP02 setWaypointCompletionRadius 100;
						_VehGroupWP02 setWaypointType "MOVE";
						_VehGroupWP02 setWaypointStatements ["true", "{deleteVehicle vehicle _x} forEach thislist;{deleteVehicle _x} forEach thislist;deleteGroup (group this);	"];
				};
				
				// Create Troops
					[_EnemyVeh,_EnemyFillCargoGroup] spawn RALLYUP_fnc_create_fillcargo;
					[_EnemyFillCargoGroup, _position, RALLYUP_minDist] call BIS_fnc_taskPatrol;
			};
	};

	
	// Set up Actions for all units
	if ( ( _typeArray!="Paratroopers") and ( _typeArray!="Paratroopers") ) then {
		if (_actions == "ATTACK") then { [_enemyGroup, _position] call BIS_fnc_taskAttack; };
		if (_actions == "PATROL") then { [_enemyGroup, _position, RALLYUP_minDist] call bis_fnc_taskPatrol;};
		if (_actions == "DEFEND") then { [_enemyGroup, _position] call bis_fnc_taskDefend;};
	};
		
	// Strip ai og NVG for fun
	if (RALLYUP_AINVG ==1) then {
		{
		_x unassignItem (hmd _x);
		_x removeItem (hmd _x);
		_x addPrimaryWeaponItem "acc_flashlight";
		} foreach units _enemyGroup ;
		_enemyGroup  enablegunlights "forceOn";
	};

	_RETURN = [ count units _enemyGroup,  { group _x == _enemyGroup} count vehicles ] ;

// END ------------------------------
diag_log format ["RallyUp : RALLYUP_fnc_create_Enemy | RETURN Units %1 : Vehicles %2",_RETURN select 0,_RETURN select 1 ];
//hint format ["RallyUp : RALLYUP_fnc_create_Enemy | RETURN Units %1 : Vehicles %2",_RETURN select 0,_RETURN select 1 ];
_RETURN