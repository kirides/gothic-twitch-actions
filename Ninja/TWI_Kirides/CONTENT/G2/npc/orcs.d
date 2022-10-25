PROTOTYPE Mst_Default_OrcWarrior(C_Npc) {};
PROTOTYPE Mst_Default_OrcElite(C_Npc) {};

func void TWI_Kirides_SetVisuals_OrcWarrior()
{
	Mdl_SetVisual			(self,	"Orc.mds");
	//								Body-Mesh			Body-Tex	Skin-Color	Head-MMS	Head-Tex	Teeth-Tex	ARMOR
	Mdl_SetVisualBody		(self,	"Orc_BodyWarrior",	DEFAULT,	DEFAULT,	"Orc_HeadWarrior",	DEFAULT,  	DEFAULT,	-1);
};

func void TWI_Kirides_SetVisuals_OrcElite()
{
	Mdl_SetVisual		(self,	"Orc.mds");
	//							Body-Mesh			Body-Tex	Skin-Color	Head-MMS	Head-Tex	Teeth-Tex	ARMOR
	Mdl_SetVisualBody	(self,	"Orc_BodyElite",	DEFAULT,	DEFAULT,	"Orc_HeadWarrior",	DEFAULT,  	DEFAULT,	-1);
};

INSTANCE TWI_Orc_S (Mst_Default_OrcWarrior) {
    name							=	"Ork Späher";
	level							=	15;

	attribute	[ATR_STRENGTH]		=	75; //MIN 70 wg Equip!!!
	attribute	[ATR_DEXTERITY]		=	75;
	attribute	[ATR_HITPOINTS_MAX]	=	150;
	attribute	[ATR_HITPOINTS]		=	150;
	
	protection	[PROT_BLUNT]		=	75;
	protection	[PROT_EDGE]			=	75;
	protection	[PROT_POINT]		=	75;
	protection	[PROT_FIRE]			=	75;
	protection	[PROT_FLY]			=	75;
	
	//-------- visual --------
	TWI_Kirides_SetVisuals_OrcWarrior();

	//-------- inventory --------
	EquipItem (self, ItMw_2H_OrcAxe_01);
	
	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RestStart] 	= OnlyRoutine;
};

INSTANCE TWI_Orc_M (Mst_Default_OrcWarrior) {
	TWI_Kirides_SetVisuals_OrcWarrior();

	EquipItem (self, ItMw_2H_OrcAxe_03);
	
	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RoamStart] 	= OnlyRoutine;
};

INSTANCE TWI_Orc_L (Mst_Default_OrcElite) {
	TWI_Kirides_SetVisuals_OrcElite();

	EquipItem (self, ItMw_2H_OrcSword_02);
	
	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RoamStart] 	= OnlyRoutine;
};