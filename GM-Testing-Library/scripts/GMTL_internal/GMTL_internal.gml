/// @func	__gmtl_internal_fn_log(message)
/// @param	{string}	message
function __gmtl_internal_fn_log(_msg) {
	var _pad_left = "";
	for (var i = 0; i < gmtl_indent * 2; i++) {
		_pad_left += "\t";
	}
	_msg = _pad_left + _msg;
	
	gmtl_log += _msg + "\n";
	show_debug_message(_msg);
}

/// @func	__gmtl_internal_fn_log_test_success(message, time)
/// @param	{string}	message
/// @param	{real}	time
function __gmtl_internal_fn_log_test_success(_msg, _time) {
	__gmtl_internal_fn_log($"✔ {_msg} ({_time / 1000}ms)");
}

/// @func	__gmtl_internal_fn_log_test_failed(message, time)
/// @param	{string}	message
/// @param	{real}	time
function __gmtl_internal_fn_log_test_failed(_msg, _time) {
	__gmtl_internal_fn_log($"❌ {_msg} ({_time / 1000}ms)");
}

/// @func	__gmtl_internal_fn_log_test_skipped(message)
/// @param	{string}	message
function __gmtl_internal_fn_log_test_skipped(_msg) {
	__gmtl_internal_fn_log($"⚠ (Skipped) {_msg}");
}

/// @func	__gmtl_internal_fn_suite_add_to_queue(suite)
/// @param	{function}	suite
function __gmtl_internal_fn_suite_add_to_queue(_suite) {
	var _ts = time_source_create(time_source_game, 2, time_source_units_frames, function(_suite) {
		array_push(gmtl_suite_list, _suite);
		gmtl_coverage_suites.total++;
	}, [_suite]);
	time_source_start(_ts);
	
}

/// @func	__gmtl_internal_fn_wait_for(instance, time, unit)
/// @param	{ref}	instance
/// @param	{real}	time
/// @param	{real}	unit
function __gmtl_internal_fn_wait_for(_inst, _t, _unit) {
	_t = (_unit == time_source_units_seconds ? _t * game_get_speed(gamespeed_fps) : _t);
	var _count = 0;
	
	while (_count < _t) {
		with (_inst) {
			event_perform(ev_step, ev_step_begin);
			event_perform(ev_step, ev_step_normal);
			event_perform(ev_step, ev_step_end);

			for (var i = 0; i < 12; i++) {
				if (alarm[i] < 0) continue;
				alarm[i] -= 1;
			}
		}
		_count++;
	}
	
	return _inst;
}

/// @func	__gmtl_internal_fn_stacktrace()
function __gmtl_internal_fn_stacktrace() {
	static _stacktrace_fn = function (e) {
		return (string_pos("gml_Script_anon@", e) > 0);
	}
	var _stacktrace = debug_get_callstack(8);
	var _traced_error_index = array_find_index(_stacktrace, _stacktrace_fn);
	
	if (_traced_error_index) {
		var _trace = _stacktrace[_traced_error_index]
		var _filename = array_last(string_split(_trace, "@"));
		var _fname_arr = string_split(_filename, ":");
		var _line = _fname_arr[1];
		_filename = _fname_arr[0];
		// _filename = string_copy(_filename, 1, floor(string_length(_filename)) / 2);
		array_push(gmtl_test_log, $"On file \"{_filename}\" (line {_line}):");
	}
}

/// @func	__gmtl_internal_fn_keyboard_check(button)
/// @param	{real}	button
function __gmtl_internal_fn_keyboard_check(_btn) {
	return original_keyboard_check(_btn) || gmtl_internal.keys.hold == _btn || gmtl_internal.keys.press == _btn;
}

/// @func	__gmtl_internal_fn_keyboard_check_pressed(button)
/// @param	{real}	button
function __gmtl_internal_fn_keyboard_check_pressed(_btn) {
	return original_keyboard_check_pressed(_btn) || gmtl_internal.keys.press == _btn;
}

/// @func	__gmtl_internal_fn_keyboard_check_released(button)
/// @param	{real}	button
function __gmtl_internal_fn_keyboard_check_released(_btn) {
	return original_keyboard_check_released(_btn) || gmtl_internal.keys.release == _btn;
}

/// @func	__gmtl_internal_fn_mouse_button_to_map(button)
/// @param	{real}		button
function __gmtl_internal_fn_mouse_button_to_map(_btn) {
	switch (_btn) {
		default:
		case mb_left:	return "left";
		case mb_right:	return "right";
		case mb_middle:	return "middle";
		case mb_side1:	return "side1";
		case mb_side2:	return "side2";
	}
}

/// @func	__gmtl_internal_fn_mouse_check_anykey(expected, state)
/// @param	{bool}		expected
/// @param	{string}	state
function __gmtl_internal_fn_mouse_check_anykey(_expected, _state) {
	static _keys = struct_get_names(gmtl_internal.mouse);
	static _keys_len = array_length(_keys);
				
	for (var i = 0; i < _keys_len; i++) {
		var _key = _keys[i];
		if (gmtl_internal.mouse[$ _key][$ _state] == _expected) {
			return true;
		}
	}
				
	return false;
}

/// @func	__gmtl_internal_fn_mouse_check_button(button)
/// @param	{real}	button
function __gmtl_internal_fn_mouse_check_button(_btn) {
	if (original_mouse_check_button(_btn)) {
		return true;
	}
	
	if (_btn == mb_any) {
		return __gmtl_internal_fn_mouse_check_anykey(true, "hold") || __gmtl_internal_fn_mouse_check_anykey(true, "press");
	}
	
	if (_btn == mb_none) {
		return __gmtl_internal_fn_mouse_check_anykey(false, "hold") || __gmtl_internal_fn_mouse_check_anykey(false, "press")
	}
	
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	return  gmtl_internal.mouse[$ _key].hold || gmtl_internal.mouse[$ _key].press;
}

