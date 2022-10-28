

instance _TWI_MEM_C_NPC@(oCNpc);

func int _TWI_MEM_SizeOf_C_NPC() {
    var zCPar_Symbol symbCls; symbCls= _PM_ToClass(_TWI_MEM_C_NPC@);
	
	return symbCls.offset;
};

const int _TWI_Kirides_AllMonsters_Arr = 0;
const int _TWI_Kirides_LimitedMonsters_Arr = 0;

func int _TWI_Kirides_IgnoreInstance(var int i, var string instName) {

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

	if (STR_StartsWith(instName, "ORC_PRIEST_"))
	|| (STR_StartsWith(instName, "ORG_"))
	|| (STR_StartsWith(instName, "GRD_"))
	|| (STR_StartsWith(instName, "BAU_"))
	|| (STR_StartsWith(instName, "CS_"))
	|| (STR_StartsWith(instName, "PC_"))
	|| (STR_StartsWith(instName, "SFB_"))
	|| (STR_StartsWith(instName, "STT_"))
	|| (STR_StartsWith(instName, "TPL_"))
	// G2
	|| (STR_StartsWith(instName, "NOV_"))
	|| (STR_StartsWith(instName, "KDW_"))
	|| (STR_StartsWith(instName, "KDF_"))
	|| (STR_StartsWith(instName, "PAL_"))
	|| (STR_StartsWith(instName, "MIL_"))
	|| (STR_StartsWith(instName, "VLK_"))
	|| (STR_StartsWith(instName, "PIR_"))
	|| (STR_StartsWith(instName, "NONE_"))
	|| (STR_StartsWith(instName, "BDT_"))
	|| (STR_StartsWith(instName, "DJG_"))
	|| (STR_StartsWith(instName, "SLD_"))
	{
		MEM_Debug("Skip known npc");
		return 1;
	};

	if (GOTHIC_BASE_VERSION == 2) {
		// G2 Quest Mobs
		if (STR_StartsWith(instName, "BEACHLURKER"))
		|| (STR_StartsWith(instName, "BEACHWARAN"))
		|| (STR_StartsWith(instName, "BEACHSHADOWBEAST"))
		|| (STR_StartsWith(instName, "CANYONRAZOR"))
		|| (STR_StartsWith(instName, "CRYPT_SKELETON_ROOM_")) // Krypta Key
		|| (STR_StartsWith(instName, "SKELETON_ARCHOL"))
		|| (STR_StartsWith(instName, "SKELETON_MARIO"))
		|| (STR_StartsWith(instName, "XARDAS_DT_DEMON")) // Pyrokar Quest
		|| (STR_StartsWith(instName, "LOBARTS_GIANT_BUG")) // Lobart Quest
		|| (STR_StartsWith(instName, "ICEGOLEM_SYLVIO")) // Silvio Quest
		|| (STR_StartsWith(instName, "KERVO_LURKER")) // Kervo Quest
		|| (STR_StartsWith(instName, "MEATBUG_BRUTUS")) // Brutus Quest
		|| (STR_StartsWith(instName, "SKELETONMAGE_ANGAR")) // Angar Quest
		|| (STR_StartsWith(instName, "NEWMINE_SNAPPER")) // kap 2 Quest
		|| (STR_StartsWith(instName, "NEWMINE_LEADSNAPPER")) // kap 2 Quest
		|| (STR_StartsWith(instName, "MIS_ADDON_SWAMPSHARK_")) // Bandit Quest
		|| (STR_StartsWith(instName, "PEPES_YWOLF")) // Pepe Quest
		{
			MEM_Debug("Skip known npc");
			return 1;
		};
	};

	if (STR_IndexOf(instName, "TESTMODELL") > 0)
	|| (STR_IndexOf(instName, "_TEST_") > 0)
	|| (STR_IndexOf(instName, "SUMMONED") > 0)
	|| (STR_IndexOf(instName, "_HELPER_") > 0)
	|| (STR_IndexOf(instName, "TRANSFORM") > 0)
	{
		MEM_Debug("Skip Testmodell");
		return 1;
	};

	return 0;
};

