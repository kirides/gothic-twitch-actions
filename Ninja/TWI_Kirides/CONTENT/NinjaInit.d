
func void TWI_SumGol_Stone() {
	if (!Hlp_IsValidNpc(hero)) { return; };

	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		repeat(i, amount); var int i;
			TWI_Kirides_Spawn(TwitchIntegration_User, StoneGolem);
		end;
		return;
	};

	TWI_Kirides_Spawn(TwitchIntegration_User, StoneGolem);
};

func void TWI_SumGol_Fire() {
	if (!Hlp_IsValidNpc(hero)) { return; };
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		repeat(i, amount); var int i;
			TWI_Kirides_Spawn(TwitchIntegration_User, FireGolem);
		end;
		return;
	};

	TWI_Kirides_Spawn(TwitchIntegration_User, FireGolem);
};

func void TWI_Raid_Bandits() {
	if (!Hlp_IsValidNpc(hero)) { return; };
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	var int i;

	if Kapitel > 2 {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_3_Bandit_L);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_2_Bandit_L);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_3_Bandit_L);
	} else if (Kapitel > 1) {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_2_Bandit_L);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_1_Bandit_L);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_2_Bandit_L);
	} else {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_1_Bandit_L);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_1_Bandit_L);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_BDT_1_Bandit_L);
	};
};

func void TWI_Raid_Orcs() {
	if (!Hlp_IsValidNpc(hero)) { return; };
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	var int i;

	if Kapitel > 3 {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_L);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_L);
	} else if (Kapitel > 2) {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_M);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_M);
	} else if (Kapitel > 1) {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
	} else {
		if (amount > 0) {
			repeat(i, amount);
				TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
			end;
			return;
		};
		TWI_Kirides_Spawn(TwitchIntegration_User, TWI_Orc_S);
	};
};

const int _TWI_Shrink_IsShrunken = 0;
func void _FF_TWI_Shrink_Undo() {
	_TWI_Shrink_IsShrunken = 0;
	Mdl_SetModelScale(hero,	1.0, 1.0, 1.0);
};
func void _FF_TWI_Shrink_ReApply() {
	if (_TWI_Shrink_IsShrunken) {
		Mdl_SetModelScale(hero,	0.3, 0.3, 0.3);
	} else {
		FF_RemoveAll(_FF_TWI_Shrink_ReApply);
	};
};
func void TWI_Shrink() {
	_TWI_Shrink_IsShrunken = 1;
	Mdl_SetModelScale(hero,	0.3, 0.3, 0.3);

	var int duration; duration = STR_ToInt(TwitchIntegration_Arguments);
	if (duration <= 0) {
		duration = 30;
	};

	FF_ApplyOnceExtGT(_FF_TWI_Shrink_Undo, duration * 1000, 1);
	FF_ApplyOnceExtGT(_FF_TWI_Shrink_ReApply, 1000, -1);
};



func void _TWI_Kirides_Time(var int hour) {
	MEM_Info(ConcatStrings("_TWI_Kirides_Time: ", IntToString(hour)));
	Wld_SetTime(hour, 0);
};

func void TWI_Time() {
	var int hour; hour = STR_ToInt(TwitchIntegration_Arguments);
	if (hour >= 0 && hour < 24) {
		_TWI_Kirides_Time(hour);
	};
};

func int _Validate_SPL_Id(var string symbolName, var int number) {
	var int sym; sym = MEM_GetSymbol(symbolName);
    if (sym) {
        var zCPar_Symbol parSym; parSym = _^(sym);
        if (parSym == number) {
			return 1;
		};
	};
	return 0;
};

/// @param category [ITEM_KAT_FF,  ITEM_KAT_NF]
func int _TWI_Weakest_By_Category(var C_NPC npc, var int category) {
	const int weakestWeaponInst = 0; weakestWeaponInst = 0;
	const int weakestWeaponDmg = -1; weakestWeaponDmg = 9999999;
	const int i = 0; i = 0;

	while(TRUE);
        if (NPC_GetInvItemBySlot(npc, INV_WEAPON, i) == 0) { break; };
        if (!Hlp_IsValidItem(item)) { break; };
		if ((item.mainflag & category) == 0) { i+=1; continue; };

        if (item.damageTotal < weakestWeaponDmg) {
			if (_TWI_CanEquip(npc, item)) {
				weakestWeaponDmg = +item.damageTotal;
				weakestWeaponInst = Hlp_GetInstanceId(item);
			};
		};
        i+=1;
    end;

	return +weakestWeaponInst;
};

