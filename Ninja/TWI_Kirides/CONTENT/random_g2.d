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
