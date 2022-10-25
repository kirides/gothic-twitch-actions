

func void TWI_Kirides_CallOnNpc(var c_npc slf, var string fnc) {
	const int fnId = -1;
	fnId = MEM_FindParserSymbol(fnc);
	if (fnId != -1) {
		var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
		self = MEM_CpyInst(slf);

		MEM_PushInstParam(slf);
		MEM_CallByID(fnId);

		self = MEM_CpyInst(oldSlf);
	};
};

func void TWI_Kirides_CallOnNpc_I(var c_npc slf, var string fnc, var int value) {
	const int fnId = -1;
	fnId = MEM_FindParserSymbol(fnc);
	if (fnId != -1) {
		var C_NPC oldSlf; oldSlf = MEM_CpyInst(self);
		self = MEM_CpyInst(slf);

		MEM_PushInstParam(slf);
		MEM_PushIntParam(value);
		MEM_CallByID(fnId);

		self = MEM_CpyInst(oldSlf);
	};
};

// func int TWI_Kirides_RandomRange() {
// 	return (Hlp_Random(1000) + 500);
// };
func void TWI_Kirides_Npc_SetPermAttitude(var C_NPC npc, var int att) {
	TWI_Kirides_CallOnNpc_I(npc, "Npc_SetTempAttitude", att);
	TWI_Kirides_CallOnNpc_I(npc, "Npc_SetAttitude", att);
};

func void _TWI_Kirides_MakeNpcEnemy(var C_NPC npc) {
	TWI_Kirides_Npc_SetPermAttitude(npc, ATT_HOSTILE);
	Npc_SetTarget(npc, hero);

	if (GOTHIC_BASE_VERSION == 1) {
		Npc_ClearAiQueue(npc);
		AI_StandUpQuick		(npc);
		AI_StartState		(npc, ZS_ATTACK, 1, "");
	} else {
		// ------ wenn der NSC schon in ZS_Attack ist ------
		if (Npc_IsInState (npc, ZS_Attack)) { return; };
		TWI_Kirides_CallOnNpc(npc, "B_ClearPerceptions");
		AI_StartState		(npc, ZS_ATTACK, 1, "");
	};
};

func void _TWI_Kirides_Spawn_N(var string user, var int inst, var int amount, var int isEnemy, var int immortal) {

	repeat(i, amount); var int i;
		Wld_SpawnNpcRange(hero, inst, 1, 1000);
		var C_NPC npc; npc = Hlp_GetNpc(inst);
		npc.name = ConcatStrings(npc.name, ConcatStrings(" (", ConcatStrings(user, ")")));
		if (isEnemy) { _TWI_Kirides_MakeNpcEnemy(npc); };
		if (immortal) { npc.flags = npc.flags | NPC_FLAG_IMMORTAL; };
	end;
};

func void _TWI_Kirides_SpawnNamed_N(var string user, var int inst, var string name, var int amount, var int isEnemy) {

	repeat(i, amount); var int i;
		Wld_SpawnNpcRange(hero, inst, 1, 1000);
		var C_NPC npc; npc = Hlp_GetNpc(inst);
		npc.name = ConcatStrings(name, ConcatStrings(" (", ConcatStrings(user, ")")));

		if (isEnemy) { _TWI_Kirides_MakeNpcEnemy(npc); };
	end;
};

func void TWI_Kirides_Spawn(var string user, var int inst) {
	_TWI_Kirides_Spawn_N(user, inst, 1, 1, 0);
};


func void TWI_Kirides_UnpackAllItems(var C_NPC npc) {
	const int oCNpcInventory_UnpackAllItems_G2 = 7405616; // 00710030
	
	var oCNpc ownerNpc; ownerNpc = MEM_CpyInst(npc);
	const int inventory = 0; inventory = _@(ownerNpc.inventory2_vtbl);
	if (inventory == 0) { return; };

	const int call = 0;
	if (CALL_Begin(call)) {
		CALL__thiscall(_@(inventory), oCNpcInventory_UnpackAllItems_G2);
		call = CALL_End();
	};
};

