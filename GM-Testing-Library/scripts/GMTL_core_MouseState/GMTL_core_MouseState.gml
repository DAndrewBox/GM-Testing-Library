
/// @func	GTML_MouseState()
/// @ignore	- Constructor only for internal usage or mouse tests.
function GTML_MouseState() constructor {
	press	= false;
	hold	= false;
	release	= false;
	
	static reset = function () {
		self.press = false;
		self.hold = false;
		self.release = false;
	}
	
	static resetHold = function () {
		self.hold = false;
	}
	
	static resetRelease = function () {
		self.release = false;
	}
	
	static resetPress = function () {
		self.press = false;
	}
}