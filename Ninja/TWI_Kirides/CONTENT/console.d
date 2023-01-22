

func string _TWI_CC_SpawnRandomMonster(var string arg) {
	var int n; n = STR_ToInt(arg);
	if (n > 0) {
		_TWI_Kirides_SpawnRandomMonster("Player", n, 0);
	} else {
		_TWI_Kirides_SpawnRandomMonster("Player", 1, 0);
	};
	return " ";
};
func string _TWI_CC_SpawnRandomMonsterScaled(var string arg) {
	var int n; n = STR_ToInt(arg);
	if (n > 0) {
		_TWI_Kirides_SpawnRandomMonsterScaled("Player", n);
	} else {
		_TWI_Kirides_SpawnRandomMonsterScaled("Player", 1);
	};
	return " ";
};

func string _TWI_CC_RandomStatsPool(var string arg) {
	TWI_RandomStatsPool();
	return " ";
};

func string _TWI_CC_FightingSleeper(var string arg) {
	_TWI_SpawnSleeper();
	return " ";
};

func string _TWI_CC_RandomStats(var string arg) {
	var int n; n = STR_ToInt(arg);
	if (Hlp_StrCmp(arg, "1")) {
		TWI_RandomStats();
	} else {
		TWI_RandomStatsNoLimit();
	};
	return " ";
};

func void TWI_Kirides_Console_OnInit() {
    CC_Register(_TWI_CC_SpawnRandomMonster, "twi_rmonster ", "Spawn Random monster(s)");
	CC_Register(_TWI_CC_SpawnRandomMonsterScaled, "twi_srmonster ", "Spawn scaled Random monster(s)");
	CC_Register(_TWI_CC_RandomStats, "twi_rstats ", "Random stats (1 = limit)");
	CC_Register(_TWI_CC_RandomStatsPool, "twi_pstats ", "pooled stats/talents");
	CC_Register(_TWI_CC_FightingSleeper, "twi_sleeper ", "pooled stats/talents");
};

