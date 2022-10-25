func void TWI_ZS_Bandit () {
	//-------- Wahrnehmungen --------
	B_SetPerception			(self);
	self.senses = 			SENSE_SEE|SENSE_HEAR|SENSE_SMELL;

	//-------- Vorbereitungen --------
	if (Npc_HasReadiedWeapon(self)) {
		AI_SetWalkmode(self, NPC_RUN);
	} else {
		AI_SetWalkmode(self, NPC_WALK);
	};
	
	//-------- Grobpositionierung --------
	if (!STR_Compare(self.wp, "")) {
		self.wp = Npc_GetNearestWP(self);
	};
	AI_GotoWP(self,	self.wp); // Gehe zum Tagesablaufstart
	AI_AlignToWP(self);
};

func void TWI_ZS_Bandit_loop () {
	AI_Wait(self,	1);
};

func void TWI_ZS_Bandit_end () {
	self.senses	= hero.senses;
	C_StopLookAt(self);
};

const int TWI_GIL_BDT = GIL_ZOMBIE;

instance TWI_BDT_1_Bandit_L (Npc_Default)
{
	name 		= "Räuber"; 
	guild 		= TWI_GIL_BDT;
	id 			= 99991000;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_ROGUE;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 1);
	fight_tactic		= FAI_HUMAN_COWARD;
	EquipItem			(self, ItMw_1H_Mace_03);
	EquipItem			(self, ItRw_Bow_Long_02);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Fatbald", 6, 3, ORG_ARMOR_H);	
	Mdl_SetModelFatness	(self, 0);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_2_Bandit_L (Npc_Default)
{
	name 		= "Herumtreiber"; 
	guild 		= TWI_GIL_BDT;
	id 			= 999910001;
	voice 		= 3;
	flags       = 0;
	npctype		= NPCTYPE_ROGUE;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 1);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1H_Mace_01);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Thief", 9, 1, ORG_ARMOR_L);	
	Mdl_SetModelFatness	(self, 0);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_3_Bandit_L (Npc_Default)
{
	name 		= "Bandit"; 
	guild 		= TWI_GIL_BDT;
	id 			= 99991003;
	voice 		= 4;
	flags       = 0;
	npctype		= NPCTYPE_ROGUE;

	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 1);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1H_Mace_02);
	EquipItem			(self, ItRw_Bow_Long_01);
	TWI_Kirides_SetNpcVisual (self, MALE, "Hum_Head_FatBald", 35, 2, ORG_ARMOR_M);	
	Mdl_SetModelFatness	(self, 1);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_4_Bandit_L (Npc_Default)
{
	name 		= "Gauner"; 
	guild 		= TWI_GIL_BDT;
	id 			= 99991000;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_ROGUE;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 1);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1H_Mace_02);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Fatbald", 37, 1, ORG_ARMOR_M);	
	Mdl_SetModelFatness	(self, 1);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};