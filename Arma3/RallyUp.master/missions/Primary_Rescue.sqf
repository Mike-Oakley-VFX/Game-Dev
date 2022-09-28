/*
	Author: CodeRedFox
	Uses: Creates a Rescue Task. Rescue the unit.
	Note: 
	Usage: [position] execVM "missions\Primary_Rescue.sqf"
	Examples:[position player] execVM "missions\Primary_Rescue.sqf";

*/ diag_log format ["RallyUpDiag Starting : Mission_Rescue.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_TaskingPosition = _this select 0;
		_Task_Status = "Canceled";
				
		_minDistance = RALLYUP_minDistance+((count allplayers)*50);
		_maxDistance = RALLYUP_maxDistance+((count allplayers)*50);	
		
		_waveamount = RALLYUP_EnemyMultiplier + (ceil (random (count allplayers)));
		
	// Find Tasking Location		
		
		_Hostage_Location = [position player,_minDistance,_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
			if (_Hostage_Location distance2d _TaskingPosition > _maxDistance) exitWith {diag_log ["RallyUpDiag : Mission outside of _maxDistance"];true};	// Will cancel if the task to to far away	
		_Hostage_LocationName = [_Hostage_Location] call RALLYUP_fnc_position_LocationsName;		
		
		_Hostage_LocationSpots = [_Hostage_Location] call RALLYUP_fnc_position_LocationsSpots;		
		
		_Rescue_Location = [_Hostage_Location,_minDistance,_maxDistance] call RALLYUP_fnc_position_LocationsBuilding;
					
		_survivorGroup = createGroup (RallyUpBluFor select 0);
		
	//create Survivor	
		_RescuePosition = _Hostage_LocationSpots select 0;
		
		_survivorArray = RALLYUP_POI select floor random count RALLYUP_POI;
		
		_survivor = _survivorGroup createUnit [_survivorArray, [_RescuePosition select 0,_RescuePosition select 1,(_RescuePosition select 2)+0.5], [], 0, "NONE"];
		
		_survivor setCaptive true;
		
		_addactionRescue = _survivor addAction ["<t color='#ff8000' t size='2'>Rescue Hostage</t>",{
			(_this select 0) setCaptive false;
			[_this select 0] joinSilent (group (_this select 1));
			(_this select 0) removeAction (_this select 2);			
			(_this select 0) switchmove 'Acts_AidlPsitMstpSsurWnonDnon_out';
			(_this select 0) switchmove ''	
		}];
			
		_survivor switchmove "Acts_AidlPsitMstpSsurWnonDnon01";	
		
	// Create Guard	
	
		_Enemy = [(_Hostage_LocationSpots select 0),10,50,["Unit"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
		[(_Hostage_LocationSpots select 0),_Enemy] call BIS_fnc_taskDefend;
		
		[(_Hostage_LocationSpots select 0),10,50,["Static"],_waveamount,"PATROL"] spawn RALLYUP_fnc_create_Enemy;
	
		_EnemyInfGroup = createGroup (RallyUpOpFor select 0);
		
		_FindBuildings = nearestObjects [getpos _survivor, ["Building"], 150];
		{
			[_x,RALLYUP_Groups_EnemyInf,25] call RALLYUP_fnc_create_PopulateBuilding;
		} foreach _FindBuildings;
	
		[(_Hostage_LocationSpots select 0),1] spawn RALLYUP_fnc_create_reinforcements;
	
	// Diary
		_taskInformation_Name = ([_survivor] call RALLYUP_fnc_text_GetInfo) select 0;
		_taskInformation_displayName = ([_survivor] call RALLYUP_fnc_text_GetInfo) select 1;
		_taskInformation_displaypicture = ([_survivor] call RALLYUP_fnc_text_GetInfo) select 2;
		
		_taskTitle = ["Mission"] call RALLYUP_fnc_text_RandomName;
		_taskPosition = [_Hostage_Location, (random 300)+100, 0] call BIS_fnc_relPos;
		_taskType = "Search";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Search_ca.paa' width='50px' />
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	A %1 by the name of %2 has been taken hostage. Look for him in the area near %4.
			<br/>
			<br/>
			<br/>O B J E C T I V E : -----------------
			<br/>
			<br/>	- Rescue %2 and bring them to the rescue area.
			<br/>
			<br/>
			<br/>T I P S : -----------------
			<br/>
			",
			_taskInformation_displayName,
			_taskInformation_Name,
			_taskInformation_displaypicture,
			_Hostage_LocationName
		];
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,5],1,1,true,_taskType] call BIS_fnc_taskCreate;
		
		// Wait until Hostage is free
		
		
		waituntil{
			sleep 1;
			

			if (!alive _survivor) exitWith {_Task_Status = "Failed";true};
			if ((alive _survivor) and (!captive _survivor)) exitWith {true;};
				false;
		};		
		
		_taskType = "Move";					
		[_Task_Name,[_taskDescription,_taskTitle,_taskType]] call BIS_fnc_taskSetDescription;
		[_Task_Mission,_Rescue_Location] call BIS_fnc_taskSetDestination;		
		
		// Wait until Hostage is in the rescue area
		waituntil{
			sleep 5;			
			
			if (!alive _survivor) exitWith {_Task_Status = "Failed";true};			
			if ((alive _survivor) && (_survivor distance _Rescue_Location < 25)) exitWith {			
				_Task_Status = "Succeeded";
				true;
			};
			false;
		};

		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	deleteVehicle _survivor;
	
if(true) exitWith {};
