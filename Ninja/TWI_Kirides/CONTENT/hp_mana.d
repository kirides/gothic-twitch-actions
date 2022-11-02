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
	const int value = 0; value = -hero.attribute[ATR_HITPOINTS];
	value += n;
	Npc_ChangeAttribute(hero, ATR_HITPOINTS, value);
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
	if (n < 0) {
		return;
	};
	if (n > maxMana) {
		n = maxMana;
	};
	const int value = 0; value = -hero.attribute[ATR_MANA];
	value += n;
	Npc_ChangeAttribute(hero, ATR_MANA, value);
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

const int _TWI_Kirides_Timed_HP_DurationLeft = 0;
const int _TWI_Kirides_Timed_HP_Value = 0;
func void _TWI_Kirides_Timed_HP_FF() {
	if hero.attribute[ATR_HITPOINTS] == 0 {
		FF_RemoveAll(_TWI_Kirides_Timed_HP_FF);
		return;
	};

	_TWI_Kirides_Timed_HP_DurationLeft -= 1;
	if (_TWI_Kirides_Timed_HP_DurationLeft <= 0) {
		FF_RemoveAll(_TWI_Kirides_Timed_HP_FF);
		return;
	};
	_TWI_SetHP(+_TWI_Kirides_Timed_HP_Value);
};

func void TWI_SetHP_Timed()   {
	var string args; args = TwitchIntegration_Arguments;
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	var int amount; amount = 1;
	var int duration; duration = 5;
	
	if (splitCount > 1) {
		amount = STR_ToInt(STR_Split(args, " ", 0));
		duration = STR_ToInt(STR_Split(args, " ", 1));
	} else if (splitCount > 0) {
		amount = STR_ToInt(STR_Split(args, " ", 0));
	};

	_TWI_Kirides_Timed_HP_DurationLeft = duration;
	_TWI_Kirides_Timed_HP_Value = amount;
    _TWI_SetHP(+_TWI_Kirides_Timed_HP_Value);
	FF_ApplyOnceExtGT(_TWI_Kirides_Timed_HP_FF, 1000, -1);
};

const int _TWI_Kirides_Timed_Mana_DurationLeft = 0;
const int _TWI_Kirides_Timed_Mana_Value = 0;
func void _TWI_Kirides_Timed_Mana_FF() {
	if hero.attribute[ATR_HITPOINTS] == 0 {
		FF_RemoveAll(_TWI_Kirides_Timed_Mana_FF);
		return;
	};

	_TWI_Kirides_Timed_Mana_DurationLeft -= 1;
	if (_TWI_Kirides_Timed_Mana_DurationLeft <= 0) {
		FF_RemoveAll(_TWI_Kirides_Timed_Mana_FF);
		return;
	};

	_TWI_SetMana(+_TWI_Kirides_Timed_Mana_Value);
};

func void TWI_SetMana_Timed()   {
	var string args; args = TwitchIntegration_Arguments;
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	var int amount; amount = 1;
	var int duration; duration = 5;
	
	if (splitCount > 1) {
		amount = STR_ToInt(STR_Split(args, " ", 0));
		duration = STR_ToInt(STR_Split(args, " ", 1));
	} else if (splitCount > 0) {
		amount = STR_ToInt(STR_Split(args, " ", 0));
	};

	_TWI_Kirides_Timed_Mana_DurationLeft = duration;
	_TWI_Kirides_Timed_Mana_Value = amount;
    _TWI_SetMana(+_TWI_Kirides_Timed_Mana_Value);
	FF_ApplyOnceExtGT(_TWI_Kirides_Timed_Mana_FF, 1000, -1);
};

func void TWI_FullHeal() {
	Npc_ChangeAttribute(hero, ATR_MANA, hero.attribute[ATR_MANA_MAX]);
	Npc_ChangeAttribute(hero, ATR_HITPOINTS, hero.attribute[ATR_HITPOINTS_MAX]);
};


func void TWI_Kirides_HP_MANA_OnInit() {
	if (_TWI_Kirides_Timed_HP_DurationLeft   > 0) { _TWI_SetHP  (+_TWI_Kirides_Timed_HP_Value);   FF_ApplyOnceExtGT(_TWI_Kirides_Timed_HP_FF,   1000, -1); };
	if (_TWI_Kirides_Timed_Mana_DurationLeft > 0) { _TWI_SetMana(+_TWI_Kirides_Timed_Mana_Value); FF_ApplyOnceExtGT(_TWI_Kirides_Timed_Mana_FF, 1000, -1); };
};