func void TWI_Kirides_SetNpcVisual(var C_NPC slf, var int gender, var string headMesh, var int faceTex, var int bodyTex, var int armorInstance)
{
	var int aivGender; aivGender = MEM_GetSymbol("AIV_Gender");
    if (aivGender) {
        var zCPar_Symbol aivGenderSymb; aivGenderSymb = _^(aivGender);
		MEM_WriteStatArr(_@(slf.aivar), aivGenderSymb.content, gender);
	};

	// ------ Anis - für Männer und Frauen gleich (Unterschiede werden ggf. durch Ani-Overlays gemacht ------
	Mdl_SetVisual (slf,"HUMANS.MDS");

	if (gender == MALE)
	{
		// ------ Visual ------ "body_Mesh",		bodyTex		SkinColor	headMesh,	faceTex,	teethTex,	armorInstance	
		Mdl_SetVisualBody (slf,	"hum_body_Naked0", 	bodyTex,	0,			headMesh, 	faceTex,	0, 			armorInstance);
		
		// ------ schwache NSCs sind schmal ------
		if (slf.attribute[ATR_STRENGTH] < 50)
		{
			Mdl_SetModelScale		(slf, 0.9, 1, 1); 			//BREITE / Höhe / Tiefe
		};

		// ------ starke NSCs sind breit ------
		if (slf.attribute[ATR_STRENGTH] > 100)
		{
			Mdl_SetModelScale		(slf, 1.1, 1, 1);			//BREITE / Höhe / Tiefe
		};
	}
	else //gender == FEMALE
	{
		if (bodyTex >= 0) && (bodyTex <= 3) //MännerBodyTex angegeben
		{
			bodyTex = bodyTex + 4; // Females haben Variation 4-7 (Males 0-3)
		};
		
		// ------ Visual ------	"Bab_body_Mesh",	bodyTex		SkinColor	headMesh,	faceTex,	teethTex,	armorInstance		
		Mdl_SetVisualBody (slf,	"Hum_Body_Babe0", 	bodyTex,	0,			headMesh, 	faceTex,  	0,			armorInstance);
	};
};

func void TWI_Kirides_SetAttributesToChapter(var C_NPC slf, var int chapter) {
	Npc_SetTalentSkill (slf, NPC_TALENT_MAGE, 6);
	const int lvl = 0;
	
	if      (chapter > 5) { lvl = 30; }
	else if (chapter > 4) { lvl = 25; }
	else if (chapter > 3) { lvl = 20; }
	else if (chapter > 2) { lvl = 15; }
	else if (chapter > 1) { lvl = 10; }
	else                  { lvl =  5; };


	if (lvl <= 0) {
		lvl = 3;
	};
	slf.level = lvl;//nicht 0 wegen XP (10 * Level)

	const int chptMAIN = 20;
	const int chptHP   = 70;

	if      (chapter == 0) { chptMAIN =  20; chptHP =  70; }
	else if (chapter == 1) { chptMAIN =  50; chptHP = 160; }
	else if (chapter == 2) { chptMAIN = 100; chptHP = 280; }
	else if (chapter == 3) { chptMAIN = 125; chptHP = 400; }
	else if (chapter == 4) { chptMAIN = 150; chptHP = 520; }
	else if (chapter == 5) { chptMAIN = 175; chptHP = 640; }
	else               { chptMAIN = 200; chptHP = 760; };

	slf.attribute[ATR_STRENGTH] 		= chptMAIN;
	slf.attribute[ATR_DEXTERITY] 		= chptMAIN;

	slf.attribute[ATR_MANA_MAX] 		= 1000;
	slf.attribute[ATR_MANA] 			= 1000;
	slf.attribute[ATR_HITPOINTS_MAX] 	= chptHP;
	slf.attribute[ATR_HITPOINTS] 		= chptHP;
	
	
	// ------ XP für NSCs ------
	slf.exp				= (500*((slf.level+1)/2)*(slf.level+1));
	slf.exp_next		= (500*((slf.level+2)/2)*(slf.level+1));
};

