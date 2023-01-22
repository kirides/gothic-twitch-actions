
//========================================
// Vob von Npc entfernen
//========================================
func int _TWI_oCNpc_RemoveFromSlot(var c_npc slf, var string SlotName, var int dropIt, var int killEffects) {
    CALL_IntParam(killEffects);
    CALL_IntParam(dropIt);
    CALL_zStringPtrParam(SlotName);
    var int retVal;
    CALL_PutRetValTo(_@(retVal));
    CALL__thiscall(MEM_InstToPtr(slf), oCNpc__RemoveFromSlot);
    return +retVal;
};

/// Legt die angegebene Waffe an, falls sie noch nicht getragen wird und im Inventar vorhanden ist.
func void _TWI_ToggleWeapon(var int ItemInst, var int on) {
    var C_NPC slf; slf = MEM_CpyInst(self);

    if (!Npc_HasItems (slf, ItemInst)) {
        MEM_Info ("_TWI_ToggleWeapon: Player has no weapon. Ignoring request.");
        return;
    };

    if (!Npc_GetInvItem(slf, ItemInst)) {
        MEM_AssertFail("Unexpected behaviour in _TWI_ToggleWeapon.");
        return;
    };

    if ((item.flags & ITEM_ACTIVE_LEGO) && on) {
        /* calling EquipWeapon would unequip the weapon. */
        MEM_Info ("_TWI_ToggleWeapon: This weapon is already equipped. Ignoring request.");
        return;
    } else if (!(item.flags & ITEM_ACTIVE_LEGO) && !on) {
        /* calling EquipWeapon would equip the weapon, but we want to unequip it. */
        MEM_Info ("_TWI_ToggleWeapon: This weapon should be unequipped. Ignoring request.");
        return;
    };

    CALL_PtrParam(MEM_InstToPtr(item));
    CALL__thiscall(MEM_InstToPtr(slf), oCNpc__EquipWeapon);
};


func void _TWI_oCNpc_EquipArmor(var int npcPtr, var int armorPtr) {
	const int oCNpc__EquipArmor_G2 = 7578768; // 0073a490
	const int oCNpc__EquipArmor_G1 = 6910080; // 00697080

	const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam (_@(armorPtr));
        CALL__thiscall(_@(npcPtr), MEMINT_SwitchG1G2(oCNpc__EquipArmor_G1, oCNpc__EquipArmor_G2));
        call = CALL_End();
    };
};

func void _TWI_UnequipArmor(var C_NPC npc) {
	var C_Item armor; armor = Npc_GetEquippedArmor(npc);
	if Hlp_IsValidItem(armor) {
		_TWI_oCNpc_EquipArmor(_@(npc), _@(armor));
	};
};

func void _TWI_EquipArmor(var C_NPC npc, var int inst) {
	var C_Item armor; armor = Npc_GetEquippedArmor(npc);
	if Hlp_IsValidItem(armor) {
		if (Hlp_GetInstanceId(armor) == inst) {
			return; // Already equipped
		};
	};
	if (Hlp_IsValidItem(item)) {
		var c_item oldItem; oldItem = MEM_CpyInst(item);
		if (final()) { item = MEM_CpyInst(oldItem); };
	};
	// Only if the NPC got the armor
	if (Npc_GetInvItem(npc, inst)) {
		_TWI_oCNpc_EquipArmor(_@(npc), _@(item));
	};
};

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
