
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