func void _TWI_Kirides_ClearInventory(var C_NPC npc) {
	// Globales ITEM speichern und zurücksetzen am Ende
	var int itmOld; itmOld = _@(item);
	if (final()) { item = _^(itmOld); };

    var int amount;
    var int itmID; 
    
    var int slotNr;
	if (GOTHIC_BASE_VERSION == 2) {
		// Gothic 2 lies to you about categories got NPC_GetInvItemBySlot.
		// It only looks in a global inventory without respecting the category

		MEM_PushInstParam(npc);
		MEM_CallByString("Npc_ClearInventory");

		slotNr = 0;
		while (1); // Loop all items, until category is empty/item is invalid
			amount = NPC_GetInvItemBySlot(npc, INV_CAT_MAX, slotNr);
			if (amount == 0) { break; };
			if (!Hlp_IsValidItem(item)) { break; };
			
			itmID = Hlp_GetInstanceID(item);
			// if (item.flags & ITEM_KAT_ARMOR) {
			// 	slotNr += 1;
			// 	continue;
			// };
			// if (item.flags & ITEM_ACTIVE_LEGO) {
			// 	slotNr += 1;
			// 	continue;
			// };
			if (amount > 0) {
				Npc_RemoveInvItems (npc, itmID, amount);
			};
		end;
	} else {
		repeat (i,INV_CAT_MAX); var int i;
			slotNr = 0;
			while (1); // Loop all items, until category is empty/item is invalid
				amount = NPC_GetInvItemBySlot(npc, i, slotNr);
				if (amount == 0) { break; };
				if (!Hlp_IsValidItem(item)) { break; };
				
				itmID = Hlp_GetInstanceID(item);
				// if (item.flags & ITEM_KAT_ARMOR) {
				// 	slotNr += 1;
				// 	continue;
				// };
				// For now, also loot equipped stuff.
				// How do Xardas' golem hearts work in G1?
				// if (item.flags & ITEM_ACTIVE_LEGO) {
				// 	slotNr += 1;
				// 	continue;
				// };
				if (amount > 0) {
					Npc_RemoveInvItems (npc, itmID, amount);
				};
			end;
		end;
	};
};

func int _TWI_Kirides_GetInstIntValue(var int inst, var int targetSymbolIdx) {
	const int tokenArr = 0; tokenArr = MEM_ArrayCreate();
	const int paramArr = 0; paramArr = MEM_ArrayCreate();
	const int posArr   = 0;   posArr = MEM_ArrayCreate();

	MEMINT_TokenizeFunction(inst, tokenArr, paramArr, posArr);

	var int value; value = -1;
	var zCPar_Symbol symb;
	repeat(i, MEM_ArraySize(tokenArr)); var int i;
		var int tok; tok = MEM_ArrayRead(tokenArr, i);

		if (tok != zPAR_OP_IS) { continue; };

		// Look for Xyz = VAR/CONST

		// If right side is not a PUSHVAR/PUSHINT, we don't care about the rest
		var int right; right = MEM_ArrayRead(tokenArr, i-2);
		if (right != zPAR_TOK_PUSHVAR && right != zPAR_TOK_PUSHINT) { continue; };

		// left must be a PUSHVAR
		var int left;  left  = MEM_ArrayRead(tokenArr, i-1);
		if (left != zPAR_TOK_PUSHVAR) { continue; };

		if (MEM_ArrayRead(paramArr, i-1) == targetSymbolIdx) {
			if (right == zPAR_TOK_PUSHINT) {
				value = MEM_ArrayRead(paramArr, i-2);
				break;
			}
			else if (right == zPAR_TOK_PUSHVAR)
			{
				symb = _^(MEM_GetSymbolByIndex(MEM_ArrayRead(paramArr, i-2)));
				value = symb.content;
				break;
			};
		};
	end;

	if (value == -1) {
		symb = _^(MEM_ReadIntArray(contentSymbolTableAddress, inst));
		if (symb.parent != 0) {
			symb = _^(symb.parent);
			
			MEM_ArrayFree(tokenArr);
			MEM_ArrayFree(paramArr);
			MEM_ArrayFree(posArr);

			return +_TWI_Kirides_GetInstIntValue(MEM_GetSymbolIndex(symb.name), targetSymbolIdx);
		};
	};

	MEM_ArrayFree(tokenArr);
	MEM_ArrayFree(paramArr);
	MEM_ArrayFree(posArr);
	return +value;
};

