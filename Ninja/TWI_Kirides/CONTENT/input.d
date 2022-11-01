
const int _TWI_InvertKeyControls_Active = 0;
const int _TWI_InvertKeyControls_DurationLeft = 0;

func void _TWI_SwapKeys(var string keyFrom, var string keyTo) {
	var int from;    from    = MEM_GetKey(keyFrom);
	var int fromSec; fromSec = MEM_GetSecondaryKey(keyFrom);

	var int to;    to    = MEM_GetKey(keyTo);
	var int toSec; toSec = MEM_GetSecondaryKey(keyTo);

	MEM_SetKeys(keyFrom, to, toSec);
	MEM_SetKeys(keyTo, from, fromSec);
};

func void _TWI_InvertKeyControls_Toggle() {
	_TWI_SwapKeys("keyUp", "keyDown");
	_TWI_SwapKeys("keyLeft", "keyRight");
	_TWI_SwapKeys("keyStrafeLeft", "keyStrafeRight");
};

func void _TWI_InvertKeyControls_FF() {
	_TWI_InvertKeyControls_DurationLeft -= 1;
};

func void _TWI_InvertKeyControls_Revert() {
	if (_TWI_InvertKeyControls_DurationLeft <= 0
	&& _TWI_InvertKeyControls_Active)
	{
		_TWI_InvertKeyControls_Toggle();
		FF_RemoveAll(_TWI_InvertKeyControls_FF);
		_TWI_InvertKeyControls_Active = 0;
	};
};

func void TWI_InvertKeyControls() {
	if (_TWI_InvertKeyControls_DurationLeft > 0) { return; };

	var string args; args = TwitchIntegration_Arguments;
	var int duration; duration = STR_ToInt(TwitchIntegration_Arguments);
	if (duration <= 0) { duration = 10; };

	if (_TWI_InvertKeyControls_Active == 0) {
		_TWI_InvertKeyControls_Active = 1;
		FF_RemoveAll(_TWI_InvertKeyControls_Revert);
		FF_ApplyOnceExtGT(_TWI_InvertKeyControls_FF, 1000, -1);
	} else {
		_TWI_InvertKeyControls_DurationLeft = 0;
		FF_RemoveAll(_TWI_InvertKeyControls_FF);
	};
	_TWI_InvertKeyControls_Toggle();
};

func void TWI_InvertKeyControls_OnInit() {
	FF_ApplyOnceExtGT(_TWI_InvertKeyControls_Revert, 1000, -1);
};

