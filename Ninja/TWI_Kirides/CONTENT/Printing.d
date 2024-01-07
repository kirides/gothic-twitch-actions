
func void _Ninja_TWI_Kirides_Print(var string text) {
	const int fnIdx = -1;
	if (fnIdx == -1) {
		fnIdx = MEM_FindParserSymbol("_TwitchIntegration_PrintC");
	};

	if (fnIdx == -1) {
		Print(text);
	} else {
		MEM_PushStringParam(text);
		MEM_PushIntParam(COL_White);
		MEM_CallByID(fnIdx);
	};
};
