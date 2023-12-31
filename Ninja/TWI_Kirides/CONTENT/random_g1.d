func int _TWI_Kirides_IgnoreInstanceNoLimit(var int i, var string instName) {

	if (Hlp_StrCmp(instName, "SELF")
	|| Hlp_StrCmp(instName, "OTHER")
	|| Hlp_StrCmp(instName, "VICTIM")
	|| Hlp_StrCmp(instName, "HERO")
	|| Hlp_StrCmp(instName, "CH")
	|| Hlp_StrCmp(instName, "SH")
	|| Hlp_StrCmp(instName, "PC_ROCKEFELLER")
	|| Hlp_StrCmp(instName, "PC_ITEMFELLER")
	// G1 Breaker:
	|| Hlp_StrCmp(instName, "DamLurker")       // Homer Quest
	|| Hlp_StrCmp(instName, "XardasDemon")     // Xardas NPC Daemon
	|| Hlp_StrCmp(instName, "Bridgegolem")     // Lester Quest
	|| Hlp_StrCmp(instName, "ZombieTheKeeper") // Milten Quest
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
	|| (STR_StartsWith(nameUpper, "ZOMBIE"))
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

	if (Hlp_StrCmp(instName, "SELF")
	|| Hlp_StrCmp(instName, "DemonLord")     // Ist Unverwundbar
	|| Hlp_StrCmp(instName, "Sleeper")       // Ist Unverwundbar
	) {
		MEM_Debug("Skip");
		return 1;
	};
    const string nameUpper = ""; nameUpper = STR_UPPER(instName);

	if (STR_StartsWith(nameUpper, "ORC_PRIEST_"))
	|| (STR_StartsWith(nameUpper, "ORG_"))
	{
		MEM_Debug("Skip known npc");
		return 1;
	};

	if (STR_IndexOf(nameUpper, "TESTMODELL") > 0)
	|| (STR_IndexOf(nameUpper, "_TEST_") > 0)
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

	if (isSkill) {
		talS = value;
		talV = Npc_GetTalentValue(npc, talIdx);
	} else {
		talS = Npc_GetTalentSkill(npc, talIdx);
		talV = value;
	};
	Npc_SetTalentSkill(npc, talIdx, talS);
	Npc_SetTalentValue(npc, talIdx, talV);

	txt = ConcatStrings(txt, IntToString(talS));
	txt = ConcatStrings(txt, "|");
	txt = ConcatStrings(txt, IntToString(talV));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDTALENTS, tal, txt);
};

func int _TWI_Kirides_GetTalentValue_Save(var C_NPC npc, var string tal, var int isSkill) {
	var int symbPtr; symbPtr = MEM_GetParserSymbol(tal);
	if (symbPtr == 0) { MEM_Info(ConcatStrings("Talent not found: ", tal));  return 0; }; // Doesn't exist in this mod...?
	var zCPar_Symbol symb; symb = _^(symbPtr);
	var int talIdx; talIdx = symb.content;

	if (isSkill) {
		return +Npc_GetTalentSkill(npc, talIdx);
	};
	return +Npc_GetTalentValue(npc, talIdx);
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
	Npc_SetTalentValue(npc, talIdx, talV);
};

func void _TWI_RandomTalents_GameSpecific() {
	var int rnd;

	rnd = r_MinMax(0, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 1, rnd);
	rnd = r_MinMax(0, 15); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 0, rnd);

	rnd = r_MinMax(0, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 1, rnd);
	rnd = r_MinMax(0, 15); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 0, rnd);

	rnd = r_MinMax(0, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 1, rnd);
	rnd = r_MinMax(0, 15); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 0, rnd);

	rnd = r_MinMax(0, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 1, rnd);
	rnd = r_MinMax(0, 15); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 0, rnd);

	rnd = r_MinMax(0, 6);   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_MAGE", 1, rnd);
};

func void _TWI_RandomTalentsPool_GameSpecific() {
	const int pool = 0;

	pool = 0;
	pool = pool + _TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_1H", 0);
	pool = pool + _TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_2H", 0);
	pool = pool + _TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_BOW", 0);
	pool = pool + _TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_CROSSBOW", 0);

	var int rnd;
	var int tmp;
	
	// Crit Chance
	rnd = _TWI_Rnd_Max(pool, 15);       _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 0, rnd);        pool = pool - rnd;
	rnd = _TWI_Rnd_Max(pool, 15);       _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 0, rnd);        pool = pool - rnd;
	rnd = _TWI_Rnd_Max(pool, 15);       _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 0, rnd);       pool = pool - rnd;
	rnd = _TWI_Math_Clamp(0, pool, 15); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 0, rnd);  pool = pool - rnd;

	// Skills, 1H/2H/Bogen/CBow skill/Magie

	pool = 0;
	pool = pool + _TWI_Math_Min0(_TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_1H", 1));
	pool = pool + _TWI_Math_Min0(_TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_2H", 1));
	pool = pool + _TWI_Math_Min0(_TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_BOW", 1));
	pool = pool + _TWI_Math_Min0(_TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_CROSSBOW", 1));
	pool = pool + _TWI_Math_Min0(_TWI_Kirides_GetTalentValue_Save(hero, "NPC_TALENT_MAGE", 1));

	rnd = _TWI_Rnd_Max(pool, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 1, rnd);        pool = pool - rnd;
	rnd = _TWI_Rnd_Max(pool, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 1, rnd);        pool = pool - rnd;
	rnd = _TWI_Rnd_Max(pool, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 1, rnd);       pool = pool - rnd;
	rnd = _TWI_Rnd_Max(pool, 2); _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 1, rnd);  pool = pool - rnd;
	
	rnd = _TWI_Math_Clamp(0, pool, 6);   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_MAGE", 1, rnd);    pool = pool - rnd;

	if (pool != 0) {
		MEM_Warn(ConcatStrings("_TWI_RandomTalentsPool: Stats pool not drained correctly, remainder: ", IntToString(pool)));
	};
};

func void _TWI_RandomTalent_GameSpecific() {
	var int rnd;
	var int rnd2;

	rnd = r_MinMax(0, 4);
	if (rnd < 4) {
		rnd = r_MinMax(0, 2);
		rnd2 = r_MinMax(0, 15);
		if        (rnd == 0) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 1, rnd); 
							   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_1H", 0, rnd2);

		} else if (rnd == 1) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 1, rnd); 
							   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_2H", 0, rnd2);

		} else if (rnd == 2) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 1, rnd); 
							   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_BOW", 0, rnd2);

		} else if (rnd == 3) { _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 1, rnd); 
							   _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_CROSSBOW", 0, rnd2);};
	} else if (rnd == 4) { rnd = r_MinMax(0, 6);  _TWI_Kirides_SetTalent_Save(hero, "NPC_TALENT_MAGE", 1, rnd); };
};

func void _TWI_RandomTalent_GameSpecific_OnInit() {
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_1H");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_2H");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_BOW");
	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_CROSSBOW");

	_TWI_Kirides_RestoreTalent_Save(hero, "NPC_TALENT_MAGE");
};

