/// @func	__gmtl_internal_fn_log(message)
/// @param	{String}	message
/// @ignore
function __gmtl_internal_fn_log(_msg) {
	var _pad_left = "";
	for (var i = 0; i < ((gmtl_indent_offset - 1) + gmtl_indent) * 2; i++) {
		_pad_left += "\t";
	}
	_msg = _pad_left + _msg;
	
	gmtl_log += _msg + "\n";
}

/// @func	__gmtl_internal_fn_log_test_success(message, time)
/// @param	{String}	message
/// @param	{Real}	time
/// @ignore
function __gmtl_internal_fn_log_test_success(_msg, _time) {
	__gmtl_internal_fn_log($"├── ✔ {_msg} ({_time / 1000}ms)");
}

/// @func	__gmtl_internal_fn_log_test_failed(message, time)
/// @param	{String}	message
/// @param	{Real}	time
/// @ignore
function __gmtl_internal_fn_log_test_failed(_msg, _time) {
	__gmtl_internal_fn_log($"├── ❌ {_msg} ({_time / 1000}ms)");
}

/// @func	__gmtl_internal_fn_log_test_skipped(message)
/// @param	{String}	message
/// @ignore
function __gmtl_internal_fn_log_test_skipped(_msg) {
	__gmtl_internal_fn_log($"├── ⚠ (Skipped) {_msg}");
}

/// @func	__gmtl_internal_fn_has_finished()
/// @ignore
function __gmtl_internal_fn_has_finished() {
	if (!variable_global_exists("__gmtl_internal")) {
		__gmtl_setup();
	}
	
	return gmtl_internal.finished;
}

/// @func	__gmtl_internal_fn_is_initializing()
/// @ignore
function __gmtl_internal_fn_is_initializing() {
	if (!variable_global_exists("__gmtl_internal")) {
		__gmtl_setup();
	}
	
	return gmtl_internal.initializing;
}


/// @func	__gmtl_internal_fn_suite_add_to_queue(suite)
/// @param	{Function}	suite
/// @ignore
function __gmtl_internal_fn_suite_add_to_queue(_suite) {
	var _ts = time_source_create(time_source_game, 2, time_source_units_frames, function(_suite) {
		array_push(gmtl_suite_list, _suite);
		gmtl_coverage_suites.total++;
	}, [_suite]);
	time_source_start(_ts);
}

/// @func	__gmtl_internal_fn_wait_for(instance, time, unit)
/// @param	{Id.Instance | Constant.All}	instance
/// @param	{Real}							time
/// @param	{Real}							unit
/// @ignore
function __gmtl_internal_fn_wait_for(_inst, _t, _unit) {
	_t = (_unit == time_source_units_seconds ? _t * game_get_speed(gamespeed_fps) : _t);
	var _count = 0;
	
	while (_count < _t) {
		// Simulate all timesources
		if (_inst == all) {
			var _ts_len = array_length(gmtl_timesources);
			for (var i = 0; i < _ts_len; i++) {
				if (gmtl_timesources[i] == -1) continue;
				gmtl_timesources[i].frameCheck();
			}
		}
		
		// Simulate frame dependant events into instances
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
/// @ignore
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
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_keyboard_check(_btn) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		return gmtl_internal.keys[$ _btn];
	}
	
	return original_keyboard_check(_btn);
}

/// @func	__gmtl_internal_fn_keyboard_check_pressed(button)
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_keyboard_check_pressed(_btn) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		return gmtl_internal.keys[$ _btn];
	}
	
	return original_keyboard_check_pressed(_btn);
}

/// @func	__gmtl_internal_fn_keyboard_check_released(button)
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_keyboard_check_released(_btn) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		return (struct_exists(gmtl_internal.keys, string(_btn)) && !gmtl_internal.keys[$ _btn]);
	}
	
	return original_keyboard_check_released(_btn); 
}

/// @func	__gmtl_internal_fn_keyboard_clear(button)
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_keyboard_clear(_btn) {
	original_keyboard_clear(_btn);
	delete gmtl_internal.keys[$ _btn];
}

/// @func	__gmtl_internal_fn_gamepad_button_check(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_gamepad_button_check(_device, _btn) {
	return original_gamepad_button_check(_device, _btn) || gmtl_internal.gamepad[_device][$ _btn];
}

/// @func	__gmtl_internal_fn_gamepad_button_check_pressed(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_gamepad_button_check_pressed(_device, _btn) {
	return original_gamepad_button_check_pressed(_device, _btn) || gmtl_internal.gamepad[_device][$ _btn];
}

/// @func	__gmtl_internal_fn_gamepad_button_check_released(device, button)
/// @param	{Real}	device
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_gamepad_button_check_released(_device, _btn) {
	return original_gamepad_button_check_released(_device, _btn) || !gmtl_internal.gamepad[_device][$ _btn];
}

