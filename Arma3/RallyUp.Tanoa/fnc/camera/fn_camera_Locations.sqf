/*
	Author: CodeRedFox	
	Function: Camera script showing random locations	
	Usage: [] spawn RALLYUP_fnc_camera_Locations
	Returns: N/A
*/ diag_log format ["RallyUp : RALLYUP_fnc_camera_Locations | %1 | %2",time,serverTime];

	_random = RALLYUP_newLocations;
	_plus = 0;
	waitUntil 
	{
		_plus = _plus +1;
		_randomcam = _randomcam select _plus;
		
		//_randomcam = [] call RALLYUP_fnc_position_LocationsGlobal;
		_randomcamFixed = [_randomcam select 0,_randomcam select 1,15];
		_randomcamName = [_randomcam] call RALLYUP_fnc_position_LocationsName;
			
		
		_camera = "camera" camcreate _randomcamFixed;

		_camera cameraeffect ["Internal", "LEFT"];	
		
		_newtime = time + 8;
				
		
		["- - - - " +_randomcamName + " - - - -",-1,1.2] spawn BIS_fnc_dynamicText;
		
		_direction = random 360;		
		while{_newtime > time} do 
		{
			_direction = _direction + 0.0003;
			_camera setDir _direction;
			//_camera camCommit 1;		
			
		};	
	
	};
