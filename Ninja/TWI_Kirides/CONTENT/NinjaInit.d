
// Werden von TwitchIntegration befüllt
const string TwitchIntegration_User = "";
const string TwitchIntegration_Command   = "";
const string TwitchIntegration_Arguments = "";

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

const int TWI_Kirides_CurrencyIdx = -1;
const string TWI_Kirides_CurrencyName = "ITMI_GOLD";
const string TWI_Kirides_CurrencyDisplay = "Geld";

func void _TWI_PlaySound(var string name) {
	const int fnId = -1; fnId = MEM_FindParserSymbol("AI_Snd_Play");
	if (fnId != -1) {
		MEM_PushInstParam(hero);
		MEM_PushStringParam(name);
		MEM_CallByID(fnId);
	} else {
		Snd_Play(name);
	};
};

func string _TWI_CS3(var string a, var string b, var string c) {
	return ConcatStrings(a, ConcatStrings(b, c));
};
func string _TWI_CS4(var string a, var string b, var string c, var string d) {
	return ConcatStrings(a, ConcatStrings(b, ConcatStrings(c, d)));
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

func void _TWI_Donation_N(var int n) {
	if (n <= 0) { MEM_Info("TWI: amount <= 0"); return; };
	if (!Hlp_IsValidNpc(hero)) { MEM_Info("TWI: hero invalid"); return; };
	if (TWI_Kirides_CurrencyIdx == -1) { MEM_Info("TWI: No currency found"); return; };

	MEM_Info(ConcatStrings("_TWI_Donation_N: ", IntToString(n)));

	const int amt = 0; amt = Npc_HasItems(hero, TWI_Kirides_CurrencyIdx);

	if (amt == 0) { MEM_Info("TWI: Not enough money!"); return; };
	
	if amt < 50 {
		if (amt >= 30) {
			Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, 10);
			_TWI_PlaySound("DIA_DARON_SPENDEN_10_04.WAV"); // nun, du hast nicht viel, aber arm bist du auch nicht. 10 Goldstücke für innos, wir sind ja genügsam.
			Print(ConcatStrings("Du spendest 10 ", TWI_Kirides_CurrencyDisplay));
		} else {
			_TWI_PlaySound("DIA_DARON_SPENDEN_10_03.WAV"); // hm, du bist ein armer schlucker was, behalte das bisschen was du hast.
		};
	}
	else if (n >= 1000 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_02.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=  500 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_02.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=  100 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_06.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=   50 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_07.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	} else {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, amt);
		Print(_TWI_CS4("Du spendest ", IntToString(amt), " ", TWI_Kirides_CurrencyDisplay));
	};
};
func void _TWI_AddMoney(var int n) {
	if (n <= 0) { MEM_Info("TWI: amount <= 0"); return; };
	if (!Hlp_IsValidNpc(hero)) { MEM_Info("TWI: hero invalid"); return; };
	if (TWI_Kirides_CurrencyIdx == -1) { MEM_Info("TWI: No currency found"); return; };

	CreateInvItems(hero, TWI_Kirides_CurrencyIdx, n);
	Print(_TWI_CS4("Du erhältst ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
};

func void TWI_PlaySound() { _TWI_PlaySound(TwitchIntegration_Arguments); };

func void TWI_Money() {
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount < 0) {
		_TWI_Donation_N(-amount);
	} else if (amount > 0) {
		_TWI_AddMoney(amount);
	};
};

const int _TWI_Kirides_Southpark_Counter = 0;
const int _TWI_Kirides_Southpark_Max = 0;

func void _TWI_Kirides_Southpark_FF() {
	if (_TWI_Kirides_Southpark_Max == 0) {
		FF_RemoveAll(_TWI_Kirides_Southpark_FF);
		return;
	};
	_TWI_Kirides_Southpark_Counter += 1;
	if (_TWI_Kirides_Southpark_Counter > _TWI_Kirides_Southpark_Max) {
		_TWI_Kirides_Southpark_Max = 0;
		FF_RemoveAll(_TWI_Kirides_Southpark_FF);
		return;
	};
	if (!InfoManager_Hasfinished()) { return; };

	MEM_Timer.factorMotion = mkf(2);
};

func void _TWI_Kirides_Southpark_Reset() {
	if (_TWI_Kirides_Southpark_Max == 0) {
		FF_RemoveAll(_TWI_Kirides_Southpark_FF);
		MEM_Timer.factorMotion = FLOATONE;
	};
};

func void _TWI_Southpark_N(var int n) {
	if (_TWI_Kirides_Southpark_Max != 0)      { return; };
	if (FF_Active(_TWI_Kirides_Southpark_FF)) { return; };
	
	MEM_Info(ConcatStrings("_TWI_Southpark_N: ", IntToString(n)));

	_TWI_Kirides_Southpark_Counter = 0;
	_TWI_Kirides_Southpark_Max = n;
	FF_ApplyOnceExtGT(_TWI_Kirides_Southpark_FF, 1000, -1);
	FF_ApplyOnceExtGT(_TWI_Kirides_Southpark_Reset, 100, -1);
};

func void TWI_Southpark()  { 	
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		_TWI_Southpark_N(amount);
	};
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

func void _TWI_SetMana_0() {
	Npc_ChangeAttribute(hero, ATR_MANA, -hero.attribute[ATR_MANA]);
};

func void _TWI_SetHP(var int n) {
	MEM_Info(ConcatStrings("_TWI_SetHP: ", IntToString(n)));
	if hero.attribute[ATR_HITPOINTS] == 0 {
		return;
	};
	var int maxHp; maxHp = hero.attribute[ATR_HITPOINTS_MAX];
	if (n <= 0) {
		return;
	};
	if (n > maxHp) {
		n = maxHp;
	};
	const int hp = 0; hp = -hero.attribute[ATR_HITPOINTS];
	hp += n;
	Npc_ChangeAttribute(hero, ATR_HITPOINTS, hp);
};

func void TWI_SetHP() {
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		_TWI_SetHP(amount);
	};
};

