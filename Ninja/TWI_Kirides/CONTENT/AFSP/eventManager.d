/*
 *	Event Manager (AI queue) functions [WIP]
 */

func int zCVob_GetEM (var int vobPtr) {
	//0x005D49B0 public: class zCEventManager * __fastcall zCVob::GetEM(int)
	const int zCVob__GetEM_G1 = 6113712;

	//0x005FFE10 public: class zCEventManager * __fastcall zCVob::GetEM(int)
	const int zCVob__GetEM_G2 = 6290960;

	if (!vobPtr) { return 0; };

	var int f; f = false;

	const int call = 0;
	if (CALL_Begin(call)) {
		CALL__fastcall(_@(vobPtr), _@(f), MEMINT_SwitchG1G2 (zCVob__GetEM_G1, zCVob__GetEM_G2));
		call = CALL_End();
	};

	return CALL_RetValAsPtr ();
};

func void zCEventManager_OnMessage (var int eMgr, var int eMsg, var int vobPtr) {
	//0x006DD090 public: virtual void __thiscall zCEventManager::OnMessage(class zCEventMessage *,class zCVob *)
	const int zCEventManager__OnMessage_G1 = 7196816;

	//0x00786380 public: virtual void __thiscall zCEventManager::OnMessage(class zCEventMessage *,class zCVob *)
	const int zCEventManager__OnMessage_G2 = 7889792;

	if (!eMgr) { return; };
	if (!eMsg) { return; };
	if (!vobPtr) { return; };

	const int call = 0;
	if (CALL_Begin(call)) {
		CALL_PtrParam(_@(vobPtr));
		CALL_PtrParam(_@(eMsg));
		CALL__thiscall(_@(eMgr), MEMINT_SwitchG1G2 (zCEventManager__OnMessage_G1, zCEventManager__OnMessage_G2));

		call = CALL_End();
	};
};