func int _TWI_Kirides_GetGuild(var int inst) {
	const int idxC_NPC_GUILD = -1;
	if (idxC_NPC_GUILD == -1) { idxC_NPC_GUILD = MEM_FindParserSymbol("C_NPC.GUILD"); };


	// const int targetSymbolIdx = -1; targetSymbolIdx = MEM_FindParserSymbol(symbolName);
	return +_TWI_Kirides_GetInstIntValue(inst, idxC_NPC_GUILD);
};

func int _TWI_Kirides_GetLevel(var int inst) {
	const int idxC_NPC_LEVEL = -1;
	if (idxC_NPC_LEVEL == -1) { idxC_NPC_LEVEL = MEM_FindParserSymbol("C_NPC.LEVEL"); };


	// const int targetSymbolIdx = -1; targetSymbolIdx = MEM_FindParserSymbol(symbolName);
	return +_TWI_Kirides_GetInstIntValue(inst, idxC_NPC_LEVEL);
};

func int _TWI_Kirides_NpcIsMonster(var int i) {
	const int npcGuild = 0; npcGuild = _TWI_Kirides_GetGuild(i);
	if ((npcGuild > GIL_SEPERATOR_HUM) && (npcGuild < GIL_SEPERATOR_ORC)) {
		const string instName = ""; instName = _PM_InstName(i);
		if (_TWI_Kirides_IgnoreInstance(i, instName)) {
			return 0;
		};

		return 1;
	};
	return 0;
};
func void _TWI_Kirides_OnNpcInstance(var int array, var int i, var int maxLevel) {
	if (_TWI_Kirides_GetLevel(i) > maxLevel) {
		return;
	};

	MEM_ArrayInsert(array, i);
};

const int _TWI_Kirides_AllMonsters_Initialized = 0;
func int _TWI_Kirides_CollectMonsters(var int maxLevel) {
	if (_TWI_Kirides_AllMonsters_Arr == 0) {
		_TWI_Kirides_AllMonsters_Arr = MEM_ArrayCreate();
	};
	if (_TWI_Kirides_LimitedMonsters_Arr == 0) {
		_TWI_Kirides_LimitedMonsters_Arr = MEM_ArrayCreate();
	};
	MEM_ArrayClear(_TWI_Kirides_LimitedMonsters_Arr);

	const int i = 0; i = 0;
	var int selfBak;  selfBak  = _@(self);
	var int instBak; instBak = MEM_GetUseInstance();

	MEM_Debug("Walking the Symbol table");

	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_NPC")) {
			if (_TWI_Kirides_NpcIsMonster(i)) {
				if (_TWI_Kirides_AllMonsters_Initialized == 0) {
					MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
				};
				_TWI_Kirides_OnNpcInstance(_TWI_Kirides_LimitedMonsters_Arr, i, maxLevel);
			};
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);

			if (Hlp_StrCmp(symb.name, "C_NPC")) {
				if (_TWI_Kirides_NpcIsMonster(i)) {
					if (_TWI_Kirides_AllMonsters_Initialized == 0) {
						MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
					};
					_TWI_Kirides_OnNpcInstance(_TWI_Kirides_LimitedMonsters_Arr, i, maxLevel);
				};
			};
		};

		// Reset state after iteration
		MEM_AssignInstSuppressNullWarning = TRUE;
		self  = _^(selfBak);
		MEM_AssignInstSuppressNullWarning = FALSE;
		MEM_SetUseInstance(instBak);
	end;

	_TWI_Kirides_AllMonsters_Initialized = 1;
	MEM_Debug("Done walking the Symbol table");

	MEM_AssignInstSuppressNullWarning = TRUE;
	self  = _^(selfBak);
	MEM_AssignInstSuppressNullWarning = FALSE;
	MEM_SetUseInstance(instBak);
	
	return +MEM_ArraySize(_TWI_Kirides_AllMonsters_Arr);
};