/// @func	__gmtl_internal_fn_mouse_check_button_pressed(button)
/// @param	{real}	button
function __gmtl_internal_fn_mouse_check_button_pressed(_btn) {
	if (original_mouse_check_button_pressed(_btn)) {
		return true;
	}
	
	if (_btn == mb_any) {
		return __gmtl_internal_fn_mouse_check_anykey(true, "press");
	}
	
	if (_btn == mb_none) {
		return __gmtl_internal_fn_mouse_check_anykey(false, "press");
	}
	
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	return gmtl_internal.mouse[$ _key].press;
}

/// @func	__gmtl_internal_fn_mouse_check_button_released(button)
/// @param	{real}	button
function __gmtl_internal_fn_mouse_check_button_released(_btn) {
	if (original_mouse_check_button_released(_btn)) {
		return true;
	}
	
	if (_btn == mb_any) {
		return __gmtl_internal_fn_mouse_check_anykey(true, "release");
	}
	
	if (_btn == mb_none) {
		return __gmtl_internal_fn_mouse_check_anykey(false, "release");
	}
	
	var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
	return gmtl_internal.mouse[$ _key].release;
}

/// @func	__gmtl_internal_fn_mouse_reset()
function __gmtl_internal_fn_mouse_reset() {
	static _keys = struct_get_names(gmtl_internal.mouse);
	static _keys_len = array_length(_keys);
				
	for (var i = 0; i < _keys_len; i++) {
		var _key = _keys[i];
		if (_key == "x" || _key == "y") continue;
		gmtl_internal.mouse[$ _key].reset();
	}
}

/// @func	__gmtl_internal_fn_mouse_get_x()
function __gmtl_internal_fn_mouse_get_x() {
	if (gmtl_internal.finished) {
		var _w_camera = camera_get_view_width(view_camera[view_current]);
		var _w_window = window_get_width(); 
		var _x = (display_mouse_get_x() - window_get_x()) * (1 / _w_window);
		_x = clamp(_x, 0, 1);
		_x = _x * _w_camera;
		return floor(_x);
	}
	
	return gmtl_internal.mouse.x;
}

/// @func	__gmtl_internal_fn_mouse_get_y()
function __gmtl_internal_fn_mouse_get_y() {
	if (gmtl_internal.finished) {
		var _h_camera = camera_get_view_height(view_camera[view_current]);
		var _h_window = window_get_height(); 
		var _y = (display_mouse_get_y() - window_get_y()) * (1 / _h_window);
		_y = clamp(_y, 0, 1);
		_y = _y * _h_camera;
		return floor(_y);
	}
	
	return gmtl_internal.mouse.y;
}

/// @func	__gmtl_internal_fn_get_function_index(fn)
/// @param	{function}	fn
function __gmtl_internal_fn_get_function_index(_fn) {
	var _fn_to_run = -1;
	if (is_method(_fn)) {
		_fn_to_run = method_get_index(_fn);
	} else if (is_callable(_fn)) {
		_fn_to_run = _fn;	
	}
	
	return _fn_to_run;
}

/// @func	__gmtl_internal_fn_call_suite(suite)
/// @param	{function}	suite
function __gmtl_internal_fn_call_suite(_suite) {
	gmtl_suite_last_failed = false;
	try {
		_suite();
		if (gmtl_suite_last_failed) {
			throw "Suite Failed";
		}
		gmtl_coverage_suites.success++;
	} catch(e) {
		var _prev_indent = gmtl_indent;
		gmtl_indent = 2;
		__gmtl_internal_fn_log(e);
		gmtl_indent = _prev_indent;
		gmtl_coverage_suites.failed++;
	} finally {
		__gmtl_internal_fn_log("\n" + string_repeat("=", 64));
	}
}

/// @func	__gmtl_internal_fn_finish_suites(time_start)
/// @param	{real}	time_start
function __gmtl_internal_fn_finish_suites(_t_start) {
	var _failed, _skipped, _time, _success_rate;
	gmtl_indent = 0;
	__gmtl_internal_fn_log($"{string_repeat("=", 23)} Tests Finished! {string_repeat("=", 24)}");
		
	_failed	 = gmtl_coverage_suites.failed > 0 ? $"{gmtl_coverage_suites.failed} failed, " : "";
	_skipped = gmtl_coverage_suites.skipped > 0 ? $"{gmtl_coverage_suites.skipped} skipped, " : "";
	_success_rate = __gmtl_dep_fn_string_percentage(gmtl_coverage_suites.success, gmtl_coverage_suites.total);
	__gmtl_internal_fn_log($"Test Suites: {gmtl_coverage_suites.success} passed, {_failed}{_skipped}{gmtl_coverage_suites.total} total. ({_success_rate} success)");
		
	_failed	 = gmtl_coverage_tests.failed > 0 ? $"{gmtl_coverage_tests.failed} failed, " : "";
	_skipped = gmtl_coverage_tests.skipped > 0 ? $"{gmtl_coverage_tests.skipped} skipped, " : "";
	_success_rate = __gmtl_dep_fn_string_percentage(gmtl_coverage_tests.success, gmtl_coverage_tests.total);
	__gmtl_internal_fn_log($"Tests: {gmtl_coverage_tests.success} passed, {_failed}{_skipped}{gmtl_coverage_tests.total} total. ({_success_rate} success)");
		
	_time = (get_timer() - _t_start) / 1000;
	_time = _time > 1000 ? $"{_time / 1000}s" : $"{_time}ms"
	__gmtl_internal_fn_log($"All tests finished in {_time}.\n");
	gmtl_internal.finished = true;
}