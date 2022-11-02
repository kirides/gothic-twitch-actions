
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


func void _TWI_Kirides_SetTalent_Save(var C_NPC npc, var string tal, var int isSkill, var int value) {
	var int symbPtr; symbPtr = MEM_GetParserSymbol(tal);
	if (symbPtr == 0) { MEM_Info(ConcatStrings("Talent not found: ", tal));  return; }; // Doesn't exist in this mod...?
	var zCPar_Symbol symb; symb = _^(symbPtr);
	var int talIdx; talIdx = symb.content;

	var string txt; txt = "";
	var int talV; talV = 0;
	var int talS; talS = 0;

	if (Hlp_StrCmp(tal, "NPC_TALENT_1H"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_2H"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_BOW"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_CROSSBOW"))
	{
		if      (value >= 60) { talS = 2; }
		else if (value >= 30) { talS = 1; }
		else                  { talS = 0; };

		Npc_SetTalentSkill (npc, talIdx, talS);
		MEM_WriteStatArr(_@(npc.hitchance), talIdx, value);

		talS = talS;
		talV = value;
	} else {
		
		if (isSkill) {
			talS = value;
			talV = Npc_GetTalentValue(npc, talIdx);
		} else {
			talS = Npc_GetTalentSkill(npc, talIdx);
			talV = value;
		};
		Npc_SetTalentSkill(npc, talIdx, talS);
		Npc_SetTalentValue(npc, talIdx, talV);

	};
	txt = ConcatStrings(txt, IntToString(talS));
	txt = ConcatStrings(txt, "|");
	txt = ConcatStrings(txt, IntToString(talV));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDTALENTS, tal, txt);
};

func void _TWI_Kirides_RestoreTalent_Save(var C_NPC npc, var string tal) {
	var int symbPtr; symbPtr = MEM_GetParserSymbol(tal);
	if (symbPtr == 0) { MEM_Info(ConcatStrings("Talent not found: ", tal));  return; }; // Doesn't exist in this mod...?
	var zCPar_Symbol symb; symb = _^(symbPtr);
	var int talIdx; talIdx = symb.content;

	if (!MEM_GothOptExists(_TWI_KIRIDES_SECT_RANDTALENTS, tal)) { return; };

	var string txt;      txt = MEM_GetGothOpt(_TWI_KIRIDES_SECT_RANDTALENTS, tal);
	var int talS; talS = STR_ToInt(STR_Split(txt, "|", 0));
	var int talV; talV = STR_ToInt(STR_Split(txt, "|", 1));

	Npc_SetTalentSkill(npc, talIdx, talS);
	if (Hlp_StrCmp(tal, "NPC_TALENT_1H"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_2H"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_BOW"))
	|| (Hlp_StrCmp(tal, "NPC_TALENT_CROSSBOW"))
	{
		MEM_WriteStatArr(_@(npc.hitchance), talIdx, talV);
	} else {
		Npc_SetTalentValue(npc, talIdx, talV);
	};
};