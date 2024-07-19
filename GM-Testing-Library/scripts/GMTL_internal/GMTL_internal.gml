/// @func	__gmtl_internal_fn_log(message)
/// @param	{string}	message
function __gmtl_internal_fn_log(_msg) {
	var _pad_left = "";
	for (var i = 0; i < gmtl_indent * 2; i++) {
		_pad_left += "\t";
	}
	_msg = _pad_left + _msg;
	
	gmtl_log += _msg + "\n";
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

/// @func	__gmtl_internal_fn_gamepad_button_check(device, button)
/// @param	{real}	device
/// @param	{real}	button
function __gmtl_internal_fn_gamepad_button_check(_device, _btn) {
	return original_gamepad_button_check(_device, _btn) || gmtl_internal.gamepad[_device].hold == _btn || gmtl_internal.gamepad[_device].press == _btn;
}

/// @func	__gmtl_internal_fn_gamepad_button_check_pressed(device, button)
/// @param	{real}	device
/// @param	{real}	button
function __gmtl_internal_fn_gamepad_button_check_pressed(_device, _btn) {
	return original_gamepad_button_check_pressed(_device, _btn) || gmtl_internal.gamepad[_device].press == _btn;
}

/// @func	__gmtl_internal_gamepad_button_check_released(device, button)
/// @param	{real}	device
/// @param	{real}	button
function __gmtl_internal_gamepad_button_check_released(_device, _btn) {
	return original_gamepad_button_check_released(_device, _btn) || gmtl_internal.gamepad[_device].release == _btn;
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

/// @func	__gmtl_internal_fn_get_fn_index(fn)
/// @param	{function}	fn
function __gmtl_internal_fn_get_fn_index(_fn) {
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
			/*throw {
				message: $"Suite Failed on file {_GMFILE_}. Function \"{_GMFUNCTION_}\" (line {_GMLINE_}).",
				longMessage: $"Suite Failed on file {_GMFILE_}. Function \"{_GMFUNCTION_}\" (line {_GMLINE_}).",
			};*/
			throw {
				message: "",
			};
		}
		gmtl_coverage_suites.success++;
	} catch(e) {
		if (e.message != "") {
			var _prev_indent = gmtl_indent;
			gmtl_indent = 2;
			__gmtl_internal_fn_log(e.message);
			gmtl_indent = _prev_indent;
			gmtl_coverage_suites.failed++;
		}
	} finally {
		__gmtl_internal_fn_log(string_repeat("=", 64));
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
	show_debug_message(gmtl_log);
}

/// @func	__gmtl_internal_fn_find_coverage_files()
function __gmtl_internal_fn_find_coverage_files() {
	var _dir_path = string_copy(GM_project_filename, 1, string_last_pos("\\", GM_project_filename));
	var _dir_exists = directory_exists(_dir_path);
	var _folders = [];
	if (_dir_exists) {
		var _file = file_find_first($"{_dir_path}scripts\\*", fa_directory);
		while (_file != "") {
			if !(string_pos(".", _file) > 0) {
				array_push(_folders, _file);
			}
			_file = file_find_next();
		}
			
		file_find_close();
	}
		
	var _coverage_files = [];
	var _folders_len = array_length(_folders);
	for (var i = 0; i < _folders_len; i++) {
		var _file = file_find_first($"{_dir_path}scripts\\{_folders[i]}\\*.gml", fa_none);
		while (_file != "") {
			array_push(_coverage_files, $"{_dir_path}scripts\\{_folders[i]}\\{_file}");
			_file = file_find_next();
		}
			
		file_find_close();
	}
		
	var _files_len = array_length(_coverage_files);
	for (var i = 0; i < _files_len; i++) {
		var _fns = [];
		var _file = file_text_open_read(_coverage_files[i]);
		var _str = "";
		while (!file_text_eof(_file)) {
			var _cur_line = file_text_readln(_file);
			_str += _cur_line;
				
			var _fn_starts_at = string_pos("function", _cur_line);
			var _fn_ends_at = string_pos_ext("(", _cur_line, _fn_starts_at);
			if (_fn_starts_at > 0 && _fn_ends_at > 0 && !string_pos("@func", _cur_line)) {
				var _fn_name = string_copy(_cur_line, _fn_starts_at + 8, _fn_ends_at - (_fn_starts_at + 8));
				_fn_name = string_trim(_fn_name);

				if (string_pos("=", _fn_name)) continue;
				if (_fn_name != "") {
					array_push(_fns, { name: _fn_name, coverage: false });
				}
			}
		}
		if (array_length(_fns) > 0) {
			array_sort(_fns, true);
			var _fn_name = string_copy(
				_coverage_files[i],
				string_last_pos("\\", _coverage_files[i]) + 1,
				1 + string_length(_coverage_files[i]) - string_last_pos("\\", _coverage_files[i])
			);
			array_push(gmtl_coverage_files, {
				filepath: _coverage_files[i],
				fn_name: _fn_name,
				fn_list: _fns
			});
		}
		file_text_close(_file);
	}
}

/// @func	__gmtl_internal_fn_show_coverage_table()
function __gmtl_internal_fn_show_coverage_table() {
	var _coverage_len = array_length(gmtl_coverage_files);
	show_debug_message("Coverage Results per File:");
	for (var i = 0; i < _coverage_len; i++) {
		var _functions = gmtl_coverage_files[i].fn_list;
		var _functions_len = array_length(_functions);
		gmtl_coverage_table += $"{gmtl_coverage_files[i].fn_name} (0%)\n";
		for (var j = 0; j < _functions_len; j++) {
			var _cols = [
				__gmtl_dep_fn_string_pad_right(string(_functions[j].coverage), " ", 2),
				_functions[j].name,
			];
			var _cols_len = array_length(_cols);
			gmtl_coverage_table += "\t"
			for (var k = 0; k < _cols_len; k++) {
				gmtl_coverage_table += _cols[k] + (k == 0 ? "| " : "");
			}
			gmtl_coverage_table += "\n";
		}
	}
	
	show_debug_message(gmtl_coverage_table);
}