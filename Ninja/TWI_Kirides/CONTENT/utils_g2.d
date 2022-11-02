

func string _TWI_Kirides_OverlayString(var string prefix, var int level) {
    var string res; res = ConcatStrings(prefix, IntToString(level));
    return ConcatStrings(res, ".mds");
};
func void _TWI_Kirides_FixFightStance(var C_NPC slf, var string talent, var int level) {
    if (level == -1) { MEM_Info("TWI_Kirides: level was -1"); return; }; // Whoops, talent not found

    const string overlay = "";
    if      (Hlp_StrCmp(talent, "NPC_TALENT_1H"))       { overlay = "Humans_1HST";  MEM_Info("TWI_Kirides: Fixing NPC_TALENT_1H"); }
    else if (Hlp_StrCmp(talent, "NPC_TALENT_2H"))       { overlay = "Humans_2HST";  MEM_Info("TWI_Kirides: Fixing NPC_TALENT_2H"); }
	else if (Hlp_StrCmp(talent, "NPC_TALENT_BOW"))      { overlay = "Humans_BowT";  MEM_Info("TWI_Kirides: Fixing NPC_TALENT_BOW"); }    
    else if (Hlp_StrCmp(talent, "NPC_TALENT_CROSSBOW")) { overlay = "Humans_CBowT"; MEM_Info("TWI_Kirides: Fixing NPC_TALENT_CROSSBOW"); };
    
    Mdl_RemoveOverlayMds(slf, _TWI_Kirides_OverlayString(overlay, 1));
    Mdl_RemoveOverlayMds(slf, _TWI_Kirides_OverlayString(overlay, 2));
    // There are only Overlays for 1 and 2
    if (level != 1 && level != 2) { return; };


    Mdl_ApplyOverlayMds (slf, _TWI_Kirides_OverlayString(overlay, level));
};

func int _TWI_Kirides_GetTalentSkill(var C_NPC npc, var string tal) {
    var int symbPtr; symbPtr = MEM_GetParserSymbol(tal);
	if (symbPtr == 0) { MEM_Info(ConcatStrings("Talent not found: ", tal));  return -1; }; // Doesn't exist in this mod...?
	var zCPar_Symbol symb; symb = _^(symbPtr);
	var int talIdx; talIdx = symb.content;

    return +Npc_GetTalentSkill(npc, talIdx);
};

func void _TWI_Kirides_FF_FixFightStanceWhenNothingReadied(var int data) {
    if (!MEM_Game.timeStep) { return; }; // Wenn im Menü, ignorieren
    var C_NPC npc; npc = Hlp_GetNPC(data);

    if (!Hlp_IsValidNpc(npc)) {
        // Despawned, falsche Welt, ...
        FF_RemoveAll(_TWI_Kirides_FF_FixFightStanceWhenNothingReadied);
        return;
    };

    var C_ITEM readied; readied = Npc_GetReadiedWeapon(npc);

    if (!Hlp_IsValidItem(readied)) {
        _TWI_Kirides_FixFightStance(npc, "NPC_TALENT_1H",       _TWI_Kirides_GetTalentSkill(npc, "NPC_TALENT_1H"));
		_TWI_Kirides_FixFightStance(npc, "NPC_TALENT_2H",       _TWI_Kirides_GetTalentSkill(npc, "NPC_TALENT_2H"));
		_TWI_Kirides_FixFightStance(npc, "NPC_TALENT_BOW",      _TWI_Kirides_GetTalentSkill(npc, "NPC_TALENT_BOW"));
		_TWI_Kirides_FixFightStance(npc, "NPC_TALENT_CROSSBOW", _TWI_Kirides_GetTalentSkill(npc, "NPC_TALENT_CROSSBOW"));

        FF_RemoveAll(_TWI_Kirides_FF_FixFightStanceWhenNothingReadied);
    } else {
        MEM_Info("TWI_Kirides: npc has weapon readied");
    };
};

func void _TWI_Kirides_Npc_FixFightStance(var C_NPC slf) {
    // AI_Function, da sich sonst die Steintafeln z.B. verdoppeln
    FF_ApplyOnceExtData(_TWI_Kirides_FF_FixFightStanceWhenNothingReadied, 100, -1, Hlp_GetInstanceID(slf));
};
