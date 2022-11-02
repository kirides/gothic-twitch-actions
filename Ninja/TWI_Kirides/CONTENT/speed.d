const int _TWI_Kirides_Southpark_Counter = 0;
const int _TWI_Kirides_Southpark_Max = 0;

const int _TWI_Kirides_Slowdown_Counter = 0;
const int _TWI_Kirides_Slowdown_Max = 0;

func void _TWI_Kirides_Southpark_FF() {
	if (_TWI_Kirides_Southpark_Max == 0) {
		return;
	};
	_TWI_Kirides_Southpark_Counter += 1;
	if (_TWI_Kirides_Southpark_Counter > _TWI_Kirides_Southpark_Max) {
		_TWI_Kirides_Southpark_Max = 0;
		FF_RemoveAll(_TWI_Kirides_Southpark_FF);
		return;
	};
	if (!InfoManager_Hasfinished()) { return; };

	MEM_Timer.factorMotion = mkf(2);
};

func void _TWI_Kirides_Southpark_Reset() {
	if ((_TWI_Kirides_Southpark_Max <= 0)) {
		FF_RemoveAll(_TWI_Kirides_Southpark_FF);
	};
	if ((_TWI_Kirides_Slowdown_Max <= 0)) {
		FF_RemoveAll(_TWI_Slowdown_FF);
	};

	if ((_TWI_Kirides_Southpark_Max <= 0)
	&& (_TWI_Kirides_Slowdown_Max <= 0)) {
		MEM_Timer.factorMotion = FLOATONE;
	};
};

func void _TWI_Southpark_N(var int n) {
	if (_TWI_Kirides_Southpark_Max != 0)      { return; };
	if (FF_Active(_TWI_Kirides_Southpark_FF)) { return; };
	
	_TWI_Kirides_Slowdown_Max = 0;
	FF_RemoveAll(_TWI_Slowdown_FF);
	
	MEM_Info(ConcatStrings("_TWI_Southpark_N: ", IntToString(n)));

	_TWI_Kirides_Southpark_Counter = 0;
	_TWI_Kirides_Southpark_Max = n;
	FF_ApplyOnceExtGT(_TWI_Kirides_Southpark_FF, 1000, -1);
};

func void TWI_Southpark()  { 	
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		_TWI_Southpark_N(amount);
	};
};

func void _TWI_Slowdown_FF() {
	if (_TWI_Kirides_Slowdown_Max == 0) {
		FF_RemoveAll(_TWI_Slowdown_FF);
		return;
	};
	_TWI_Kirides_Slowdown_Counter += 1;
	if (_TWI_Kirides_Slowdown_Counter > _TWI_Kirides_Slowdown_Max) {
		_TWI_Kirides_Slowdown_Max = 0;
		FF_RemoveAll(_TWI_Slowdown_FF);
		return;
	};
	if (!InfoManager_Hasfinished()) { return; };

	MEM_Timer.factorMotion = fracf(1, 2);
};

func void _TWI_Slowdown_N(var int n) {
	if (_TWI_Kirides_Slowdown_Max != 0) { return; };
	if (FF_Active(_TWI_Slowdown_FF)) 	{ return; };
	_TWI_Kirides_Southpark_Max = 0;
	_TWI_Kirides_Southpark_Reset();
	
	MEM_Info(ConcatStrings("_TWI_Slowdown_N: ", IntToString(n)));

	_TWI_Kirides_Slowdown_Counter = 0;
	_TWI_Kirides_Slowdown_Max = n;
	FF_ApplyOnceExtGT(_TWI_Slowdown_FF, 1000, -1);
};

func void TWI_Slowdown()  { 	
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount > 0) {
		_TWI_Slowdown_N(amount);
	};
};


func void TWI_Southpark_OnInit()  { 	
	if (_TWI_Kirides_Southpark_Max != 0) {
		FF_ApplyOnceExtGT(_TWI_Kirides_Southpark_FF, 1000, -1);
	};
	FF_ApplyOnceExt(_TWI_Kirides_Southpark_Reset, 100, -1);
};

func void TWI_Slowdown_OnInit()  { 	
	if (_TWI_Kirides_Slowdown_Max != 0) {
		FF_ApplyOnceExtGT(_TWI_Slowdown_FF, 1000, -1);
	};
};