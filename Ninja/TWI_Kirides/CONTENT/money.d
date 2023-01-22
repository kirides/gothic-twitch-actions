const int TWI_Kirides_CurrencyIdx = -1;
const string TWI_Kirides_CurrencyName = "ITMI_GOLD";
const string TWI_Kirides_CurrencyDisplay = "Geld";

func void _TWI_Donation_N(var int n) {
	if (n <= 0) { MEM_Info("TWI: amount <= 0"); return; };
	if (!Hlp_IsValidNpc(hero)) { MEM_Info("TWI: hero invalid"); return; };
	if (TWI_Kirides_CurrencyIdx == -1) { MEM_Info("TWI: No currency found"); return; };

	MEM_Info(ConcatStrings("_TWI_Donation_N: ", IntToString(n)));

	const int amt = 0; amt = Npc_HasItems(hero, TWI_Kirides_CurrencyIdx);

	if (amt == 0) { MEM_Info("TWI: Not enough money!"); return; };
	
	if amt < 50 {
		if (amt >= 30) {
			Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, 10);
			_TWI_PlaySound("DIA_DARON_SPENDEN_10_04.WAV"); // nun, du hast nicht viel, aber arm bist du auch nicht. 10 Goldstücke für innos, wir sind ja genügsam.
			Print(ConcatStrings("Du spendest 10 ", TWI_Kirides_CurrencyDisplay));
		} else {
			_TWI_PlaySound("DIA_DARON_SPENDEN_10_03.WAV"); // hm, du bist ein armer schlucker was, behalte das bisschen was du hast.
		};
	}
	else if (n >= 1000 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_02.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=  500 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_02.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=  100 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_06.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	}
	else if (n >=   50 && amt >= n) {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, n); _TWI_PlaySound("DIA_DARON_SPENDEN_10_07.WAV");
		Print(_TWI_CS4("Du spendest ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
	} else {
		Npc_RemoveInvItems(hero, TWI_Kirides_CurrencyIdx, amt);
		Print(_TWI_CS4("Du spendest ", IntToString(amt), " ", TWI_Kirides_CurrencyDisplay));
	};
};
func void _TWI_AddMoney(var int n) {
	if (n <= 0) { MEM_Info("TWI: amount <= 0"); return; };
	if (!Hlp_IsValidNpc(hero)) { MEM_Info("TWI: hero invalid"); return; };
	if (TWI_Kirides_CurrencyIdx == -1) { MEM_Info("TWI: No currency found"); return; };

	CreateInvItems(hero, TWI_Kirides_CurrencyIdx, n);
	Print(_TWI_CS4("Du erhältst ", IntToString(n), " ", TWI_Kirides_CurrencyDisplay));
};


func void TWI_Money() {
	var int amount; amount = STR_ToInt(TwitchIntegration_Arguments);
	if (amount < 0) {
		_TWI_Donation_N(-amount);
	} else if (amount > 0) {
		_TWI_AddMoney(amount);
	};
};


func void TWI_Kirides_Money_OnInit() {
	const int once = 0;
	if (once) { return; };
	once = 1;
	
	if (GOTHIC_BASE_VERSION == 1) {
		TWI_Kirides_CurrencyName = "ITMINUGGET";
	};

	// automatically find the current currency. Is required for G2A, don't know G1
	var int currency; currency = MEM_GetSymbol("TRADE_CURRENCY_INSTANCE");
    if (currency) {
        var zCPar_Symbol currencySymb; currencySymb = _^(currency);
        TWI_Kirides_CurrencyName = MEM_ReadString(currencySymb.content);
	};
	TWI_Kirides_CurrencyIdx = MEM_FindParserSymbol(TWI_Kirides_CurrencyName);
	if (TWI_Kirides_CurrencyIdx != -1) {
		MEMINT_GetMemHelper();
		CreateInvItem(MEM_Helper, TWI_Kirides_CurrencyIdx);
		Npc_GetInvItem(MEM_Helper, TWI_Kirides_CurrencyIdx);

		if (Hlp_IsValidItem(item)) {
			TWI_Kirides_CurrencyDisplay = item.name;
		};
	};
};