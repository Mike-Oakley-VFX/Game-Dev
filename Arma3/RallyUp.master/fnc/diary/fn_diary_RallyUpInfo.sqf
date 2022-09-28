/*
	Author: CodeRedFox	
	Function: Creates mission diary info
	Usage: [] call RALLYUP_fnc_diary_RallyUpInfo;
	Example : 
	Returns: N/A
*/

player createDiarySubject ["RALLY UP!","RALLY UP!"];


player createDiaryRecord ["RALLY UP!", ["Data","
	<br/>
	<br/> Follow my progress at : https://github.com/coderedfox/RallyUp.Altis
"]];

player createDiaryRecord ["RALLY UP!", ["Squads / Groups","
	<br/>	How to squade up with your friends?
	<br/>
	<br/>	Once in game key press 'U' to enter the Group Managment screen.
	<br/>	- JOIN: Click on a squad and then click JOIN to join that group.
	<br/>	- INVITE: Click on a players name and then click INVITE to invite them to your squad.
	<br/>	- LEAVE: Click this button to Leave the group.
	<br/>	- DISBAND: Click this to remove the group and all players from it.
	<br/>
"]];


player createDiaryRecord ["RALLY UP!", ["Objectives","
	<br/>	SPAWN POINT :
	<br/>	
	<br/>	The Spawn Point has access to ARSENAL and Recruiting AI Teammates.
	<br/>
	<br/>
	<br/>	
	<br/>	MISSION TYPES :
	<br/>	
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Move_ca.paa' width='25px' /> : Rally up! --------
	<br/> All units MUST move to the point to continue.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Attack_ca.paa' width='25px' /> : ATTACK --------
	<br/> Attack the area around this position.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Defend_ca.paa' width='25px'/> : DEFEND --------
	<br/> Defend this area. Mission complete when all enemy are killed.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Destroy_ca.paa' width='25px' /> : DESTROY --------
	<br/> Destroy the targets around this position.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Interact_ca.paa' width='25px' /> : INTERACT --------
	<br/> Interact the targets around this position.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Search_ca.paa' width='25px' /> : SEARCH --------
	<br/> You will get a area to search. This search arae will decrease with every enemy that your kill.
	<br/>
	<br/>
	<img image='\A3\UI_F_MP_Mark\Data\Tasks\Types\Support_ca.paa' width='25px'/> : SUPPY DROP --------
	<br/> While you will be advised that a supply drop is happening you will have to wait for the drop to occur before you will receive a task.
	<br/>
	<br/>

"]];
	
	
player createDiaryRecord ["RALLY UP!", ["What is RALLY UP!?","
	<img image='data\loadScreen_RallyUp.paa' width='400px'/>
	<br/>
	<br/> Rally Up is a quick paced set of random missions with random enemies created by CodeRedFox. Currently made for small groups.
	<br/>
	<br/>
	<br/> CORE FEATURES :
	<br/>	- 8 Short missions for your squad 
	<br/>	- Completely random based game play.  
	<br/>	- Decentralized base 
	<br/>
	<br/> ADDITIONAL FEATURES : 
	<br/>	- Utilizing new BIS task features 
	<br/>	- New locations types
	<br/>	- Dynamic mission names
	<br/>	- Dynamic Squad names 
	<br/>	- Squad up with some random requested AI
	<br/>
	
	"]];

diag_log format ["RallyUp : RALLYUP_fnc_diary_RallyUpInfo"];	


