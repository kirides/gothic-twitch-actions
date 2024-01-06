

instance _TWI_MEM_C_NPC@(oCNpc);

func int _TWI_MEM_SizeOf_C_NPC() {
    var zCPar_Symbol symbCls; symbCls= _PM_ToClass(_TWI_MEM_C_NPC@);
	
	return symbCls.offset;
};

const int _TWI_Kirides_AllMonsters_Arr = 0;
const int _TWI_Kirides_AllMonstersLimited_Arr = 0;
const int _TWI_Kirides_LimitedMonsters_Arr = 0;

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
		return 1;
	};
	return 0;
};
func void _TWI_Kirides_OnNpcInstance(var int array, var int i, var int maxLevel) {
	const int level = 0; level = +_TWI_Kirides_GetLevel(i);
	if (level > maxLevel) {
		return;
	};

	MEM_ArrayInsert(array, i);
};

const int _TWI_Kirides_AllMonsters_Initialized = 0;

func int _TWI_Kirides_CollectMonsters(var int maxLevel) {
	if (_TWI_Kirides_AllMonsters_Arr == 0) {
		_TWI_Kirides_AllMonsters_Arr = MEM_ArrayCreate();
	};
	if (_TWI_Kirides_AllMonstersLimited_Arr == 0) {
		_TWI_Kirides_AllMonstersLimited_Arr = MEM_ArrayCreate();
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
		const string instName = ""; instName = symb.name;

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_NPC")) {
			if (_TWI_Kirides_NpcIsMonster(i)) {
				
				if (_TWI_Kirides_AllMonsters_Initialized == 0) {
					if (!_TWI_Kirides_IgnoreInstanceNoLimit(i, instName)) {
						MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
					};
				};
				if (!_TWI_Kirides_IgnoreInstance(i, instName)) {
					if (_TWI_Kirides_AllMonsters_Initialized == 0) {
						MEM_ArrayInsert(_TWI_Kirides_AllMonstersLimited_Arr, i);
					};
					_TWI_Kirides_OnNpcInstance(_TWI_Kirides_LimitedMonsters_Arr, i, maxLevel);
				};
			};
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);

			if (Hlp_StrCmp(symb.name, "C_NPC")) {
				if (_TWI_Kirides_NpcIsMonster(i)) {
					if (_TWI_Kirides_AllMonsters_Initialized == 0) {
						if (!_TWI_Kirides_IgnoreInstanceNoLimit(i, instName)) {
							MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
						};
					};
					if (!_TWI_Kirides_IgnoreInstance(i, instName)) {
						if (_TWI_Kirides_AllMonsters_Initialized == 0) {
							MEM_ArrayInsert(_TWI_Kirides_AllMonstersLimited_Arr, i);
						};
						_TWI_Kirides_OnNpcInstance(_TWI_Kirides_LimitedMonsters_Arr, i, maxLevel);
					};
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

			if (GOTHIC_BASE_VERSION == 1) {
				if      (currentChp <= 1 && heroLvl <  5) { maxLevel = _TWI_Math_Min(hero.level+5,  8); }
				else if (currentChp <= 2 && heroLvl < 12) { maxLevel = _TWI_Math_Min(hero.level+5, 12); }
				else if (currentChp <= 3 && heroLvl < 16) { maxLevel = _TWI_Math_Min(hero.level+5, 16); }
				else if (currentChp <= 4 && heroLvl < 19) { maxLevel = _TWI_Math_Min(hero.level+5, 19); }
				else if (currentChp <= 5 && heroLvl < 20) { maxLevel = _TWI_Math_Min(hero.level+5, 24); }
				else                                      { maxLevel = 99999; };
			} else {
				if      (currentChp <= 1 && heroLvl <  5) { maxLevel = _TWI_Math_Max(hero.level+5,  8); }
				else if (currentChp <= 2 && heroLvl < 12) { maxLevel = _TWI_Math_Max(hero.level+5, 12); }
				else if (currentChp <= 3 && heroLvl < 16) { maxLevel = _TWI_Math_Max(hero.level+5, 16); }
				else if (currentChp <= 4 && heroLvl < 19) { maxLevel = _TWI_Math_Max(hero.level+5, 20); }
				else if (currentChp <= 5 && heroLvl < 20) { maxLevel = _TWI_Math_Max(hero.level+5, 25); }
				else                                      { maxLevel = 99999; };
			};
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

func void _TWI_Kirides_ScaleDown(var C_NPC slf, var C_NPC target) {
	if (slf.level <= target.level) { return; };

	const int maxDef = 0; maxDef = _TWI_KIRIDES_SCALING_MAX_DEF;
	const int strDiv = 0; strDiv = _TWI_KIRIDES_SCALING_MIN_STR_DIV;
	const int defDiv = 0; defDiv = _TWI_KIRIDES_SCALING_MIN_DEF_DIV;

	const int slfLevel = 0; slfLevel = _TWI_Math_Clamp(1, slf.level, _TWI_KIRIDES_SCALING_MAX_LVL);

	const int byFrac = 0; byFrac = fracf(target.level, slfLevel);
	const int atrVal = 0;
	if (slf.attribute[ATR_STRENGTH] > 10) {
		atrVal = _TWI_Math_Min(_TWI_KIRIDES_SCALING_MAX_STR, slf.attribute[ATR_STRENGTH]);
		slf.attribute[ATR_STRENGTH] = _TWI_Lerp(byFrac, atrVal / strDiv, atrVal);
	};

	slf.attribute[ATR_HITPOINTS]     = _TWI_Lerp(byFrac, slf.attribute[ATR_HITPOINTS_MAX] / 4, slf.attribute[ATR_HITPOINTS_MAX]);
	slf.attribute[ATR_HITPOINTS_MAX] = slf.attribute[ATR_HITPOINTS];

	const int defVal = 0;
	if (slf.protection[PROT_MAGIC] > 0) { defVal = _TWI_Math_Min(maxDef, slf.protection[PROT_MAGIC]); slf.protection[PROT_MAGIC] = _TWI_Lerp(byFrac, defVal / defDiv, defVal); };
	if (slf.protection[PROT_BLUNT] > 0) { defVal = _TWI_Math_Min(maxDef, slf.protection[PROT_BLUNT]); slf.protection[PROT_BLUNT] = _TWI_Lerp(byFrac, defVal / defDiv, defVal); };
	if (slf.protection[PROT_EDGE]  > 0) { defVal = _TWI_Math_Min(maxDef, slf.protection[PROT_EDGE]);  slf.protection[PROT_EDGE]  = _TWI_Lerp(byFrac, defVal / defDiv, defVal); };
	if (slf.protection[PROT_POINT] > 0) { defVal = _TWI_Math_Min(maxDef, slf.protection[PROT_POINT]); slf.protection[PROT_POINT] = _TWI_Lerp(byFrac, defVal / defDiv, defVal); };
	if (slf.protection[PROT_FIRE]  > 0) { defVal = _TWI_Math_Min(maxDef, slf.protection[PROT_FIRE]);  slf.protection[PROT_FIRE]  = _TWI_Lerp(byFrac, defVal / defDiv, defVal); };

	slf.level = _TWI_Lerp(byFrac, target.level, slfLevel);
	if (slf.level < 1) { slf.level = 1; };

	var float byFracF; byFracF = castFromIntf(_TWI_LerpF(byFrac, fracf(80, 100), FLOATONE));
	Mdl_SetModelScale(slf, byFracF, byFracF, byFracF);
};


func void _TWI_Kirides_SpawnRandomMonsterScaled(var string user, var int amount) {
	const int maxMonsters = -1;
	const int usedArray = 0;

	if (!_TWI_Kirides_AllMonsters_Initialized) {
		_TWI_Kirides_CollectMonsters(1);
	};
	// usedArray = _TWI_Kirides_AllMonsters_Arr;
	usedArray = _TWI_Kirides_AllMonstersLimited_Arr;

	maxMonsters = MEM_ArraySize(usedArray);
	var int rnd;
	var int inst;

	repeat(i, amount); var int i;
		rnd = r_Next()%maxMonsters;

		inst = MEM_ArrayRead(usedArray, rnd);
		_TWI_Kirides_Spawn_N(user, inst, 1, TRUE, FALSE);

		var C_NPC spawned; spawned = Hlp_GetNpc(inst);
		_TWI_Kirides_ScaleDown(spawned, hero);
	end;
};

func void _TWI_Rtn_Sleeper() {
	TA_Min(self,24,00,06,00, ZS_MM_AllScheduler, self.wp);
	TA_Min(self,06,00,24,00, ZS_MM_AllScheduler, self.wp);
};

func void _TWI_SpawnSleeper() {
	// _TWI_Kirides_Spawn_N("player", Sleeper, 1, TRUE, FALSE);
	// var C_NPC npc; npc = Hlp_GetNpc(Sleeper);
	// npc.wp = Npc_GetNearestWP(npc);
	// _TWI_Kirides_ScaleDown(npc, hero);
	// Mdl_SetModelScale(npc, 0.25, 0.25, 0.25);

	// _TWI_ChangeRoutine(npc, "_TWI_Rtn_Sleeper");
	// npc.aivar[AIV_MM_RestStart] = OnlyRoutine;
	// npc.aivar[AIV_MM_Behaviour] = HUNTER;
	// npc.fight_tactic = FAI_MINECRAWLER;
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

func void TWI_SpawnRandomMonsterScaled() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;

	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount <= 0) { amount = 1; };

	_TWI_Kirides_SpawnRandomMonsterScaled(user, amount);
};

const int _TWI_SpawnItemRandom_Array = 0;

func int _TWI_Filter_Items(var string itemInst) {
	// DEV Items G2
	if Hlp_StrCmp(itemInst, "ItPo_Story") // Macht, daß es weitergeht bei Raven Video I
	|| Hlp_StrCmp(itemInst, "Armor")      // Ein Beutel voller Rüstungen!
	|| Hlp_StrCmp(itemInst, "Runenbrief")
	|| Hlp_StrCmp(itemInst, "EnterBanditCamp") // Komm ins BanditCamp
	|| Hlp_StrCmp(itemInst, "PH")           // Gimme Magic
	|| Hlp_StrCmp(itemInst, "Hosh4")        // Greg ist Back
	|| Hlp_StrCmp(itemInst, "J2")           // Greg_Taverne
	|| Hlp_StrCmp(itemInst, "J3")           // ADW_ADANOSTEMPEL_RemovedFocus
	|| Hlp_StrCmp(itemInst, "J4")           // ADW_PIRATES_RemovedFocus und letzte
	|| Hlp_StrCmp(itemInst, "DJG_inserten") // JOLY_Storyhelpletter
	|| Hlp_StrCmp(itemInst, "JOLY_ITEM")    // Compiling Visual Dummy item
	|| Hlp_StrCmp(itemInst, "JI1")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI2")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI3")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI4")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI5")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI6")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI7")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI8")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI9")   // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI10")  // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI11")  // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI12")  // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "JI13")  // ADDON_PLANTS_...
	|| Hlp_StrCmp(itemInst, "MobsiBrief")
	|| Hlp_StrCmp(itemInst, "ItSe_Addon_Sack")  // Der Sack ist voller neuer Waffen!
	|| Hlp_StrCmp(itemInst, "ItFo_TestTrigger") // Trigger die Adw
	// Duplicated items / Game Breaking items
	|| Hlp_StrCmp(itemInst, "ItMi_InnosEye_Broken_Mis")
	|| Hlp_StrCmp(itemInst, "ItMi_InnosEye_MIS")
	|| Hlp_StrCmp(itemInst, "ItMi_InnosEye_Discharged_Mis")
	|| Hlp_StrCmp(itemInst, "ItMi_InnosEye_Broken_Mis")
	|| Hlp_StrCmp(itemInst, "ItMi_PortalRing_Addon")
	|| Hlp_StrCmp(itemInst, "ItMi_Ornament_Addon")
	|| Hlp_StrCmp(itemInst, "ItMi_Ornament_Addon_Vatras")
	|| Hlp_StrCmp(itemInst, "Holy_Hammer_MIS")
	|| Hlp_StrCmp(itemInst, "ItWr_Schuldenbuch")
	|| Hlp_StrCmp(itemInst, "ItRi_Ranger_Lares_Addon")
	|| Hlp_StrCmp(itemInst, "ItSe_GoldPocket100_Greg")  // Gregs treasure
	|| Hlp_StrCmp(itemInst, "ItMi_GoldCup_Greg")        // Gregs treasure
	|| Hlp_StrCmp(itemInst, "ItMi_SilverChalice_Greg")  // Gregs treasure
	|| Hlp_StrCmp(itemInst, "ItAm_Prot_Point_01_Greg")  // Gregs treasure
	|| Hlp_StrCmp(itemInst, "ItMi_Addon_Bloodwyn_Kopf")
	|| Hlp_StrCmp(itemInst, "ITWR_Addon_GregsLogbuch_Mis")
	|| Hlp_StrCmp(itemInst, "ItRw_Bow_L_03_MIS")    // Bospers Bogen
	|| Hlp_StrCmp(itemInst, "ItMi_CoragonsSilber")  // Coragorns Silber
	// Klaue Beliars
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_Raven")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_02")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_03")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_04")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_05")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_06")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_07")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_08")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_09")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_10")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_11")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_12")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_13")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_14")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_15")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_16")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_17")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_18")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_19")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_1H_20")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_02")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_03")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_04")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_05")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_06")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_07")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_08")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_09")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_10")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_11")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_12")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_13")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_14")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_15")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_16")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_17")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_18")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_19")
	|| Hlp_StrCmp(itemInst, "ItMw_BeliarWeapon_2H_20")

	// DEV ITEM G1
	|| Hlp_StrCmp(itemInst, "Lester_Bugfixbook") // Schicke Lester nach Hause
	|| Hlp_StrCmp(itemInst, "Lukor_Bugfixbook")  // Zwinge Baal Lukor in den Followmode
	|| Hlp_StrCmp(itemInst, "ItWrLevelMap")      // Map of Test Level
	|| Hlp_StrCmp(itemInst, "ItWrBookOfTales")   // Book of Tales
	// || Hlp_StrCmp(itemInst, "ItMw1hSwordBurning") // Legendary short sword of burning
	// || Hlp_StrCmp(itemInst, "ItMw2hSwordBurning") // Legendary heavy sword of burning
	// || Hlp_StrCmp(itemInst, "ItRwWarBowBurning")  // Legendary bow of burning
	// || Hlp_StrCmp(itemInst, "ItArRobeMithril")    // Ledengary mithril robe
	{
		return 0;
	};

	return 1;
};

