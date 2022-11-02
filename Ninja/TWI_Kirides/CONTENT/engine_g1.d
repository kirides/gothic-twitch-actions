

/*
func void _TWI_Kirides_Snd_Play(var C_NPC source, var string sound) {
    const int zsound_addr = 9236044; // 008cee4c
    if (!Hlp_Is_zCSndSys_MSS(zsound_addr)) { return; };

    const int zCSndSys_Mss_PlaySound3D_G1 = 5125952; // 004e3740

    
    const int snd3dParams = 0;
    const int slot = 0;

    CALL_IntParam (snd3dParams);
    CALL_IntParam (slot);
    CALL_PtrParam (source);
    CALL_zStringPtrParam (sound);
    CALL__thiscall (zsound_addr, zCSndSys_Mss_PlaySound3D_G1);
    var int ret; ret = CALL_RetValAsInt();
};
*/