func void _TWI_SetMana(var int n) {
	MEM_Info(ConcatStrings("_TWI_SetMana: ", IntToString(n)));
	
	var int maxMana; maxMana = hero.attribute[ATR_MANA_MAX];
	if (n <= 0) {
		return;
	};
	if (n > maxMana) {
		n = maxMana;
	};
	const int hp = 0; hp = -hero.attribute[ATR_MANA];
	hp += n;
	Npc_ChangeAttribute(hero, ATR_MANA, hp);
};

func void TWI_SetMana() {
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		_TWI_SetMana(amount);
	};
};

func void _TWI_SetHP_1() { _TWI_SetHP(1); };
func void _TWI_SetMana_0() { _TWI_SetMana(0); };

func void _TWI_SetHP_N(var int n)   { _TWI_SetHP(n); };
func void _TWI_SetMana_N(var int n) { _TWI_SetMana(n); };

func void _TWI_SetMana_0_Timed(var int timeMs) {
	const int cycles = 0; cycles = timeMs / 100;
	FF_ApplyOnceExtGT(_TWI_SetMana_0, 100, cycles);
};

func void _TWI_SetHP_1_Timed(var int timeMs) {
	const int cycles = 0; cycles = timeMs / 100;
	FF_ApplyOnceExtGT(_TWI_SetHP_1, 100, cycles);
};

func void TWI_SetHP_1_5s()   { _TWI_SetHP_1_Timed( 5000); };
func void TWI_SetHP_1_15s()   { _TWI_SetHP_1_Timed( 15000); };
func void TWI_SetHP_1_30s()   { _TWI_SetHP_1_Timed( 30000); };
func void TWI_SetHP_1_60s()  { _TWI_SetHP_1_Timed( 60000); };

func void TWI_SetMana_0_5s() { _TWI_SetMana_0_Timed( 5000); };
func void TWI_SetMana_0_15s() { _TWI_SetMana_0_Timed( 15000); };
func void TWI_SetMana_0_30s() { _TWI_SetMana_0_Timed( 30000); };
func void TWI_SetMana_0_60s() { _TWI_SetMana_0_Timed( 60000); };

func void TWI_FullHeal() {
	Npc_ChangeAttribute(hero, ATR_MANA, hero.attribute[ATR_MANA_MAX]);
	Npc_ChangeAttribute(hero, ATR_HITPOINTS, hero.attribute[ATR_HITPOINTS_MAX]);
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

func void _TWI_Init_Currency() {
	if (GOTHIC_BASE_VERSION == 1) {
		TWI_Kirides_CurrencyName = "ITMINUGGET";
	};

	// automatically find the current currency. Is required for G2A, don't know G1
	var int currency; currency = MEM_GetSymbol("TRADE_CURRENCY_INSTANCE");
    if (currency) {
        var zCPar_Symbol currencySymb; currencySymb = _^(currency);
        TWI_Kirides_CurrencyName = MEM_ReadString(currencySymb.content);
	};
	TWI_Kirides_CurrencyIdx = MEM_FindParserSymbol(TWI_Kirides_CurrencyName);
	if (TWI_Kirides_CurrencyIdx != -1) {
		MEMINT_GetMemHelper();
		CreateInvItem(MEM_Helper, TWI_Kirides_CurrencyIdx);
		Npc_GetInvItem(MEM_Helper, TWI_Kirides_CurrencyIdx);

		if (Hlp_IsValidItem(item)) {
			TWI_Kirides_CurrencyDisplay = item.name;
		};
	};
};

/// Init-function called by Ninja
func void Ninja_TWI_Kirides_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	Lego_MergeFlags(LeGo_FrameFunctions|LeGo_Random);
	
	const int once = 0;
	if (once) { return; };
	
	_TWI_Init_Currency();
	
	once = 1;
};
