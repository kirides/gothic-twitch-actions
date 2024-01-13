
func string _TWI_Kirides_LoadOptStr(var string sect, var string opt, var string defVal) {
	if (MEM_GothOptExists(sect, opt)) {
		return MEM_GetGothOpt(sect, opt);
	};
	MEM_SetGothOpt(sect, opt, defVal);
	return defVal;
};

func int _TWI_Kirides_LoadOptInt(var string sect, var string opt, var int defVal) {
	if (MEM_GothOptExists(sect, opt)) {
		return +STR_ToInt(MEM_GetGothOpt(sect, opt));
	};
	MEM_SetGothOpt(sect, opt, IntToString(defVal));
	return defVal;
};

func void _TWI_Kirides_LoadOptions() {
	_TWI_KIRIDES_SCALING_MAX_LVL = MEMINT_SwitchG1G2(50, 40);
	_TWI_KIRIDES_SCALING_MAX_LVL = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_SCALING, _TWI_KIRIDES_INI_SCALING_MAX_LVL, _TWI_KIRIDES_SCALING_MAX_LVL);

	_TWI_KIRIDES_SCALING_MAX_STR = MEMINT_SwitchG1G2(150, 250);
	_TWI_KIRIDES_SCALING_MAX_STR = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_SCALING, _TWI_KIRIDES_INI_SCALING_MAX_STR, _TWI_KIRIDES_SCALING_MAX_STR);
	
	_TWI_KIRIDES_SCALING_MIN_STR_DIV = MEMINT_SwitchG1G2(7, 5);
	_TWI_KIRIDES_SCALING_MIN_STR_DIV = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_SCALING, _TWI_KIRIDES_INI_SCALING_MIN_STR_DIV, _TWI_KIRIDES_SCALING_MIN_STR_DIV);

	_TWI_KIRIDES_SCALING_MAX_DEF = MEMINT_SwitchG1G2(150, 200);
	_TWI_KIRIDES_SCALING_MAX_DEF = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_SCALING, _TWI_KIRIDES_INI_SCALING_MAX_DEF, _TWI_KIRIDES_SCALING_MAX_DEF);

	_TWI_KIRIDES_SCALING_MIN_DEF_DIV = MEMINT_SwitchG1G2(15, 12);
	_TWI_KIRIDES_SCALING_MIN_DEF_DIV = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_SCALING, _TWI_KIRIDES_INI_SCALING_MIN_DEF_DIV, _TWI_KIRIDES_SCALING_MIN_DEF_DIV);

	_TWI_KIRIDES_RANDSTATS_SAVE_FIX = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_RANDSTATS, _TWI_KIRIDES_INI_SAVE_FIX, _TWI_KIRIDES_RANDSTATS_SAVE_FIX);
	_TWI_KIRIDES_RANDTALENTS_SAVE_FIX = _TWI_Kirides_LoadOptInt(_TWI_KIRIDES_SECT_RANDTALENTS, _TWI_KIRIDES_INI_SAVE_FIX, _TWI_KIRIDES_RANDTALENTS_SAVE_FIX);
};

func void TWI_Kirides_Config_OnInit() {
    const int once = 1;
    if (once) {
        _TWI_Kirides_LoadOptions();
        once = 0;
    };
};
