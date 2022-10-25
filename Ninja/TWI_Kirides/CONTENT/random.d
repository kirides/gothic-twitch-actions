

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
	|| Hlp_StrCmp(instName, "PC_ROCKEFELLER")
	|| (i == Hlp_GetInstanceId(hero))
	) {
		MEM_Debug("Skip");
		return 1;
	};

	if (STR_IndexOf(instName, "TESTMODELL") > 0)
	|| (STR_IndexOf(instName, "_TEST_") > 0)
	|| (STR_IndexOf(instName, "_HELPER_") > 0)
	{
		MEM_Debug("Skip Testmodell");
		return 1;
	};

	return 0;
};

/*

func void _TWI_Kirides_OnNpcInstance(var int i, var int npcPtr) {
	const string instName = ""; instName = _PM_InstName(i);

	MEM_Debug(ConcatStrings("NPC: ", instName));
	if (_TWI_Kirides_IgnoreInstance(i, instName)) {
		return;
	};

	Wld_InsertNpc(i, "?????????");
	Hlp_GetNpc(i);

	var C_NPC npc; npc = _^(npcPtr);
	self = _^(npcPtr);
	MEM_CallByID(i);

	const int npcGuild = 0; npcGuild = npc.guild;
	if ((npcGuild > GIL_SEPERATOR_HUM) && (npcGuild < GIL_SEPERATOR_ORC)) {
		MEM_Debug(ConcatStrings("NPC pushed: ", instName));
		MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
	};
};
*/

func void _TWI_Kirides_OnNpcInstance(var int i, var int npcPtr) {
	const string instName = ""; instName = _PM_InstName(i);

	// MEM_Debug(ConcatStrings("NPC: ", instName));
	
	if (_TWI_Kirides_IgnoreInstance(i, instName)) {
		return;
	};

	Wld_InsertNpc(i, "?????????");
	var C_NPC npc; npc = Hlp_GetNpc(i);

	const int npcGuild = 0; npcGuild = npc.guild;
	if ((npcGuild > GIL_SEPERATOR_HUM) && (npcGuild < GIL_SEPERATOR_ORC)) {
		// MEM_Debug(ConcatStrings("NPC pushed: ", instName));
		MEM_ArrayInsert(_TWI_Kirides_AllMonsters_Arr, i);
	};

	Npc_ChangeAttribute	(npc, ATR_HITPOINTS, -npc.attribute[ATR_HITPOINTS_MAX]);
};

func int _TWI_Kirides_CountAllMonsters() {
	if (_TWI_Kirides_AllMonsters_Arr == 0) {
		_TWI_Kirides_AllMonsters_Arr = MEM_ArrayCreate();
	};

	const int i = 0; i = 0;
	const int npcPtrSize = 0; npcPtrSize = _TWI_MEM_SizeOf_C_NPC();
	MEM_Debug(ConcatStrings("Allocating Bytes: ", IntToString(npcPtrSize)));

	const int npcPtr = 0; npcPtr = MEM_Alloc(npcPtrSize);
	if (final()) { MEM_Free(npcPtr); };

	var int selfBak;  selfBak  = _@(self);
	var int instBak; instBak = MEM_GetUseInstance();


	if (zCParser_CreateInstance(_TWI_MEM_C_NPC@, npcPtr) == 0) 
	{
		MEM_Info("Instanz konnte nicht erzeugt werden!");
		return 0;
	};

	MEM_Debug("Walking the Symbol table");

	repeat(i, MEM_Parser.symtab_table_numInArray);
		var zCPar_Symbol symb; symb = _^(MEM_ReadIntArray(MEM_Parser.symtab_table_array, i));

		if ((symb.bitfield & zCPar_Symbol_bitfield_type) != zPAR_TYPE_INSTANCE || STR_IndexOf(symb.name, ".") > 0 || !symb.parent) {
			continue;
		};

        symb = _^(symb.parent);
		if (Hlp_StrCmp(symb.name, "C_NPC")) {
			_TWI_Kirides_OnNpcInstance(i, npcPtr);
		}
		else if (symb.parent && (symb.bitfield & zCPar_Symbol_bitfield_type) == zPAR_TYPE_PROTOTYPE) {
			symb = _^(symb.parent);

			if (Hlp_StrCmp(symb.name, "C_NPC")) {
				_TWI_Kirides_OnNpcInstance(i, npcPtr);
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

func void _TWI_Kirides_SpawnRandomMonster(var string user, var int amount) {
	const int maxMonsters = -1;
	if (maxMonsters == -1) {
		maxMonsters = _TWI_Kirides_CountAllMonsters();
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

	_TWI_Kirides_SpawnRandomMonster(user, amount);
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
