
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