func int _TWI_SpawnItemRandom_CollectAll() {
	var int array; array = MEM_ArrayCreate();
	const int i = 0; i = 0;
	var string itemName;
	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};
		itemName = symb.name;

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_ITEM")) {
			if (_TWI_Filter_Items(itemName)) {
				MEM_ArrayPush(array, i);
			};
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);
			if (Hlp_StrCmp(symb.name, "C_ITEM")) {
				if (_TWI_Filter_Items(itemName)) {
					MEM_ArrayPush(array, i);
				};
			};
		};
	end;

	return +array;
};

func int TWI_RandomWaypoint() {
	if (!InfoManager_Hasfinished()) { return 0; };

	var zCWaynet wayNet; wayNet = MEM_PtrToInst(MEM_World.wayNet);
	var int len; len = List_LengthS(wayNet.wplist_next);
	var int rnd; rnd = r_Next()%len;

	var int ptr; ptr = List_GetS(wayNet.wplist_next, rnd);
	var zCWaypoint wp; wp = _^(ptr);

	AI_Teleport(hero, wp.name);

	return 1;
};

func void TWI_SpawnItemRandom() {
	if (_TWI_SpawnItemRandom_Array == 0) {
		_TWI_SpawnItemRandom_Array = +_TWI_SpawnItemRandom_CollectAll();
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
		_TWI_InsertItemNpc(hero, itmIdx);
	};
};

