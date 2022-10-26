
func void _TWI_SwapKeys(var string keyFrom, var string keyTo) {
	var int from;    from    = MEM_GetKey(keyFrom);
	var int fromSec; fromSec = MEM_GetSecondaryKey(keyFrom);

	var int to;    to    = MEM_GetKey(keyTo);
	var int toSec; toSec = MEM_GetSecondaryKey(keyTo);

	MEM_SetKeys(keyFrom, to, toSec);
	MEM_SetKeys(keyTo, from, fromSec);
};


func void TWI_InvertKeyControls() {
	_TWI_SwapKeys("keyUp", "keyDown");
	_TWI_SwapKeys("keyLeft", "keyRight");
	_TWI_SwapKeys("keyStrafeLeft", "keyStrafeRight");
};

