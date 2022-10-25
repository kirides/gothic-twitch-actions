// ***************************************
// ZS_Bandit
// ---------
// Für Zustandsgesteuerte Banditen
// Wenn FP_Campfire, sitzen, sonst stehen.
// ***************************************

func void TWI_ZS_Bandit()
{	
	Perception_Set_Normal();
	
	// B_ResetAll
	// B_StopLookAt
	// ------ NSC hört ggf. auf zu glotzen ------
	var C_NPC target; target = Npc_GetLookAtTarget(self);
	
	if (Hlp_IsValidNpc(target))
	{
		AI_StopLookAt (self);
	};
	// ^B_StopLookAt
	
	// ------ NSC steckt ggf. Waffe weg ------
	AI_RemoveWeapon (self);
	// ^B_ResetAll

	AI_SetWalkmode 	(self, NPC_WALK);		
	
	if (!STR_Compare(self.wp, "")) {
		self.wp = Npc_GetNearestWP(self);
	};
	if (Npc_GetDistToWP (self,self.wp) > TA_DIST_SELFWP_MAX) {
		AI_GotoWP	(self, self.wp);
	};
	self.aivar[AIV_TAPOSITION] = NOTINPOS;
};

func int TWI_ZS_Bandit_loop()
{
	if (self.aivar[AIV_TAPOSITION] == NOTINPOS)
	{
		if (!Npc_IsOnFP (self, "CAMPFIRE"))
		&& (Wld_IsFPAvailable(self,"CAMPFIRE"))
		{
			AI_GotoFP 		(self, "CAMPFIRE");
			AI_AlignToFP 	(self);
			AI_PlayAniBS 	(self,"T_STAND_2_SIT",BS_SIT);
		}
		else if (!Npc_IsOnFP (self, "STAND"))
		&& (Wld_IsFPAvailable(self,"STAND"))
		{
			AI_GotoFP 		(self, "STAND");
			AI_AlignToFP 	(self);
			AI_PlayAni 		(self,"T_STAND_2_HGUARD");
		}
		else //kein FP gefunden, auf WP stehen
		{
			AI_AlignToWP	(self);
			AI_PlayAni 		(self,"T_STAND_2_HGUARD");
		};
		
		self.aivar[AIV_TAPOSITION] = ISINPOS;
	};		
	
	if (Npc_GetStateTime(self) > 5)
	&& (self.aivar[AIV_TAPOSITION] == ISINPOS)
	&& (!C_BodyStateContains (self, BS_SIT))
	{
		var int random;	random = r_Max(2);
		
		if (random == 0) {
			 AI_PlayAni (self,"T_HGUARD_LOOKAROUND");
		};
		
		Npc_SetStateTime (self, 0);
	};
	
	return LOOP_CONTINUE;
};

func void TWI_ZS_Bandit_end()
{
	if (C_BodyStateContains (self, BS_SIT)) {
		AI_PlayAniBS(self,"T_SIT_2_STAND",BS_STAND);
	} else { AI_PlayAni (self,"T_HGUARD_2_STAND"); };
};

instance TWI_BDT_1_Bandit_L (Npc_Default)
{
	name 		= "Herumtreiber"; 
	guild 		= GIL_BDT;
	id 			= 99991000;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_AMBIENT;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 30);
	fight_tactic		= FAI_HUMAN_COWARD;
	EquipItem			(self, ItMw_1h_Bau_Mace);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Fatbald", Face_N_Mud, BodyTex_N, ITAR_Leather_L);	
	Mdl_SetModelFatness	(self, 0);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_2_Bandit_L (Npc_Default)
{
	name 		= "Herumtreiber"; 
	guild 		= GIL_BDT;
	id 			= 999910001;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_AMBIENT;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 2, 30);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1h_Bau_Mace);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Fatbald", Face_N_Mud, BodyTex_N, ITAR_Leather_L);	
	Mdl_SetModelFatness	(self, 0);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_3_Bandit_L (Npc_Default)
{
	name 		= "Bandit"; 
	guild 		= GIL_BDT;
	id 			= 99991003;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_AMBIENT;

	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 3, 40);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1h_VLK_Sword);
	EquipItem			(self, ItRw_SLD_Bow);
	TWI_Kirides_SetNpcVisual (self, MALE, "Hum_Head_FatBald", Face_N_Normal02, BodyTex_N, ITAR_BDT_M);	
	Mdl_SetModelFatness	(self, 1);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};

instance TWI_BDT_4_Bandit_L (Npc_Default)
{
	name 		= "Gauner"; 
	guild 		= GIL_BDT;
	id 			= 99991000;
	voice 		= 1;
	flags       = 0;
	npctype		= NPCTYPE_AMBIENT;
	
	// Attribute, Inventory, Kampf-Talente
	TWI_Kirides_TrySetupNpc(self, 4, 30);
	fight_tactic		= FAI_HUMAN_STRONG;
	EquipItem			(self, ItMw_1h_VLK_Sword);
	TWI_Kirides_SetNpcVisual(self, MALE, "Hum_Head_Fatbald", Face_N_Normal01, BodyTex_N, ITAR_Leather_L);	
	Mdl_SetModelFatness	(self, 1);
	Mdl_ApplyOverlayMds	(self, "Humans_Relaxed.mds"); // Tired / Militia / Mage / Arrogance / Relaxed
	// ------ NSC-relevante Talente vergeben ------
	// B_GiveNpcTalents (self);
	start_aistate = TWI_ZS_Bandit;
};