func void _TWI_AI_Unequip_All() {
	var C_ITEM itm;

	if (Npc_HasEquippedMeleeWeapon(self)) {
		itm = Npc_GetEquippedMeleeWeapon(self);
		_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
	};

	if (Npc_HasEquippedRangedWeapon(self)) {
		itm = Npc_GetEquippedRangedWeapon(self);
		_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
	};
};

func void TWI_Fist_Only() {	
	if (Npc_IsInFightMode(self, FMODE_MELEE)
	|| Npc_IsInFightMode(self, FMODE_FAR)) {
		AI_DrawWeapon_Ext(self, FMODE_FIST, 1);
	};
	
	AI_Function(self, _TWI_AI_Unequip_All);
};

func void _TWI_Weakest_Weapon_FF() {
	var C_ITEM itm;
	const int weapon = 0;

	weapon = _TWI_Weakest_By_Category(self, ITEM_KAT_FF);
	if (!weapon) { return; };
	if (!Npc_GetInvItem(self, weapon)) { return; };
	if (!Hlp_IsValidItem(item)) { return; };

	if (Npc_IsInFightMode(self, FMODE_FAR)) {
		var C_ITEM weap; weap = Npc_GetReadiedWeapon(self);
		if (Hlp_IsValidItem(weap)) {
			var int weapInst; weapInst = Hlp_GetInstanceId(weap);
			if (weapon == weapInst) { return; };

			AI_RemoveWeapon(self);
			AI_UnequipRangedWeapon(self);
		};
		if (Npc_GetInvItem(self, weapon)) {
			if ((item.Flags & ITEM_ACTIVE_LEGO) == FALSE) {
				AI_EquipItemPtr(self, _@(item));
			};
		};
		AI_DrawWeapon_Ext(self, FMODE_FAR, 0);
	} else if (Npc_HasEquippedRangedWeapon(self)) {
		itm = Npc_GetEquippedRangedWeapon(self);
		if (weapon != Hlp_GetInstanceId(itm)) {
			_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
			_TWI_ToggleWeapon(weapon, 1);
		};
	} else {
		_TWI_ToggleWeapon(weapon, 1);
	};
};

func void _TWI_Weakest_Weapon_NF() {
	var C_ITEM itm;
	const int weapon = 0;

	weapon = _TWI_Weakest_By_Category(self, ITEM_KAT_NF);
	if (!weapon) { return; };
	if (!Npc_GetInvItem(self, weapon)) { return; };
	if (!Hlp_IsValidItem(item)) { return; };

	if (Npc_IsInFightMode(hero, FMODE_MELEE)) {
		var C_ITEM weap; weap = Npc_GetReadiedWeapon(self);
		if (Hlp_IsValidItem(weap)) {
			var int weapInst; weapInst = Hlp_GetInstanceId(weap);
			if (weapon == weapInst) { return; };

			AI_RemoveWeapon(self);
			AI_UnequipMeleeWeapon(self);
		};
		if (Npc_GetInvItem(self, weapon)){
			if ((item.Flags & ITEM_ACTIVE_LEGO) == FALSE) {
				AI_EquipItemPtr(self, _@(item));
			};
		};
		AI_DrawWeapon_Ext(self, FMODE_FIST, 0);
	} else if (Npc_HasEquippedMeleeWeapon(self)) {
		itm = Npc_GetEquippedMeleeWeapon(self);
		if (weapon != Hlp_GetInstanceId(itm)) {
			_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
			_TWI_ToggleWeapon(weapon, 1);
		};
	} else {
		_TWI_ToggleWeapon(weapon, 1);
	};
};

func void TWI_Weakest_Weapon() {
	var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
	self = MEM_CpyInst(hero);

	_TWI_Weakest_Weapon_NF();
	_TWI_Weakest_Weapon_FF();

	self = MEM_CpyInst(oldSlf);	
};

func void TWI_VoicePitch() {
	var string args; args = TwitchIntegration_Arguments;
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	var int amount;
	
	if (splitCount > 0) { amount = STR_ToInt(STR_Split(args, " ", 0)); }
	else                { amount = 0; }; // Default
	hero.voicePitch = amount;
};

/// Init-function called by Ninja
func void Ninja_TWI_Kirides_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	Lego_MergeFlags(LeGo_FrameFunctions|LeGo_Random|LeGo_ConsoleCommands);
	
	TWI_Kirides_Config_OnInit();
	TWI_Kirides_Money_OnInit();
	TWI_InvertKeyControls_OnInit();
	TWI_Southpark_OnInit();
	TWI_Slowdown_OnInit();
	TWI_RandomStats_OnInit();
	TWI_Kirides_HP_MANA_OnInit();
	TWI_Kirides_Console_OnInit();
};
