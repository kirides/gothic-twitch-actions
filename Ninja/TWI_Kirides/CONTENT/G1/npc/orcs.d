PROTOTYPE Mst_Default_OrcScout(C_Npc) {};
PROTOTYPE Mst_Default_OrcWarrior(C_Npc) {};

func void TWI_Kirides_SetVisuals_OrcScout()
{
	Mdl_SetVisual			(self,	"Orc.mds");
	//								Body-Mesh		Body-Tex	Skin-Color	Head-MMS	Head-Tex	Teeth-Tex	ARMOR
	Mdl_SetVisualBody		(self,	"Orc_BodyScout",DEFAULT,	DEFAULT,	"Orc_HeadWarrior",	DEFAULT,  	DEFAULT,	-1);
};

func void TWI_Kirides_SetVisuals_OrcWarrior()
{
	Mdl_SetVisual			(self,	"Orc.mds");
	//								Body-Mesh			Body-Tex	Skin-Color	Head-MMS	Head-Tex	Teeth-Tex	ARMOR
	Mdl_SetVisualBody		(self,	"Orc_BodyWarrior",	DEFAULT,	DEFAULT,	"Orc_HeadWarrior",	DEFAULT,  	DEFAULT,	-1);
};

INSTANCE TWI_Orc_S (Mst_Default_OrcScout) {
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
	TWI_Kirides_SetVisuals_OrcScout();

	//-------- inventory --------
	EquipItem (self, ItMw2hOrcAxe01);
	
	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RestStart] 	= OnlyRoutine;
};

INSTANCE TWI_Orc_M (Mst_Default_OrcScout) {
	TWI_Kirides_SetVisuals_OrcScout();

	attribute	[ATR_STRENGTH]		=	60;
	attribute	[ATR_HITPOINTS_MAX]	=	230;
	attribute	[ATR_HITPOINTS]		=	230;

	//-------- protection --------
	protection	[PROT_BLUNT]		=	70;
	protection	[PROT_EDGE]			=	70;
	protection	[PROT_POINT]		=	35;
	protection	[PROT_FIRE]			=	35;

	EquipItem (self, ItMw2hOrcAxe02);

	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RoamStart] 	= OnlyRoutine;
};

INSTANCE TWI_Orc_L (Mst_Default_OrcWarrior) {
	TWI_Kirides_SetVisuals_OrcWarrior();

	attribute	[ATR_STRENGTH]		=	65;
	attribute	[ATR_HITPOINTS_MAX]	=	250;
	attribute	[ATR_HITPOINTS]		=	250;

	protection	[PROT_BLUNT]		=	80;
	protection	[PROT_EDGE]			=	80;
	protection	[PROT_POINT]		=	40;
	protection	[PROT_FIRE]			=	40;

	EquipItem (self, ItMw2hOrcAxe04);
	
	start_aistate				= ZS_MM_AllScheduler;
	aivar[AIV_MM_RoamStart] 	= OnlyRoutine;
};