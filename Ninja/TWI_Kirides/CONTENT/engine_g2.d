

func void _TWI_ChangeRoutine(var C_NPC npc, var string routine) {
    var oCNpc onpc; onpc = MEM_CpyInst(npc);

    const int oCNpc__ChangeRoutine_G1 = 7105008; // 006c69f0
    const int oCNpc__ChangeRoutine_G2 = 7790432; // 0076df60

    var int rtnIdx; rtnIdx = MEM_FindParserSymbol(routine);

    if (rtnIdx == -1) {
        MEM_Warn(ConcatStrings("_TWI_ChangeRoutine: Symbol not found: ", routine));
        return;
    };

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam (_@(rtnIdx));
        CALL__thiscall(_@(onpc.state_vtbl), MEMINT_SwitchG1G2(oCNpc__ChangeRoutine_G1, oCNpc__ChangeRoutine_G2));
        call = CALL_End();
    };
};
