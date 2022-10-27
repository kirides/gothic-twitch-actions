

instance _TWI_MEM_C_NPC@(oCNpc);

func int _TWI_MEM_SizeOf_C_NPC() {
    var zCPar_Symbol symbCls; symbCls= _PM_ToClass(_TWI_MEM_C_NPC@);
	
	return symbCls.offset;
};

const int _TWI_Kirides_AllMonsters_Arr = 0;

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

func void _TWI_Kirides_OnNpcInstance(var int i, var int maxLevel) {
	const int npcGuild = 0; npcGuild = _TWI_Kirides_GetGuild(i);
	if ((npcGuild > GIL_SEPERATOR_HUM) && (npcGuild < GIL_SEPERATOR_ORC)) {
		if (_TWI_Kirides_GetLevel(i) > maxLevel) {
			return;
		};

		const string instName = ""; instName = _PM_InstName(i);
		if (_TWI_Kirides_IgnoreInstance(i, instName)) {
			return;
		};

		MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
	};
};

func int _TWI_Kirides_CountAllMonsters(var int maxLevel) {
	if (_TWI_Kirides_AllMonsters_Arr == 0) {
		_TWI_Kirides_AllMonsters_Arr = MEM_ArrayCreate();
	};
	MEM_ArrayClear(_TWI_Kirides_AllMonsters_Arr);

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
			_TWI_Kirides_OnNpcInstance(i, maxLevel);
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);

			if (Hlp_StrCmp(symb.name, "C_NPC")) {
				_TWI_Kirides_OnNpcInstance(i, maxLevel);
			};
		};

		// Reset state after iteration
		MEM_AssignInstSuppressNullWarning = TRUE;
		self  = _^(selfBak);
		MEM_AssignInstSuppressNullWarning = FALSE;
		MEM_SetUseInstance(instBak);
	end;

	MEM_Debug("Done walking the Symbol table");

	MEM_AssignInstSuppressNullWarning = TRUE;
	self  = _^(selfBak);
	MEM_AssignInstSuppressNullWarning = FALSE;
	MEM_SetUseInstance(instBak);
	
	return +MEM_ArraySize(_TWI_Kirides_AllMonsters_Arr);
};

func void _TWI_Kirides_SpawnRandomMonster(var string user, var int amount, var int limitByLevel) {
	const int maxMonsters = -1;
	const int currentChp = 6;
	const int heroLvl = 0;
	const int maxLevel = 999999;

	if (limitByLevel) {
		if (currentChp != Kapitel)
		|| (heroLvl != hero.level)
		{
			heroLvl = hero.level;
			currentChp = Kapitel;
			maxMonsters = -1;

			if      (currentChp < 2 && heroLvl < 8) { maxLevel = 11; }
			else if (currentChp < 3 && heroLvl < 15) { maxLevel = 20; }
			else if (currentChp < 4 && heroLvl < 19) { maxLevel = 29; }
			else if (currentChp < 5) { maxLevel = 35; }
			else                     { maxLevel = 99999; }
			;
		};
	};

	if (maxMonsters == -1) {
		maxMonsters = _TWI_Kirides_CountAllMonsters(maxLevel);
	};
	var int rnd;
	var int inst;

	repeat(i, amount); var int i;
		rnd = Hlp_Random(maxMonsters);

		inst = MEM_ArrayRead(_TWI_Kirides_AllMonsters_Arr, rnd);
		_TWI_Kirides_Spawn_N(user, inst, 1, TRUE, FALSE);
	end;
};


func void TWI_SpawnRandomMonster() {
	var string user; user = TwitchIntegration_User;
	
	var string args; args = TwitchIntegration_Arguments;
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	var int amount;
	
	if (splitCount > 0) { amount = STR_ToInt(STR_Split(args, " ", 0)); }
	else                { amount = 1; };

	_TWI_Kirides_SpawnRandomMonster(user, amount, TRUE);
};

func void TWI_SpawnRandomMonsterNoLimit() {
	var string user; user = TwitchIntegration_User;
	
	var string args; args = TwitchIntegration_Arguments;
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	var int amount;
	
	if (splitCount > 0) { amount = STR_ToInt(STR_Split(args, " ", 0)); }
	else                { amount = 1; };

	_TWI_Kirides_SpawnRandomMonster(user, amount, FALSE);
};


func int _TWI_SpawnItemRandom_CountAll() {
	const int i = 0; i = 0;
	const int current = 0; current = 0;

	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};

        symb = _^(symb.parent);
		var C_NPC npc;
		const int npcGuild = 0;
		if (Hlp_StrCmp(symb.name, "C_ITEM")) {
			current+=1;
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);
			if (Hlp_StrCmp(symb.name, "C_ITEM")) {
				current += 1;
			};
		};
	end;

	return +current;
};

func void TWI_RandomWaypoint() {
	var zCWaynet wayNet; wayNet = MEM_PtrToInst(MEM_World.wayNet);
	var int len; len = List_LengthS(wayNet.wplist_next);
	var int rnd; rnd = Hlp_Random(len);

	var int ptr; ptr = List_GetS(wayNet.wplist_next, rnd);
	var zCWaypoint wp; wp = _^(ptr);

	AI_Teleport(hero, wp.name);
};

func void TWI_SpawnItemRandom() {
	const int i = 0; i = 0;
	const int current = 0; current = 0;
	const int itmIdx = -1; itmIdx = -1;
	const int totalItems = -1;

	if (totalItems == -1) {
		totalItems = _TWI_SpawnItemRandom_CountAll();
	};

	var int rnd; rnd = Hlp_Random(totalItems);

	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_ITEM")) {
			if (current == rnd) {
				itmIdx = i;
				break;
			};
			current+=1;
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);
			if (Hlp_StrCmp(symb.name, "C_ITEM")) {
				if (current == rnd) {
					itmIdx = i;
					break;
				};
				current += 1;
			};
		};
	end;

	if (itmIdx != -1) {
		Wld_InsertItem(itmIdx, Npc_GetNearestWP(hero));
	};
};



func void TWI_RandomStats() {
	const int STRDEX = 0; STRDEX = MEMINT_SwitchG1G2(100, 200);
	const int HP = 0;     HP     = MEMINT_SwitchG1G2(500, 1000);
	const int MANA = 0;   MANA   = MEMINT_SwitchG1G2(80, 250);
	var int rnd;
	
	rnd = Hlp_Random(STRDEX);
	hero.attribute[ATR_DEXTERITY] = rnd;

	rnd = Hlp_Random(STRDEX);
	hero.attribute[ATR_STRENGTH] = rnd;

	rnd = Hlp_Random(HP);
	hero.attribute[ATR_HITPOINTS_MAX] = rnd;

	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	rnd = Hlp_Random(MANA);
	hero.attribute[ATR_MANA_MAX] = rnd;
	if (hero.attribute[ATR_HITPOINTS] > rnd) {
		hero.attribute[ATR_HITPOINTS] = rnd;
	};

	_TWI_UnequipItems_IfStatsTooLow();
};
