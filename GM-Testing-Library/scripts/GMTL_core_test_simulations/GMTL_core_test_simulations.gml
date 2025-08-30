/// @func	simulateKeyPress(button)
/// @param	{Real}	button
function simulateKeyPress(_btn) {
	__gmtl_internal_fn_set_key_state(_btn, true);
	var _ts = simulateTimeSource(time_source_game, 1, time_source_units_frames, __gmtl_internal_fn_set_key_state, [_btn, false]);
	_ts.start();
}

/// @func	simulateKeyRelease(button)
/// @param	{Real}	button
function simulateKeyRelease(_btn) {
	__gmtl_internal_fn_set_key_state(_btn, false);
	var _ts = simulateTimeSource(time_source_game, 1, time_source_units_frames, function (_btn) { delete gmtl_internal.keys[$ _btn]; }, [_btn]);
	_ts.start();
}

/// @func	simulateKeyHold(button)
/// @param	{Real}	button
function simulateKeyHold(_btn) {
	__gmtl_internal_fn_set_key_state(_btn, true);
}

/// @func	simulateGamepadButtonPress(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
function simulateGamepadButtonPress(_device, _btn) {
	__gmtl_internal_fn_set_gamepad_button_state(_device, _btn, true);
	static _ts = simulateTimeSource(time_source_game, 1, time_source_units_frames, __gmtl_internal_fn_set_gamepad_button_state, [_device, _btn, false]);
	_ts.start();
}

/// @func	simulateGamepadButtonRelease(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
function simulateGamepadButtonRelease(_device, _btn) {
	__gmtl_internal_fn_set_gamepad_button_state(_device, _btn, false);
}

/// @func	simulateGamepadButtonHold(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
function simulateGamepadButtonHold(_device, _btn) {
	__gmtl_internal_fn_set_gamepad_button_state(_device, _btn, true);
}

/// @func	simulateMousePosition(x, y)
/// @param	{Real}	x
/// @param	{Real}	y
function simulateMousePosition(_x = mouse_x, _y = mouse_y) {	
	gmtl_internal.mouse.x = _x;
	gmtl_internal.mouse.y = _y;
}

/// @func	simulateMouseClickPress(mb_button, x, y)
/// @param	{Real}	mb_button
/// @param	{Real}	x
/// @param	{Real}	y
function simulateMouseClickPress(_btn, _x = mouse_x, _y = mouse_y) {	
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].press = true;
	gmtl_internal.mouse[$ _key].release = false;
	simulateCallLater(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetPress);
}

/// @func	simulateMouseClickRelease(mb_button, x, y)
/// @param	{Real}	button
/// @param	{Real}	x
/// @param	{Real}	y
function simulateMouseClickRelease(_btn, _x = mouse_x, _y = mouse_y) {
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].press = false;
	gmtl_internal.mouse[$ _key].hold = false;
	gmtl_internal.mouse[$ _key].release = true;
	simulateCallLater(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetRelease);
}

/// @func	simulateMouseClickHold(mb_button, x, y)
/// @param	{Real}	button
/// @param	{Real}	x
/// @param	{Real}	y
function simulateMouseClickHold(_btn, _x = mouse_x, _y = mouse_y) {
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	simulateMousePosition(_x, _y);
	gmtl_internal.mouse[$ _key].release = false;
	gmtl_internal.mouse[$ _key].hold = true;
	simulateMouseClickPress(_btn);
	simulateCallLater(1, time_source_units_frames, gmtl_internal.mouse[$ _key].resetHold);
}

/// @func	simulateFrameWait(frames)
/// @param	{Real}	frames
function simulateFrameWait(_frames = 1) {
	__gmtl_internal_fn_wait_for(all, _frames, time_source_units_frames);
}

///	@func	simulateEvent(event_type, event_number, inst_id)
/// @param	{Real}			event_type
/// @param	{Real}			event_number
/// @param	{Id.Instance}	inst_id
function simulateEvent(_type, _number, _inst_id = all) {
	with (_inst_id) {
		event_perform(_type, _number);
	}
}

/// @func	simulateTimeSource(parent, period, unit, callback, args, reps, expiry)
/// @param	{Any}							parent
/// @param	{Real}							period
/// @param	{Constant.TimeSourceUnits}		unit
/// @param	{Function}						callback
/// @param	{Array}							args
///	@param	{Real}							reps
/// @param	{Constant.TimeSourceExpiryType}	expiry
function simulateTimeSource(_parent, _period, _unit, _callback, _args = undefined, _reps = undefined, _expiry = undefined) {
	var _new_ts = new GMTL_TimeSource(_parent, _period, _unit, _callback, _args, _reps, _expiry);
	array_push(gmtl_timesources, _new_ts);
	return _new_ts;
}

/// @func	simulateCallLater(period, unit, callback, loop)
/// @param	{Real}						period
/// @param	{Constant.TimeSourceUnits}	unit
/// @param	{Function}					callback
/// @param	{Bool}						loop
function simulateCallLater(_period, _unit, _callback, _loop = false) {
	var _new_ts = new GMTL_TimeSource(time_source_global, 1, _unit, _callback,, _loop ? infinity : 1);
	array_push(gmtl_timesources, _new_ts);
	_new_ts.startLater(_period);
	return _new_ts;
}