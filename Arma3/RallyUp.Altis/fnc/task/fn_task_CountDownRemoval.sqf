/*
	Author: CodeRedFox	
	Function: Instructs the leader to eject his group with a parachute ever 1 second.
	Usage: [object,countdown time] spawn RALLYUP_fnc_task_CountDownRemoval
	Returns: N/A
*/ 
	

	
	addMissionEventHandler ["Draw3D", {
		_SelectedObject = _this select 0;
		_TheTimer = _this select 1;	
		_countdown = time + _TheTimer;
		//_Showcountdown = str formatText ["%1",ceil (_countdown - time)];
		_alpha = 10 / (player distance _SelectedObject);
		drawIcon3D ["",[1,1,1,1],getpos _SelectedObject,0,0,0,"111",0.5,0.5,"TahomaB"];
	}];	
			
			
	/*
	waituntil {		
		if (time > _countdown) exitWith {true};	
	};
	
	if (Alive _SelectedObject) then {deletevehicle _SelectedObject};
	
	*/
if(true) exitWith {};
	
	
	
	