func int _TWI_Math_Min(var int a, var int b) {
	if (a < b) { return a; };
	return b;
};
func void _TWI_Kirides_SpawnRandomMonster(var string user, var int amount, var int limitByLevel) {
	const int maxMonsters = -1;
	const int currentChp = 6;
	const int heroLvl = 0;
	const int maxLevel = 999999;
	const int usedArray = 0;
	if (limitByLevel) {
		if (currentChp != Kapitel)
		|| (heroLvl != hero.level)
		{
			heroLvl = hero.level;
			currentChp = Kapitel;
			maxMonsters = -1;

			if      (currentChp == 1 && heroLvl < 5)  { maxLevel = _TWI_Math_Min(hero.level+5, 8); }
			else if (currentChp == 2 && heroLvl < 12) { maxLevel = _TWI_Math_Min(hero.level+5, 12); }
			else if (currentChp == 3 && heroLvl < 16) { maxLevel = _TWI_Math_Min(hero.level+5, 16); }
			else if (currentChp == 4 && heroLvl < 19) { maxLevel = _TWI_Math_Min(hero.level+5, 19); }
			else if (currentChp == 5 && heroLvl < 20) { maxLevel = _TWI_Math_Min(hero.level+5, 24); }
			else                                      { maxLevel = 99999; }
			;
			_TWI_Kirides_CollectMonsters(maxLevel);
		};
		if (_TWI_Kirides_LimitedMonsters_Arr == 0) {
			_TWI_Kirides_CollectMonsters(maxLevel);
		};
		usedArray = _TWI_Kirides_LimitedMonsters_Arr;
	} else {
		if (!_TWI_Kirides_AllMonsters_Initialized) {
			_TWI_Kirides_CollectMonsters(1);
		};
		usedArray = _TWI_Kirides_AllMonsters_Arr;
	};

	maxMonsters = MEM_ArraySize(usedArray);
	var int rnd;
	var int inst;

	repeat(i, amount); var int i;
		rnd = r_Next()%maxMonsters;

		inst = MEM_ArrayRead(usedArray, rnd);
		_TWI_Kirides_Spawn_N(user, inst, 1, TRUE, FALSE);
	end;
};

func void TWI_SpawnRandomMonster() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;

	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount <= 0) { amount = 1; };

	_TWI_Kirides_SpawnRandomMonster(user, amount, TRUE);
};

func void TWI_SpawnRandomMonsterNoLimit() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;

	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount <= 0) { amount = 1; };

	_TWI_Kirides_SpawnRandomMonster(user, amount, FALSE);
};

const int _TWI_SpawnItemRandom_Array = 0;
func int _TWI_SpawnItemRandom_CollectAll() {
	var int array; array = MEM_ArrayCreate();
	const int i = 0; i = 0;

	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_ITEM")) {
			MEM_ArrayPush(array, i);
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);
			if (Hlp_StrCmp(symb.name, "C_ITEM")) {
				MEM_ArrayPush(array, i);
			};
		};
	end;

	return +array;
};


func void _TWI_RandomWaypoint_FF() {
	// NOT While in dialog!
	if (!InfoManager_Hasfinished()) { return; };

	var zCWaynet wayNet; wayNet = MEM_PtrToInst(MEM_World.wayNet);
	var int len; len = List_LengthS(wayNet.wplist_next);
	var int rnd; rnd = r_Next()%len;

	var int ptr; ptr = List_GetS(wayNet.wplist_next, rnd);
	var zCWaypoint wp; wp = _^(ptr);

	AI_Teleport(hero, wp.name);
	FF_RemoveAll(_TWI_RandomWaypoint_FF);
};

func void TWI_RandomWaypoint() {
	FF_ApplyOnceExtGT(_TWI_RandomWaypoint_FF, 200, -1);
};

func void TWI_SpawnItemRandom() {
	if (_TWI_SpawnItemRandom_Array == 0) {
		_TWI_SpawnItemRandom_Array = _TWI_SpawnItemRandom_CollectAll();
	};

	const int totalItems = -1; totalItems = MEM_ArraySize(_TWI_SpawnItemRandom_Array);
	if totalItems <= 0 {
		return;
	};
	var int rnd; rnd = r_Next()%totalItems;
	const int itmIdx = -1; itmIdx = MEM_ArrayRead(_TWI_SpawnItemRandom_Array, rnd);

	if (itmIdx != -1) {
		MEMINT_GetMemHelper();
		if !Npc_GetInvItem(MEM_Helper, itmIdx) {
			CreateInvItem(MEM_Helper, itmIdx);
			Npc_GetInvItem(MEM_Helper, itmIdx);
		};
		if (Hlp_IsValidItem(item)){
			Print(ConcatStrings("Hier liegt irgendwo ", item.description));
		};
		Wld_InsertItem(itmIdx, Npc_GetNearestWP(hero));
	};
};

