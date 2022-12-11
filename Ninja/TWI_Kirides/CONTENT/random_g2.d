func int _TWI_Kirides_IgnoreInstanceNoLimit(var int i, var string instName) {

	if (Hlp_StrCmp(instName, "SELF")
	|| Hlp_StrCmp(instName, "OTHER")
	|| Hlp_StrCmp(instName, "VICTIM")
	|| Hlp_StrCmp(instName, "HERO")
	|| Hlp_StrCmp(instName, "CH")
	|| Hlp_StrCmp(instName, "SH")
	|| Hlp_StrCmp(instName, "PC_ROCKEFELLER")
	|| Hlp_StrCmp(instName, "PC_ITEMFELLER")
	// G2 Breaker:
	|| Hlp_StrCmp(instName, "Itemhoshi")
	|| Hlp_StrCmp(instName, "SKELETON_LORD_ARCHOL") // Archol Key
	|| Hlp_StrCmp(instName, "MagicGolem")
	|| Hlp_StrCmp(instName, "OrkElite_AntiPaladinOrkOberst_DI")
	// Testmodelle Pankratz
	|| Hlp_StrCmp(instName, "Itemhoshi")
	|| Hlp_StrCmp(instName, "Hoshi_Testmodell")
	|| Hlp_StrCmp(instName, "TA_Testmodell")
	|| Hlp_StrCmp(instName, "TA_Smalltalkpartner")
	|| Hlp_StrCmp(instName, "SH_Oldworld")
	|| (i == Hlp_GetInstanceId(hero))
	) {
		MEM_Debug("Skip");
		return 1;
	};

    const string nameUpper = ""; nameUpper = STR_UPPER(instName);

	if (STR_StartsWith(nameUpper, "ORC_PRIEST_"))
	|| (STR_StartsWith(nameUpper, "ORG_"))
	|| (STR_StartsWith(nameUpper, "GRD_"))
	|| (STR_StartsWith(nameUpper, "BAU_"))
	|| (STR_StartsWith(nameUpper, "CS_"))
	|| (STR_StartsWith(nameUpper, "PC_"))
	|| (STR_StartsWith(nameUpper, "SFB_"))
	|| (STR_StartsWith(nameUpper, "STT_"))
	|| (STR_StartsWith(nameUpper, "TPL_"))
	// G2
	|| (STR_StartsWith(nameUpper, "NOV_"))
	|| (STR_StartsWith(nameUpper, "KDW_"))
	|| (STR_StartsWith(nameUpper, "KDF_"))
	|| (STR_StartsWith(nameUpper, "PAL_"))
	|| (STR_StartsWith(nameUpper, "MIL_"))
	|| (STR_StartsWith(nameUpper, "VLK_"))
	|| (STR_StartsWith(nameUpper, "PIR_"))
	|| (STR_StartsWith(nameUpper, "NONE_"))
	|| (STR_StartsWith(nameUpper, "BDT_"))
	|| (STR_StartsWith(nameUpper, "DJG_"))
	|| (STR_StartsWith(nameUpper, "SLD_"))
	{
		MEM_Debug("Skip known npc");
		return 1;
	};

    // G2 Quest Mobs
    if (STR_StartsWith(nameUpper, "DRAGON_"))			// Drachen
    || (STR_StartsWith(nameUpper, "STONEGUARDIAN_"))	// Viele Steinwaechter
    || (STR_StartsWith(nameUpper, "BEACHLURKER"))
    || (STR_StartsWith(nameUpper, "BEACHWARAN"))
    || (STR_StartsWith(nameUpper, "BEACHSHADOWBEAST"))
    || (STR_StartsWith(nameUpper, "CANYONRAZOR"))
    || (STR_StartsWith(nameUpper, "CRYPT_SKELETON_ROOM_")) // Krypta Key
    || (STR_StartsWith(nameUpper, "SKELETON_ARCHOL"))
    || (STR_StartsWith(nameUpper, "SKELETON_MARIO"))
    || (STR_StartsWith(nameUpper, "XARDAS_DT_DEMON")) // Pyrokar Quest
    || (STR_StartsWith(nameUpper, "LOBARTS_GIANT_BUG")) // Lobart Quest
    || (STR_StartsWith(nameUpper, "ICEGOLEM_SYLVIO")) // Silvio Quest
    || (STR_StartsWith(nameUpper, "KERVO_LURKER")) // Kervo Quest
    || (STR_StartsWith(nameUpper, "MEATBUG_BRUTUS")) // Brutus Quest
    || (STR_StartsWith(nameUpper, "SKELETONMAGE_ANGAR")) // Angar Quest
    || (STR_StartsWith(nameUpper, "NEWMINE_SNAPPER")) // kap 2 Quest
    || (STR_StartsWith(nameUpper, "NEWMINE_LEADSNAPPER")) // kap 2 Quest
    || (STR_StartsWith(nameUpper, "MIS_ADDON_SWAMPSHARK_")) // Bandit Quest
    || (STR_StartsWith(nameUpper, "PEPES_YWOLF")) // Pepe Quest
    || (STR_StartsWith(nameUpper, "Balthasar_Sheep1"))
    || (STR_StartsWith(nameUpper, "Balthasar_Sheep2"))
    || (STR_StartsWith(nameUpper, "Balthasar_Sheep3"))
    {
        MEM_Debug("Skip known npc");
        return 1;
    };

	if (STR_IndexOf(nameUpper, "TESTMODELL") > 0)
	|| (STR_IndexOf(nameUpper, "_TEST_") > 0)
	|| (STR_IndexOf(nameUpper, "SUMMONED") > 0)
	|| (STR_IndexOf(nameUpper, "_HELPER_") > 0)
	|| (STR_IndexOf(nameUpper, "TRANSFORM") > 0)
	{
		MEM_Debug("Skip Testmodell");
		return 1;
	};

	return 0;
};



