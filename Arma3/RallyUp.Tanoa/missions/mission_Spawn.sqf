/*
	Author: CodeRedFox
	Uses: THIS is the templete mission files
	Note: 
	Usage: [position] execVM "missions\mission_HVT.sqf";
	Examples: [position player] execVM "missions\mission_Spawn.sqf"; 
	Return: N/A

*/ 

if (!isServer) exitwith {};

	// Variables
		_providedPos = getMarkerPos RALLYUP_Respawn_MRK;
		_Task_Status = "Canceled";
		
	// Finding location		
		_missionLocation = [_providedPos, 0,RALLYUP_minDist, 1 , 0 , 0.1,0,[],[ [-100,-100],[-100,-100] ]] call BIS_fnc_findSafePos;
		if(_missionLocation select 0 == -100) exitWith {
			diag_log format ["RallyUp : mission_Spawn.sqf | FAILED %1 | %2",_missionLocation,_providedPos];
			true
		}; // exits if no
		diag_log format ["RallyUp : mission_Spawn.sqf | START %1 | %2",_missionLocation,_providedPos];

	// Island check
		[_providedPos, _missionLocation ] execVM "missions\mission_boatTransport.sqf"; 

	// Create Spawn Ammo
		_AmmoSpawnPosition = [_missionLocation, 0, 20, 2, 0, 0.1] call BIS_fnc_findSafePos;
		_AmmoCrateArray = RALLYUP_AmmoCrates select floor random count RALLYUP_AmmoCrates;		
		_Picked_AmmoCrate = _AmmoCrateArray createVehicle _AmmoSpawnPosition;	
		clearItemCargoGlobal _Picked_AmmoCrate;	
		["AmmoboxInit",[_Picked_AmmoCrate,true]] call BIS_fnc_arsenal;	

		
	// Create Spawn Veh
		_VehicleSpawnPosition = [_missionLocation, 0, 20, 2, 0, 0.1] call BIS_fnc_findSafePos;
		_VehicleArray = RALLYUP_Random_FriendlyVeh select floor random count RALLYUP_Random_FriendlyVeh;		
		_Picked_Vehicle = _VehicleArray createVehicle _VehicleSpawnPosition;

	
	// DIARY --------------------------------------------------------------------------------------------------------------------
		// Main TASK			
			_taskMissionName = "Welcome to Rally Up";
			_taskDate = format ["%4%5 / %2%3 / %1 ",date select 0,["", "0"] select (date select 1 < 10),date select 1,["", "0"] select (date select 2 < 10),date select 2];						
			_taskPosition = [ ( (getpos _Picked_AmmoCrate select 0) + (getpos _Picked_Vehicle select 0) ) / 2, ( (getpos _Picked_AmmoCrate select 1) + (getpos _Picked_Vehicle select 1) ) / 2,	0 ];		
			_taskNearLocation = ( text nearestLocation [_taskPosition, "NameLocal"]+ ", " + worldName);
			_taskType = "rearm";

			_AmmoName = [_Picked_AmmoCrate] call RALLYUP_fnc_text_GetInfo;
			_VehName = [_Picked_Vehicle] call RALLYUP_fnc_text_GetInfo;

			_taskText = str formatText ["
				<img image='data\loadScreen_RallyUp.paa' width='350'/>
				<br/>	Welcome to Rally Up.  
				<br/>	Gameplay based on fast paced Move, Secure, and Resuppy elements.
				<br/>
				<br/>	Your first mission is to gear up at this location. Rally Up will at time use the ARMA 3 Arsenal weapons load out.
				<br/>	
				<br/>	Arsenal is, essentially, a character, equipment and weapon viewer. This tool offers an overview of the available content, and enables customized loadouts
				<br/>
				<br/>	OPSEC (Operational Security) 
				<br/>
				<br/>	MISSION: %1
				<br/>	DATE: %2
				<br/>	LOCATION : %3
				<br/>	 
				<br/>	MISSION
				<br/>	- Arsenal ammo box : %4
				<br/>	- Randomaly picked vehicle : %5
				",
				_taskMissionName,
				_taskDate,
				_taskNearLocation,
				_AmmoName select 1,
				_VehName select 1
			];

			_taskID = str formatText ["%1%2",_taskType,serverTime];	
			_Task_Mission = [RALLYUP_Friend_Side,_taskID,[_taskText,_taskMissionName,_taskType],_taskPosition,"ASSIGNED",1,true,"",true] call BIS_fnc_taskCreate;
			[_Task_Mission,_taskType] call BIS_fnc_taskSetType;	


		// Title Text
		//_txt5Layer = "txt5" call BIS_fnc_rscLayer;
		//_txt6Layer = "txt6" call BIS_fnc_rscLayer;

		//_texta = "<t font 'EtelkaMonoSpaceProBold' align = 'center' size '1.4' color '#ffb400'> " 'RALLY UP' "</t>";

		//[_texta, ]


	
	// Start MISSION ----------------------------------------------------------------------------
		waitUntil {
			sleep 10;

			// Mission COMPLETE
			 _distCheck = [_taskPosition, RALLYUP_Friend_Side,allUnits,1 ] call RALLYUP_fnc_position_distCheck;
			if (_distCheck < 50 ) exitWith {_Task_Status = "SUCCEEDED" ;true };
			
				false // Loop this until true
		};

		[_taskID,_Task_Status] call BIS_fnc_taskSetState;
	
diag_log format ["RallyUp : mission_Spawn.sqf | END %1",serverTime];	
if(true) exitWith {sleep 10;};