const int _TWI_SpawnRandomItemNoArmorWeapons_Array = 0;
func int _TWI_SpawnRandomItemNoArmorWeapons_CollectAll() {
	if (_TWI_SpawnItemRandom_Array == 0) {
		_TWI_SpawnItemRandom_Array = _TWI_SpawnItemRandom_CollectAll();
	};

	const int idx_C_Item_MainFlag = -1;
	if (idx_C_Item_MainFlag == -1) { idx_C_Item_MainFlag = MEM_FindParserSymbol("C_ITEM.MAINFLAG"); };

	var int array; array = MEM_ArrayCreate();
	const int i = 0; i = 0;
	const int itemIdx = 0; itemIdx = 0;
	const int mainFlag = 0;
	const int wear = 0;

	repeat(i, MEM_ArraySize(_TWI_SpawnItemRandom_Array));
		itemIdx = MEM_ArrayRead(_TWI_SpawnItemRandom_Array, i);

		mainFlag = +_TWI_Kirides_GetInstIntValue(itemIdx, idx_C_Item_MainFlag);
		if (mainFlag & ITEM_KAT_ARMOR) { continue; };
		if (mainFlag & ITEM_KAT_NF) { continue; };
		if (mainFlag & ITEM_KAT_FF) { continue; };

		MEM_ArrayPush(array, itemIdx);
	end;

	return +array;
};


func void TWI_SpawnRandomItemNoArmorWeapons() {
	if (_TWI_SpawnRandomItemNoArmorWeapons_Array == 0) {
		_TWI_SpawnRandomItemNoArmorWeapons_Array = _TWI_SpawnRandomItemNoArmorWeapons_CollectAll();
	};

	const int totalItems = -1; totalItems = MEM_ArraySize(_TWI_SpawnRandomItemNoArmorWeapons_Array);
	if totalItems <= 0 {
		return;
	};
	var int rnd; rnd = r_Next()%totalItems;
	const int itmIdx = -1; itmIdx = MEM_ArrayRead(_TWI_SpawnRandomItemNoArmorWeapons_Array, rnd);
	const int oldArmor = -1;

	if (itmIdx != -1) {
		MEMINT_GetMemHelper();
		if !Npc_GetInvItem(MEM_Helper, itmIdx) {
			CreateInvItem(MEM_Helper, itmIdx);
			Npc_GetInvItem(MEM_Helper, itmIdx);
		};
		if (Hlp_IsValidItem(item)){
			Print(ConcatStrings("Hier liegt irgendwo ", item.description));
		};
		Wld_InsertItem(itmIdx, Npc_GetNearestWP(hero));
	};
};

const int _TWI_SpawnRandomArmor_Array = 0;
func int _TWI_RandomArmor_CollectAll() {
	if (_TWI_SpawnItemRandom_Array == 0) {
		_TWI_SpawnItemRandom_Array = _TWI_SpawnItemRandom_CollectAll();
	};

	const int idx_C_Item_MainFlag = -1;
	const int idx_C_Item_Wear = -1;
	if (idx_C_Item_MainFlag == -1) { idx_C_Item_MainFlag = MEM_FindParserSymbol("C_ITEM.MAINFLAG"); };
	if (idx_C_Item_Wear == -1)     { idx_C_Item_Wear = MEM_FindParserSymbol("C_ITEM.WEAR"); };

	var int array; array = MEM_ArrayCreate();
	const int i = 0; i = 0;
	const int itemIdx = 0; itemIdx = 0;
	const int mainFlag = 0;
	const int wear = 0;

	repeat(i, MEM_ArraySize(_TWI_SpawnItemRandom_Array));
		itemIdx = MEM_ArrayRead(_TWI_SpawnItemRandom_Array, i);

		mainFlag = +_TWI_Kirides_GetInstIntValue(itemIdx, idx_C_Item_MainFlag);
		if (mainFlag & ITEM_KAT_ARMOR) {
			wear = +_TWI_Kirides_GetInstIntValue(itemIdx, idx_C_Item_Wear);
			if (wear == WEAR_TORSO) {
				MEM_ArrayPush(array, itemIdx);
			};
		};
	end;

	return +array;
};

