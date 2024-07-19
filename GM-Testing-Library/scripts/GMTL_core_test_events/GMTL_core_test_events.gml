/// @func	expect(value, args)
/// @param	{any}	value
/// @param	{array}	agrs
function expect(_val, _args = []) {
	if (gmtl_suite_continue) {
		return new TestCase(_val, _args);
	}
}

/// @func	create(x, y, object_index, params)
/// @param	{real}		x
/// @param	{real}		y
/// @param	{ref}		object_index
/// @param	{struct}	params
function create(_x, _y, _obj, _params = {}) {
	if (gmtl_suite_continue) {
		static _layer_name = "__GMTL_LAYER_TESTING";
		var _layer = layer_exists(_layer_name) ? layer_get_id(_layer_name) : layer_create(0, _layer_name);
		var _inst = instance_create_layer(_x, _y, _layer, _obj, _params);
		_inst.waitFor = method(_inst.id, function (_time, _unit) {
			__gmtl_internal_fn_wait_for(id, _time, _unit);
		});
		
		return _inst;
	}
}

/// @func	beforeAll(fn)
/// @param	{function}	fn
function beforeAll(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_before_all = _fn;
}

/// @func	afterAll(fn)
/// @param	{function}	fn
function afterAll(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_after_all = _fn;
}

/// @func	beforeEach(fn)
/// @param	{function}	fn
function beforeEach(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_before_each = _fn;
}

/// @func	afterEach(fn)
/// @param	{function}	fn
function afterEach(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_after_each = _fn;
}

/// @func	simulateKeyPress(button)
/// @param	{real}	button
function simulateKeyPress(_btn) {
	static _reset = function () {
		gmtl_internal.keys.press = vk_nokey;
	}
	
	gmtl_internal.keys.press = _btn;
	call_later(1, time_source_units_frames, _reset);
}

/// @func	simulateKeyRelease(button)
/// @param	{real}	button
function simulateKeyRelease(_btn) {
	static _reset = function () {
		gmtl_internal.keys.release = vk_nokey;
	}
	
	gmtl_internal.keys.release = _btn;
	call_later(1, time_source_units_frames, _reset);
}

/// @func	simulateKeyHold(button)
/// @param	{real}	button
function simulateKeyHold(_btn) {
	gmtl_internal.keys.hold = _btn;
	simulateKeyPress(_btn);
	call_later(1, time_source_units_frames, function () {
		gmtl_internal.keys.hold = vk_nokey;
	});
}

/// @func	simulateGamepadButtonPress(device, button)
/// @param	{real}	device
/// @param	{real}	button
function simulateGamepadButtonPress(_device, _btn) {
	static _reset = function (_device) {
		gmtl_internal.gamepad[_device].press = vk_nokey;
	}
	
	gmtl_internal.gamepad[_device].press = _btn;
	static _ts = time_source_create(time_source_game, 1, time_source_units_frames, _reset, [_device]);
	time_source_start(_ts);
}

/// @func	simulateGamepadButtonRelease(device, button)
/// @param	{real}	device
/// @param	{real}	button
function simulateGamepadButtonRelease(_device, _btn) {
	static _reset = function (_device) {
		gmtl_internal.gamepad[_device].release = vk_nokey;
	}
	
	gmtl_internal.gamepad[_device].release = _btn;
	static _ts = time_source_create(time_source_game, 1, time_source_units_frames, _reset, [_device]);
	time_source_start(_ts);
}

/// @func	simulateGamepadButtonHold(device, button)
/// @param	{real}	device
/// @param	{real}	button
function simulateGamepadButtonHold(_device, _btn) {
	static _reset = function (_device) {
		gmtl_internal.gamepad[_device].hold = vk_nokey;
	};
	gmtl_internal.gamepad[_device].hold = _btn;
	
	simulateKeyPress(_btn);
	static _ts = time_source_create(time_source_game, 1, time_source_units_frames, _reset, [_device]);
	time_source_start(_ts);
}

/// @func	simulateMousePosition(x, y)
/// @param	{real}	x
/// @param	{real}	y
function simulateMousePosition(_x = mouse_x, _y = mouse_y) {	
	gmtl_internal.mouse.x = _x;
	gmtl_internal.mouse.y = _y;
}

/// @func	simulateMouseClickPress(mb_button, x, y)
/// @param	{real}	mb_button
/// @param	{real}	x
/// @param	{real}	y
function simulateMouseClickPress(_btn, _x = mouse_x, _y = mouse_y) {	
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].press = true;
	gmtl_internal.mouse[$ _key].release = false;
	call_later(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetPress);
}

/// @func	simulateMouseClickRelease(mb_button, x, y)
/// @param	{real}	button
/// @param	{real}	x
/// @param	{real}	y
function simulateMouseClickRelease(_btn, _x = mouse_x, _y = mouse_y) {
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].press = false;
	gmtl_internal.mouse[$ _key].hold = false;
	gmtl_internal.mouse[$ _key].release = true;
	call_later(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetRelease);
}

/// @func	simulateMouseClickHold(mb_button, x, y)
/// @param	{real}	button
/// @param	{real}	x
/// @param	{real}	y
function simulateMouseClickHold(_btn, _x = mouse_x, _y = mouse_y) {
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].release = false;
	gmtl_internal.mouse[$ _key].hold = true;
	simulateMouseClickPress(_btn);
	call_later(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetHold);
}

/// @func	simulateFrameWait(frames)
/// @param	{real}	frames
function simulateFrameWait(_frames = 1) {
	__gmtl_internal_fn_wait_for(all, _frames, time_source_units_frames);
}

///	@func	simulateEvent(event_type, event_number, inst_id)
/// @param	{real}	event_type
/// @param	{real}	event_number
/// @param	{ref}	inst_id
function simulateEvent(_type, _number, _inst_id = all) {
	with (_inst_id) {
		event_perform(_type, _number);
	}
}