/// @func	__gmtl_internal_fn_mouse_button_to_map(button)
/// @param	{Real}		button
/// @ignore
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
/// @param	{String}	state
/// @ignore
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
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_mouse_check_button(_btn) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		if (_btn == mb_any) {
			return __gmtl_internal_fn_mouse_check_anykey(true, "hold") || __gmtl_internal_fn_mouse_check_anykey(true, "press");
		}
	
		if (_btn == mb_none) {
			return __gmtl_internal_fn_mouse_check_anykey(false, "hold") || __gmtl_internal_fn_mouse_check_anykey(false, "press")
		}
	
		var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
		return  gmtl_internal.mouse[$ _key].hold || gmtl_internal.mouse[$ _key].press;
	
	}

	return original_mouse_check_button(_btn);
}

/// @func	__gmtl_internal_fn_mouse_check_button_pressed(button)
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_mouse_check_button_pressed(_btn) {	
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		if (_btn == mb_any) {
			return __gmtl_internal_fn_mouse_check_anykey(true, "press");
		}
	
		if (_btn == mb_none) {
			return __gmtl_internal_fn_mouse_check_anykey(false, "press");
		}
	
		var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
		return gmtl_internal.mouse[$ _key].press;
	}
	
	return original_mouse_check_button_pressed(_btn);
}

/// @func	__gmtl_internal_fn_mouse_check_button_released(button)
/// @param	{Real}	button
/// @ignore
function __gmtl_internal_fn_mouse_check_button_released(_btn) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		if (_btn == mb_any) {
			return __gmtl_internal_fn_mouse_check_anykey(true, "release");
		}
	
		if (_btn == mb_none) {
			return __gmtl_internal_fn_mouse_check_anykey(false, "release");
		}
	
		var _key = __gmtl_internal_fn_mouse_button_to_map(_btn);
		return gmtl_internal.mouse[$ _key].release;
	}

	return original_mouse_check_button_released(_btn);	
}

/// @func	__gmtl_internal_fn_mouse_reset()
/// @ignore
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
/// @ignore
function __gmtl_internal_fn_mouse_get_x() {
	if (gmtl_has_finished) {
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
/// @ignore
function __gmtl_internal_fn_mouse_get_y() {
	if (gmtl_has_finished) {
		var _h_camera = camera_get_view_height(view_camera[view_current]);
		var _h_window = window_get_height(); 
		var _y = (display_mouse_get_y() - window_get_y()) * (1 / _h_window);
		_y = clamp(_y, 0, 1);
		_y = _y * _h_camera;
		return floor(_y);
	}
	
	return gmtl_internal.mouse.y;
}

/// @func	__gmtl_internal_fn_io_clear()
/// @ignore
function __gmtl_internal_fn_io_clear() {
	original_io_clear();
	
	// Clear all io's
	delete gmtl_internal.keys;
	delete gmtl_internal.mouse;
	
	// Re-generate io's
	gmtl_internal.keys = {};
	gmtl_internal.mouse = {
		left:	new GTML_MouseState(),
		right:	new GTML_MouseState(),
		middle:	new GTML_MouseState(),
		side1:	new GTML_MouseState(),
		side2:	new GTML_MouseState(),
		x:		0,
		y:		0,
	};
	gmtl_internal.gamepad = array_create_ext(8, function() {
		return {}
	});
}

/// @func	__gmtl_internal_fn_get_fn_index(fn)
/// @param	{Function}	fn
/// @ignore
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
/// @param	{Function}	suite
/// @ignore
function __gmtl_internal_fn_call_suite(_suite) {
	gmtl_suite_last_failed = false;
	try {
		gmtl_indent_offset = 0;
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
	}
}

/// @func	__gmtl_internal_fn_finish_suites(time_start)
/// @param	{Real}	time_start
/// @ignore
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
	__gmtl_internal_fn_log($"\nAll tests finished in {_time}.\n");
	gmtl_internal.finished = true;
	show_debug_message(gmtl_log);
}

/// @func	__gmtl_internal_fn_find_coverage_files()
/// @ignore
function __gmtl_internal_fn_find_coverage_files() {
	// Parse the project directory path. (Fix for Ubuntu and Mac exports)
	var _parsed_dir = string_replace_all(GM_project_filename, "/", "\\");
	var _dir_path = string_copy(_parsed_dir, 1, string_last_pos("\\", _parsed_dir));
	var _dir_exists = directory_exists(_dir_path);
	
	// Find all scripts in the project (saved as folders)
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
	
	// If folder is not found, early return
	if (array_length(_folders) == 0) return;
		
	// For every folder, find all *.gml files to find coverage for
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
		
	// Once all files has been found, get all the function names inside every file to index
	var _files_len = array_length(_coverage_files);
	for (var i = 0; i < _files_len; i++) {
		var _fns = [];
		var _file = file_text_open_read(_coverage_files[i]);
		
		while (!file_text_eof(_file)) {
			var _cur_line = file_text_readln(_file);
			var _fn_starts_at = string_pos("function", _cur_line);
			var _fn_ends_at = string_pos_ext("(", _cur_line, _fn_starts_at);
			var _skip_lines_with_these_words = [
				"@",
				"//",
				"__",
				"new "
			];
			var _skip_lines_len = array_length(_skip_lines_with_these_words);
			var _should_skip_line = false;
			for (var j = 0; j < _skip_lines_len; j++) {
				if (string_pos(_skip_lines_with_these_words[j], _cur_line) > 0) {
					_should_skip_line = true;
					break;
				}
			}
			
			if (_fn_starts_at > 0 && _fn_ends_at > 0 && !_should_skip_line) {
				var _fn_name = string_copy(_cur_line, _fn_starts_at + 8, _fn_ends_at - (_fn_starts_at + 8));
				_fn_name = string_trim(_fn_name);

				if (string_pos("=", _fn_name)) continue;
				if (_fn_name != "") {
					array_push(_fns, { name: _fn_name, covered: false });
				}
			}
		}
		
		// If there are functions inside the file
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
/// @ignore
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

/// @func	__gmtl_internal_fn_set_key_state(key, press)
/// @param	{Real}	key
/// @param	{Bool}	press
/// @ignore
function __gmtl_internal_fn_set_key_state(_key, _press) {
	gmtl_internal.keys[$ _key] = _press;
}

/// @func	__gmtl_internal_fn_set_gamepad_button_state(device, button, press)
/// @param	{Real}	device
/// @param	{Real}	button
/// @param	{Bool}	press
/// @ignore
function __gmtl_internal_fn_set_gamepad_button_state(_device, _btn, _press) {
	gmtl_internal.gamepad[_device][$ _btn] = _press;
}

///	@func	__gmtl_internal_fn_time_source_create(parent, period, units, callback, args, repetitions, expiryType)
///	@param	{Any}							parent
///	@param	{Real}							period
///	@param	{Constant.TimeSourceUnits}		units
///	@param	{Function}						callback
///	@param	{Array}							args
///	@param	{Real}							reps
///	@param	{Constant.TimeSourceExpiryType}	expiryType
/// @ignore
function __gmtl_internal_fn_time_source_create(_parent, _period, _units, _cb, _args = [], _reps = 1, _expiry = time_source_expire_nearest) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		var _ts = simulateTimeSource(_parent, _period, _units, _cb, _args, _reps, _expiry);
		return _ts;
	}
	return original_time_source_create(_parent, _period, _units, _cb, _args, _reps, _expiry);
}

///	@func	__gmtl_internal_fn_time_source_start(id)
///	@param	{Any}	id
/// @ignore
function __gmtl_internal_fn_time_source_start(_ts) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		_ts.start();
		return;
	}	
	original_time_source_start(_ts);
}