func void TWI_RandomArmor() {
	if (_TWI_SpawnRandomArmor_Array == 0) {
		_TWI_SpawnRandomArmor_Array = _TWI_RandomArmor_CollectAll();
	};

	const int totalItems = -1; totalItems = MEM_ArraySize(_TWI_SpawnRandomArmor_Array);
	if totalItems <= 0 {
		return;
	};
	var int rnd; rnd = r_Next()%totalItems;
	const int itmIdx = -1; itmIdx = MEM_ArrayRead(_TWI_SpawnRandomArmor_Array, rnd);
	const int oldArmor = -1;

	var C_ITEM armor;
	if (itmIdx != -1) {
		armor = Npc_GetEquippedArmor(hero);
		if (Hlp_IsValidItem(armor)) {
			oldArmor = Hlp_GetInstanceId(armor);
			_TWI_oCNpc_EquipArmor(_@(hero), _@(armor));
			Npc_RemoveInvItem(hero, oldArmor);
		};
		if (!Npc_HasItems(hero, itmIdx)) {
			CreateInvItem(hero, itmIdx);
		};
		_TWI_EquipArmor(hero, itmIdx);
	};
};

func void TWI_RandomStats() {
	const int STRDEX_Min = 0;
	const int STRDEX = 0;
	const int HP_Min = 0;
	const int HP = 0;
	const int MANA_Min = 0;
	const int MANA = 0;

	MANA_Min = 1;

	if Kapitel < 2 {
		STRDEX_Min = 10;
		HP_Min = 5;
		STRDEX = MEMINT_SwitchG1G2(30, 60);
		HP     = MEMINT_SwitchG1G2(100, 100);
		MANA   = MEMINT_SwitchG1G2(30, 60);
	} else if Kapitel < 3 {
		STRDEX_Min = 25;
		HP_Min = 30;
		STRDEX = MEMINT_SwitchG1G2(60, 90);
		HP     = MEMINT_SwitchG1G2(150, 180);
		MANA   = MEMINT_SwitchG1G2(40, 100);
	} else if Kapitel < 4 {
		STRDEX_Min = 40;
		HP_Min = 50;
		STRDEX = MEMINT_SwitchG1G2(90, 130);
		HP     = MEMINT_SwitchG1G2(200, 400);
		MANA   = MEMINT_SwitchG1G2(50, 150);
	} else if Kapitel < 5 {
		STRDEX_Min = 60;
		HP_Min = 80;
		STRDEX = MEMINT_SwitchG1G2(110, 150);
		HP     = MEMINT_SwitchG1G2(300, 500);
		MANA   = MEMINT_SwitchG1G2(60, 200);
	} else if Kapitel < 6 {
		STRDEX_Min = 60;
		HP_Min = 100;
		STRDEX = MEMINT_SwitchG1G2(120, 200);
		HP     = MEMINT_SwitchG1G2(350, 700);
		MANA   = MEMINT_SwitchG1G2(70, 250);
	} else {
		STRDEX_Min = 60;
		HP_Min = 100;
		STRDEX = MEMINT_SwitchG1G2(120, 200);
		HP     = MEMINT_SwitchG1G2(500, 1000);
		MANA   = MEMINT_SwitchG1G2(80, 250);
	};

	var int rnd;
	
	rnd = r_MinMax(STRDEX_Min, STRDEX);
	hero.attribute[ATR_DEXTERITY] = rnd;

	rnd = r_MinMax(STRDEX_Min, STRDEX);
	hero.attribute[ATR_STRENGTH] = rnd;

	rnd = r_MinMax(HP_Min, HP);
	hero.attribute[ATR_HITPOINTS_MAX] = rnd;
	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	rnd = r_MinMax(MANA_Min, MANA);
	hero.attribute[ATR_MANA_MAX] = rnd;
	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	_TWI_UnequipItems_IfStatsTooLow();
};

func void TWI_RandomStatsNoLimit() {
	const int STRDEX = 0;
	const int HP = 0;
	const int MANA = 0;
	
	STRDEX = MEMINT_SwitchG1G2(150, 220);
	HP     = MEMINT_SwitchG1G2(500, 1000);
	MANA   = MEMINT_SwitchG1G2(100, 300);

	var int rnd;
	
	rnd = r_Max(STRDEX);
	hero.attribute[ATR_DEXTERITY] = rnd;

	rnd = r_Max(STRDEX);
	hero.attribute[ATR_STRENGTH] = rnd;

	rnd = r_Max(HP);
	hero.attribute[ATR_HITPOINTS_MAX] = rnd;
	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	rnd = r_Max(MANA);
	hero.attribute[ATR_MANA_MAX] = rnd;
	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	_TWI_UnequipItems_IfStatsTooLow();
};

