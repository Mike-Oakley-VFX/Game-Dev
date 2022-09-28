
/*
	Author: CodeRedFox
	Uses: Creates support mission
	Note: 
	Usage: [position player] execVM "missions\Secondary_RewardHelicopter.sqf"
	Examples:

*/ diag_log format ["RallyUpDiag Starting : Secondary_RewardHelicopter.sqf | %1",_this select 0];
if (!isServer) exitwith {};

	// Variables
		_currentLocation = _this select 0;				
		_Task_Status = "Canceled";								
		_distance = 100;
		
	// Find Tasking Location
		_RewardLocationArray = [_currentLocation,["Land_HelipadSquare_F"]] call RALLYUP_fnc_position_LocationsObject;
		
		_RewardLocation = _RewardLocationArray select 0;
		_RewardDirection = _RewardLocationArray select 1;
		
	// Create Helicopter
	
		_JetArray = (RALLYUP_Groups_FriendlyHelicopters select floor random count RALLYUP_Groups_FriendlyHelicopters) select 1;
		_SelectHelicopter = _JetArray  select floor random count _JetArray ;
		_Reward_Jet = _SelectHelicopter createVehicle _RewardLocation;
		_Reward_Jet setdir _RewardDirection;
		
		
	// Diary
	
		_taskInformation = [_Reward_Jet] call RALLYUP_fnc_text_GetInfo;
		_taskTitle = "Reward - Helicopter";
		_taskPosition = getpos _Reward_Jet;
		_taskType = "Interact";
		_taskDescription = str formatText ["
			<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Interact_ca.paa' width='50px'/>
			<img image='%2' width='100px'/>
			<br/>
			<br/>O P S E C : -----------------
			<br/>
			<br/>	A %1 is avalible at %3
			<br/>			
			<br/>
			<br/>T I P S : -----------------
			<br/>	
		",_taskInformation select 1,_taskInformation select 2,_taskPosition];	
		_Task_Name = str formatText ["%1%2",_taskType,time];
		_Task_Mission = [(RallyUpBluFor select 0),_Task_Name,[_taskDescription,_taskTitle,_taskType],[_taskPosition select 0,_taskPosition select 1,2],0,1,true,_taskType] call BIS_fnc_taskCreate;
	
	
	// Task Event
		_countdown = time+RALLYUP_TimeOutSec;
		waituntil {
			sleep 5;
						
			_distance = ([AllPlayers] call RALLYUP_fnc_Position_3dCenter) distance (getpos _Reward_Jet);
			if (_distance < 150) exitWith {_Task_Status = "Succeeded";true};

			
			if ((!alive _Reward_Jet) or ( time > _countdown)) exitWith {
				_Task_Status = "Canceled";
				deletevehicle _Reward_Jet;
				true
			};
				false
		};

		
// Task End Events
	[_Task_Mission,_Task_Status] call BIS_fnc_taskSetState; // _Task_Status = "Succeeded","Failed","Canceled"
	
if(true) exitWith {};
