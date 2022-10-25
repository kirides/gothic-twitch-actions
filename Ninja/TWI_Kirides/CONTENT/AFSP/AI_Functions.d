/*
 *	AI functions
 *	 - dependencies:
		EngineClasses_G1/2\zEventMan.d
		EngineClasses_G1/2\zCVobSpot.d

		vectors.d
		vobFunctions.d

		ScriptBin\insertAnything.d

		ObjectFactory\oCMsgMovement.d
		ObjectFactory\oCMsgManipulate.d

		eventManager_engine.d
		eventManager.d

		world_engine.d
 */

/*
 *	Allows item equipping using AI queue
 */
func void AI_EquipItemPtr (var int slfInstance, var int vobPtr) {
	var oCNpc slf; slf = Hlp_GetNPC (slfInstance);
	if (!Hlp_IsValidNPC (slf)) { return; };

	if (!vobPtr) { return; };

	//Create new message
	var int eMsg; eMsg = oCMsgManipulate_Create (EV_EQUIPITEM, "", vobPtr, 0, "", "");

	//Get Event Manager
	var int eMgr; eMgr = zCVob_GetEM (_@ (slf));

	//Add new msg to Event Manager
	zCEventManager_OnMessage (eMgr, eMsg, _@ (slf));
};

/*
 *	Unequips melee weapon using AI queue
 */
func void AI_UnequipMeleeWeapon (var int slfInstance) {
	var int itemPtr; itemPtr = oCNpc_GetEquippedMeleeWeapon (slfInstance);
	if (itemPtr) {
		//Equipping equipped item will unequip it :)
		AI_EquipItemPtr (slfInstance, itemPtr);
	};
};

/*
 *	Unequips ranged weapon using AI queue
 */
func void AI_UnequipRangedWeapon (var int slfInstance) {
	var int itemPtr; itemPtr = oCNpc_GetEquippedRangedWeapon (slfInstance);
	if (itemPtr) {
		//Equipping equipped item will unequip it :)
		AI_EquipItemPtr (slfInstance, itemPtr);
	};
};

/*
 *	Same as AI_DrawWeapon, but allows you to specify target mode (also allows you to switch to fist mode)
 *	AI_DrawWeapon_Ext (slf, FMODE_FIST, 1); //Melee - fists
 *	AI_DrawWeapon_Ext (slf, FMODE_FIST, 0); //Melee
 *	AI_DrawWeapon_Ext (slf, FMODE_FAR, 0); //Ranged
 */
func void AI_DrawWeapon_Ext (var int slfInstance, var int targetMode, var int useFist) {
	var oCNpc slf; slf = Hlp_GetNPC (slfInstance);
	if (!Hlp_IsValidNPC (slf)) { return; };

	//Create new message
	var int eMsg; eMsg = oCMsgWeapon_Create (EV_DRAWWEAPON, targetMode, useFist);

	//Get Event Manager
	var int eMgr; eMgr = zCVob_GetEM (_@ (slf));

	//Add new msg to Event Manager
	zCEventManager_OnMessage (eMgr, eMsg, _@ (slf));
};