func void TWI_Kirides_TrySetupNpc(var C_NPC slf, var int chapter, var int fightSkills) {

	TWI_Kirides_SetAttributesToChapter(slf, chapter);

	if (GOTHIC_BASE_VERSION == 1) {
		Npc_SetTalentSkill (slf, NPC_TALENT_BOW, fightSkills);
		Npc_SetTalentSkill (slf, NPC_TALENT_1H, fightSkills);
		Npc_SetTalentSkill (slf, NPC_TALENT_2H, fightSkills);
		Npc_SetTalentSkill (slf, NPC_TALENT_CROSSBOW, fightSkills);
		return;
	};
	TWI_Kirides_CallOnNpc(slf, "B_CreateAmbientInv");
	TWI_Kirides_CallOnNpc_I(slf, "B_SetFightSkills", fightSkills);
};

func void _TWI_SpawnNpc(var string user, var string args, var int isEnemy, var int immortal) {
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	if (splitCount == 0) { return; };

	var string id;
	var int amount;

	id = STR_Split(args, " ", 0);
	if (splitCount > 1) { 
		amount = STR_ToInt(STR_Split(args, " ", 1));
	} else {
		amount = 1;
	};

	const int instId = 0; instId = MEM_FindParserSymbol(id);
	if (instId == -1) {
		Print(ConcatStrings("Can not spawn: ", id));
		return;
	};

	_TWI_Kirides_Spawn_N(user, instId, amount, isEnemy, immortal);
};


func void TWI_SpawnEnemy() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;
	_TWI_SpawnNpc(user, args, TRUE, FALSE);
};

func void TWI_SpawnNpc() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;
	_TWI_SpawnNpc(user, args, FALSE, FALSE);
};

func void TWI_SpawnNpcImmortal() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;
	_TWI_SpawnNpc(user, args, FALSE, TRUE);
};

func void TWI_SpawnNpcNamed() {
	var string user; user = TwitchIntegration_User;
	var string args; args = TwitchIntegration_Arguments;

	var int splitCount; splitCount = STR_SplitCount(args, " ");
	if (splitCount < 3) { return; };

	var string name;   name = STR_Split(args, " ", 0);
	var string id;       id = STR_Split(args, " ", 1);
	var int amount;  amount = STR_ToInt(STR_Split(args, " ", 2));

	const int instId = 0; instId = MEM_FindParserSymbol(id);
	if (instId == -1) {
		Print(ConcatStrings("Can not spawn: ", id));
		return;
	};

	_TWI_Kirides_SpawnNamed_N(user, instId, name, amount, 0);
};

func void _TWI_SpawnOneOf(var string user, var string args, var int isEnemy) {
	var int splitCount; splitCount = STR_SplitCount(args, " ");
	if (splitCount == 0) { return; };

	var int rnd; rnd = Hlp_Random(splitCount);

	const string id = ""; id = STR_Split(args, " ", rnd);
	const int instId = 0; instId = MEM_FindParserSymbol(id);

	if (instId == -1) {
		Print(ConcatStrings("Can not spawn: ", id));
		return;
	};

	_TWI_Kirides_Spawn_N(user, instId, 1, isEnemy, FALSE);
};

func void TWI_SpawnNpcOneOf() {
	const string user = ""; user = TwitchIntegration_User;
	const string args = ""; args = TwitchIntegration_Arguments;

	_TWI_SpawnOneOf(user, args, 0);
};

func void TWI_SpawnEnemyOneOf() {
	const string user = ""; user = TwitchIntegration_User;
	const string args = ""; args = TwitchIntegration_Arguments;

	_TWI_SpawnOneOf(user, args, 1);
};