///	@func	__gmtl_internal_fn_time_source_stop(id)
///	@param	{Any}	id
/// @ignore
function __gmtl_internal_fn_time_source_stop(_ts) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		_ts.stop();	
		return;
	}
	original_time_source_stop(_ts);
}

///	@func	__gmtl_internal_fn_time_source_pause(id)
///	@param	{Any}	id
/// @ignore
function __gmtl_internal_fn_time_source_pause(_ts) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		_ts.pause();
		return;
	}
	original_time_source_pause(_ts);
}

///	@func	__gmtl_internal_fn_time_source_resume(id)
///	@param	{Any}	id
/// @ignore
function __gmtl_internal_fn_time_source_resume(_ts) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		_ts.resume();
		return;
	}
	original_time_source_resume(_ts);
}

///	@func	__gmtl_internal_fn_time_source_destroy(id)
///	@param	{Any}	id
/// @ignore
function __gmtl_internal_fn_time_source_destroy(_ts) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		var _all_ts_len = array_length(gmtl_timesources);
		for (var i = 0; i < _all_ts_len; i++) {
			if (is_struct(gmtl_timesources[i]) && gmtl_timesources[i].__internal_id == _ts.__internal_id) {
				_ts.stop();
				delete gmtl_timesources[i];
			}
		}
		
		gmtl_timesources = array_filter(gmtl_timesources, function (_elem) {
			return is_struct(_elem);
		});
		return;
	}
	original_time_source_destroy(_ts);
}

///	@func	__gmtl_internal_fn_call_later(period, units, callback, loop)
///	@param	{Real}						period
///	@param	{Constant.TimeSourceUnits}	units
///	@param	{Function}					callback
///	@param	{Bool}						loop
/// @ignore
function __gmtl_internal_fn_call_later(_period, _units, _cb, _loop = false) {
	if (!gmtl_has_finished && !gmtl_is_initializing) {
		var _ts = simulateCallLater(_period, _units, _cb, _loop);
		return _ts;
	}
	return original_call_later(_period, _units, _cb, _loop);
}