const int _TWI_SpawnRandomItemNoArmorWeapons_Array = 0;
func int _TWI_SpawnRandomItemNoArmorWeapons_CollectAll() {
	if (_TWI_SpawnItemRandom_Array == 0) {
		_TWI_SpawnItemRandom_Array = +_TWI_SpawnItemRandom_CollectAll();
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
		_TWI_InsertItemNpc(hero, itmIdx);
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

	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "STR", IntToString(hero.attribute[ATR_STRENGTH]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "DEX", IntToString(hero.attribute[ATR_DEXTERITY]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "HP", IntToString(hero.attribute[ATR_HITPOINTS_MAX]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "MANA", IntToString(hero.attribute[ATR_MANA_MAX]));

	_TWI_Snd_Play("LEVELUP");
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
	if (hero.attribute[ATR_MANA] > rnd) {
		hero.attribute[ATR_MANA] = rnd;
	};

	_TWI_UnequipItems_IfStatsTooLow();

	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "STR", IntToString(hero.attribute[ATR_STRENGTH]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "DEX", IntToString(hero.attribute[ATR_DEXTERITY]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "HP", IntToString(hero.attribute[ATR_HITPOINTS_MAX]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "MANA", IntToString(hero.attribute[ATR_MANA_MAX]));

	_TWI_Snd_Play("LEVELUP");
};

func void TWI_RandomStatsPool() {
	var int pool;

	pool = 0;
	pool = pool + hero.attribute[ATR_STRENGTH];
	pool = pool + hero.attribute[ATR_DEXTERITY];
	pool = pool + hero.attribute[ATR_MANA_MAX];

	var int rnd;
	rnd = r_MinMax(10, pool-10);
	hero.attribute[ATR_STRENGTH] = rnd;
	pool = pool - rnd;

	rnd = r_MinMax(10, +pool);
	hero.attribute[ATR_DEXTERITY] = rnd;
	pool = pool - rnd;

	rnd = +pool;
	if (pool < 0) {
		MEM_Warn(ConcatStrings("TWI_RandomStatsPool: Stats pool not drained correctly, remainder: ", IntToString(pool)));
	};
	hero.attribute[ATR_MANA_MAX] = rnd;
	if (hero.attribute[ATR_MANA] > rnd) {
		hero.attribute[ATR_MANA] = rnd;
	};
	pool = pool - rnd;


	_TWI_UnequipItems_IfStatsTooLow();

	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "STR", IntToString(hero.attribute[ATR_STRENGTH]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "DEX", IntToString(hero.attribute[ATR_DEXTERITY]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "MANA", IntToString(hero.attribute[ATR_MANA_MAX]));
	MEM_SetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "HP", IntToString(hero.attribute[ATR_HITPOINTS_MAX]));

	_TWI_RandomTalentsPool_GameSpecific();

	_TWI_Snd_Play("LEVELUP");
};



func void TWI_RandomHP_Pct() {
	if (STR_SplitCount(TwitchIntegration_Arguments, " ") < 2) {
		MEM_InfoBox(ConcatStrings("Too few arguments, expected 'TWI_RandomHP min max' got: TWI_RandomHP ", TwitchIntegration_Arguments));
		return;
	};

	var int min; min = STR_ToInt(STR_Split(TwitchIntegration_Arguments, " ", 0));
	var int max; max = STR_ToInt(STR_Split(TwitchIntegration_Arguments, " ", 1));
	if (max > 100) { max = 100; };
	if (max < 0) { max = 1; };
	if (min < 0) { min = 0; };
	if (min > 100) { min = 1; };
	var int rnd; rnd = r_MinMax(min, max);

	var int val;
	val = roundf(
			mulf(
				divf(mkf(hero.attribute[ATR_HITPOINTS_MAX]), mkf(100)),
				mkf(rnd)));
	if (hero.attribute[ATR_HITPOINTS] != val) {
		hero.attribute[ATR_HITPOINTS] = val;
	};
};


func void TWI_RandomStats_OnInit() {
	if (MEM_GothOptExists(_TWI_KIRIDES_SECT_RANDSTATS, "STR")) {
		var int str;   str = STR_ToInt(MEM_GetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "STR"));
		var int dex;   dex = STR_ToInt(MEM_GetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "DEX"));
		var int hp;     hp = STR_ToInt(MEM_GetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "HP"));
		var int mana; mana = STR_ToInt(MEM_GetGothOpt(_TWI_KIRIDES_SECT_RANDSTATS, "MANA"));

		hero.attribute[ATR_DEXTERITY] = dex;
		hero.attribute[ATR_STRENGTH] = str;
		hero.attribute[ATR_HITPOINTS_MAX] = hp;
		if (hero.attribute[ATR_HITPOINTS] > hp) {
			hero.attribute[ATR_HITPOINTS] = hp;
		};
		hero.attribute[ATR_MANA_MAX] = mana;
		if (hero.attribute[ATR_MANA] > mana) {
			hero.attribute[ATR_MANA] = mana;
		};
	};
};


func void TWI_RandomTalents() {
	_TWI_RandomTalents_GameSpecific();
};

func void TWI_RandomTalents_OnInit() {
	_TWI_RandomTalent_GameSpecific_OnInit();
};

func void TWI_RandomTalent() {
	_TWI_RandomTalent_GameSpecific();
};
