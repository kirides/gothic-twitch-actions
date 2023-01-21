
func int _TWI_CanEquip(var C_NPC npc, var C_ITEM itm) {
	const int ITM_COND_MAX = 3;
	const int idxAttr = -1;
	const int condValue = -1;
	const int npcValue = -1;

	repeat(i, ITM_COND_MAX); var int i;
		idxAttr = MEM_ReadStatArr(_@(itm.cond_atr), i);
		if (idxAttr > 0) {
			condValue = MEM_ReadStatArr(_@(itm.cond_value), i);
			npcValue = MEM_ReadStatArr(_@(npc.attribute), idxAttr);
			if (npcValue < condValue) {
				return 0;
			};
		};
	end;
	return 1;
};


func void _TWI_UnequipItems_IfStatsTooLow_FF() {
	if (Npc_IsInFightMode(hero, FMODE_FAR)) {
		var C_ITEM weap; weap = Npc_GetReadiedWeapon(hero);
		if (Hlp_IsValidItem(weap)) {
			if (!_TWI_CanEquip(hero, weap)) {
				AI_RemoveWeapon(hero);
				AI_UnequipRangedWeapon(hero);
			};
		};
	} else if (Npc_HasEquippedRangedWeapon(hero)) {
		var C_ITEM itm; itm = Npc_GetEquippedRangedWeapon(hero);
		if (!_TWI_CanEquip(hero, itm)) {
			_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
		};
	};
};

func void _TWI_UnequipItems_IfStatsTooLow_NF() {
	if (Npc_IsInFightMode(hero, FMODE_MELEE)) {
		var C_ITEM weap; weap = Npc_GetReadiedWeapon(hero);
		if (Hlp_IsValidItem(weap)) {
			if (!_TWI_CanEquip(hero, weap)) {
				AI_RemoveWeapon(hero);
				AI_UnequipMeleeWeapon(hero);
			};
		};
	} else if (Npc_HasEquippedMeleeWeapon(hero)) {
		var C_ITEM itm; itm = Npc_GetEquippedMeleeWeapon(hero);
		if (!_TWI_CanEquip(hero, itm)) {
			_TWI_ToggleWeapon(Hlp_GetInstanceId(itm), 0);
		};
	};
};

func void _TWI_UnequipItems_IfStatsTooLow() {
	_TWI_UnequipItems_IfStatsTooLow_NF();
	_TWI_UnequipItems_IfStatsTooLow_FF();
};

func int _TWI_WarnIfNegative(var int value, var string tag) {
	if (value < 0) { 
		MEM_Warn(ConcatStrings("Value was negative: ", ConcatStrings(tag, ConcatStrings(" = ", IntToString(value)))));
	};
    return +value;
};

func int _TWI_Math_Min0(var int value) {
	if (value < 0) { return 0; };
    return value;
};

func int _TWI_Math_Clamp(var int min, var int value, var int max) {
	if (value > max) { return max; };
	if (value < min) { return min; };
    return value;
};

func int _TWI_Math_Min(var int a, var int b) {
	if (a < b) { return a; };
	return b;
};
func int _TWI_Math_Max(var int a, var int b) {
	if (a > b) { return a; };
	return b;
};

/// führt `r_Max(value)` aus oder `r_Max(max)`, wenn `value < 0` dann wird `0` zurückgegeben
func int _TWI_Rnd_Max(var int value, var int max) {
	if (value > max) { return r_Max(max); };
	if (value < 0) { return 0; };
    return r_Max(value);
};

/// `by` sollte das ergebnis von `(ist * 100) / soll` sein
func int _TWI_LerpF(var int byF, var int fromF, var int toF) {
    return addf(fromF, mulf(subf(toF, fromF), byF));
};
func int _TWI_Lerp(var int byF, var int from, var int to) {
	var int fromF; fromF = mkf(from);
	var int toF; toF = mkf(to);

    return truncf(addf(fromF, mulf(subf(toF, fromF), byF)));
};
