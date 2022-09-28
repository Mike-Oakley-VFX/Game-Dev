

[] spawn BIS_fnc_arsenal;


class CfgRespawnInventory
{
	class FireteamLeader 
	{
		displayName = "Fireteam Leader (FTL)";
		icon = "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
		weapons[] = {"arifle_MX_GL_Hamr_pointer_F","hgun_P07_F","Binocular"};
		magazines[] = {
			"30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
			"1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","SmokeShell"
		};
		items[] = {"FirstAidKit"};
		linkedItems[] = {
			"V_PlateCarrierGL_rgr","H_HelmetSpecB","G_Tactical_Clear",
			"optic_Hamr","acc_flashlight",
			"ItemMap","ItemCompass","ItemWatch","ItemRadio",
		};
		uniformClass = "U_B_CombatUniform_mcam_vest";
		backpack = "B_AssaultPack_mcamo";
	};
	
	class AutomaticRifleman
	{
		displayName = "Automatic Rifleman (AR)";
		icon = "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
		weapons[] = {"LMG_Mk200_F","hgun_P07_F","Binocular"};
		magazines[] = {
			"200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box"
		};
		items[] = {"FirstAidKit"};
		linkedItems[] = {
			"V_PlateCarrier2_rgr","H_HelmetB_grass","G_Tactical_Clear",
			"HandGrenade","HandGrenade","HandGrenade",
			"optic_Hamr","bipod_01_F_snd",
			"ItemMap","ItemCompass","ItemWatch","ItemRadio",
		};
		uniformClass = "U_B_CombatUniform_mcam_tshirt";
		backpack = "B_AssaultPack_cbr";
	};
	
	class AntiTankRifleman
	{
		displayName = "Anti-Tank Rifleman";
		icon = "\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
		weapons[] = {"LMG_Mk200_F","hgun_P07_F","Binocular"};
	};
	
	class SquadMedic
	{
		displayName = "Squad Medic";
	};
	
	class AntiAircraftTeam
	{
		displayName = "Anti-Aircraft Team";
	};
	
	class DesignatedMarksman
	{
		displayName = "Designated Marksman";
	};

	class AntiAircraftTeam
	{
		displayName = "Anti-Aircraft Team";
	};
	
		class AntiAircraftTeam
	{
		displayName = "Anti-Aircraft Team";
	};
	
};
