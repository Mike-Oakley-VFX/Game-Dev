
/*
	Author: CodeRedFox
	Uses: Random Camera
	Note: 
	Usage: 
		[] spawn RALLYUP_fnc_camera_RandomCamera;

		
*/ diag_log format ["RallyUp : RALLYUP_fnc_camera_RandomCamera | %1 | %2",time,serverTime];

	//_position = [] call RALLYUP_fnc_position_LocationsGlobal;
	_position = [14200,13000,5];
	
//[_position,200,300,["Group"],3] spawn RALLYUP_fnc_create_Enemy;
//[_position,200,300,["Static"],2] spawn RALLYUP_fnc_create_Enemy;
//[_position,200,300,["Vehicles"],3] spawn RALLYUP_fnc_create_Enemy;
//[_position,8] spawn RALLYUP_fnc_create_reinforcements;



	waitUntil {{side _x == (RallyUpOpFor select 0)} count allUnits > 1};
	
	player allowdammage false;
	
	_cameraeffectA = ["Internal"];	
	_cameraeffectB = [
		"TOP",
		"LEFT",
		"RIGHT",
		"FRONT",
		"BACK",
		"LEFT FRONT",
		"RIGHT FRONT",
		"LEFT BACK",
		"RIGHT BACK",
		"LEFT TOP",
		"RIGHT TOP",
		"FRONT TOP",
		"BACK TOP"
	];
	
	
	
	waitUntil 
	{
		sleep 1;
		_AllUnits = [];
		
		{
			if (side _x == (RallyUpOpFor select 0)) then
			{
				_AllUnits set [count _AllUnits, _x];
			};	
		} forEach AllUnits; 		
		
		_CameraTarget = _AllUnits select floor random count _AllUnits;		
		
		_CameraMan = [getpos _CameraTarget, (random 10)+20, random 360] call BIS_fnc_relPos;
		
		_CameraManSet = [_CameraMan select 0,_CameraMan select 1,(_CameraMan select 2)+(random 6)];		
		
		_cameraeffectASelect = _cameraeffectA select floor random count _cameraeffectA;
		_cameraeffectBSelect = _cameraeffectB select floor random count _cameraeffectB;	
		
				_newtime = time + 6;
		
		_israndom = random 100;
		_randomPOSX = (random 50)-25;
		_randomPOSY = (random 50)-25;
		_randomPOSZ = (random 10)+2;
		
		
		if (!isNil "_camera") then {camDestroy _camera;};
		_camera = "camera" camcreate _CameraManSet;
		_camera camCommand "inertia on";
		_camera cameraeffect [_cameraeffectASelect, _cameraeffectBSelect];		
		
		_vector = velocity _CameraTarget;
		_camera setVelocity [(_vector select 0)/4,( _vector select 1)/4, (_vector select 2)/6];
		
		
		//_CameraTargetran = [getpos _CameraTarget, (random 10)+5, random 360] call BIS_fnc_relPos;
		
		//_direction = [_camera, _CameraTargetran] call BIS_fnc_dirTo;
		_camera camSetTarget _CameraTarget;
		_camera camCommit 100;
		while{_newtime > time}do
		{
		
			//_camera camSetTarget _CameraTarget;
			//_camera camCommit 100;
			//sleep 1;
			//_direction = _direction + 0.00003;
			//_camera setDir _direction;
		};
		
		
		
		
		
		false
		
	};