func int _TWI_Kirides_IgnoreInstance(var int i, var string instName) {

    if (_TWI_Kirides_IgnoreInstanceNoLimit(i, instName)) {
        return 1;
    };

	if (Hlp_StrCmp(instName, "SELF")
	|| Hlp_StrCmp(instName, "OTHER")
	
	) {
		MEM_Debug("Skip");
		return 1;
	};

	if (STR_StartsWith(instName, "ORC_PRIEST_"))
	|| (STR_StartsWith(instName, "ORG_"))
	
	{
		MEM_Debug("Skip known npc");
		return 1;
	};

	if (STR_IndexOf(instName, "TESTMODELL") > 0)
	|| (STR_IndexOf(instName, "_TEST_") > 0)
	{
		MEM_Debug("Skip Testmodell");
		return 1;
	};

	return 0;
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


func void _TWI_RandomTalents_GameSpecific() {
	var int rnd;

	var int talMax;
	var int talMaxRunes;
	if (Kapitel >= 0) { talMax =  40; talMaxRunes = 2; };
	if (Kapitel >= 2) { talMax =  59; talMaxRunes = 3; };
	if (Kapitel >= 3) { talMax =  80; talMaxRunes = 4; };
	if (Kapitel >= 4) { talMax = 100; talMaxRunes = 5; };
	if (Kapitel >= 5) {               talMaxRunes = 6; };
	if (Kapitel >= 6) { talMax = 100; talMaxRunes = 6; };

	rnd = r_MinMax(0, talMax); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 0, rnd);
	rnd = r_MinMax(0, talMax); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 0, rnd);
	rnd = r_MinMax(0, talMax); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 0, rnd);
	rnd = r_MinMax(0, talMax); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 0, rnd);

	rnd = r_MinMax(0, talMaxRunes);   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_MAGE", 1, rnd);

	_TWI_Kirides_Npc_FixFightStance(hero);
};

func void _TWI_RandomTalent_GameSpecific() {
	var int rnd;

	rnd = r_MinMax(0, 4);
	if (rnd < 4) {
		rnd = r_MinMax(0, 100);
		if      (rnd == 0) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 0, rnd); }
		else if (rnd == 1) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 0, rnd); }
		else if (rnd == 2) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 0, rnd); }
		else if (rnd == 3) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 0, rnd); };
		_TWI_Kirides_Npc_FixFightStance(hero);
	} else if (rnd == 4) { rnd = r_MinMax(0, 6);  _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_MAGE", 1, rnd); };
};

func void _TWI_RandomTalent_GameSpecific_OnInit() {
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_1H");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_2H");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_BOW");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_CROSSBOW");

	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_MAGE");
	_TWI_Kirides_Npc_FixFightStance(hero);
};
