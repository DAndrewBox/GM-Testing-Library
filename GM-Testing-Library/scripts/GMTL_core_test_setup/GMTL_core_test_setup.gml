/// @func	suite(fn)
/// @param	{Function}	fn
function suite(_suite) {
	__gmtl_internal_fn_suite_add_to_queue(_suite);
}

/// @func	describe(name, fn)
/// @param	{String}	name
/// @param	{Function}	fn
function describe(_name, _fn) {
	gmtl_indent_offset++;
	gmtl_suite_continue = true;
	gmtl_indent = 0;
	__gmtl_internal_fn_log($"{gmtl_indent_offset <= 1 ? "──" : "└──"} {_name}");

	try {
		if (is_callable(gmtl_test_before_all)) {
			// Feather ignore once GM1041 - Since `is_callable` is used to validate, this is always a Function.
			script_execute(gmtl_test_before_all);
		}
		
		_fn();
		__gmtl_internal_fn_log("");
		
		if (is_callable(gmtl_test_after_all)) {
			// Feather ignore once GM1041 - Since `is_callable` is used to validate, this is always a Function.
			script_execute(gmtl_test_after_all);
		}
	} catch(e) {
		__gmtl_internal_fn_log(e);
	} finally {
		// If a test made the suite fail or the status of the last test is "skipped"
		if (!gmtl_suite_last_failed || gmtl_test_status == __gmtl_test_status.SKIP) {
			// Replace the last test pipe for a closure pipe
			var _last_pipe = string_last_pos("├", gmtl_log);
			gmtl_log = string_insert("└", gmtl_log, _last_pipe);
			gmtl_log = string_delete(gmtl_log, _last_pipe + 1, 1);
		}
		
		// Reset everything for next describe
		gmtl_indent = 0;
		gmtl_indent_offset = 0;
		gmtl_test_before_all = noone;
		gmtl_test_after_all = noone;
		gmtl_test_before_each = noone;
		gmtl_test_after_each = noone;
	}
}

/// @func	it(name, fn, args)
/// @param	{String}		name
/// @param	{Function}	fn
/// @param	{Array}		args
function it(_name, _fn, _args = []) {
	gmtl_test_status = __gmtl_test_status.RUN;
	gmtl_indent = 1;
	gmtl_coverage_tests.total++;
	
	__gmtl_internal_fn_mouse_reset();
	
	if (!gmtl_suite_continue) {
		gmtl_test_status = __gmtl_test_status.SKIP;
		__gmtl_internal_fn_log_test_skipped(_name);
		gmtl_coverage_tests.skipped++;
		return;
	}

	var _fn_to_run = __gmtl_internal_fn_get_fn_index(_fn);
	var _time = get_timer();
	try {
		if (is_callable(gmtl_test_before_each)) {
			// Feather ignore once GM1041 - Since `is_callable` is used to validate, this is always a Function.
			script_execute(gmtl_test_before_each);
		}
		
		if (_fn_to_run == -1) {
			gmtl_indent = 2;
			__gmtl_internal_fn_log("└── ERROR: Trying to run a function or method that doesn't exist or is not callable.");
		}
		
		script_execute_ext(_fn_to_run, _args);
		_time = get_timer() - _time;

		if (gmtl_test_status == __gmtl_test_status.SUCCESS) {
			__gmtl_internal_fn_log_test_success(_name, _time);
			gmtl_coverage_tests.success++;
		} else if (gmtl_test_status == __gmtl_test_status.FAILED) {
			__gmtl_internal_fn_log_test_failed(_name, _time);
			gmtl_coverage_tests.failed++;
			gmtl_suite_last_failed = true;
			gmtl_indent = 1;
			var _tests_stacktrace_len = array_length(gmtl_test_log);
			for (var i = 0; i < _tests_stacktrace_len; i++) {
				var _prefix_pipe = i != _tests_stacktrace_len - 1 ? "│ \t├── " : "│ \t└── ";
				__gmtl_internal_fn_log(_prefix_pipe + gmtl_test_log[i]);
			}
		}
	} catch(e) {
		_time = get_timer() - _time;
		__gmtl_internal_fn_log_test_failed(_name, _time);
		gmtl_coverage_tests.failed++;
		
		gmtl_indent = 1;
		var _tests_stacktrace_len = array_length(gmtl_test_log);
		for (var i = 0; i < _tests_stacktrace_len; i++) {
			var _prefix_pipe = i != _tests_stacktrace_len - 1 ? "│\t├── " : "│\t└── ";
			__gmtl_internal_fn_log(_prefix_pipe + gmtl_test_log[i]);
		}
		
		if (!_tests_stacktrace_len) {
			__gmtl_internal_fn_log("│ \t├── " + e.message);
			__gmtl_internal_fn_log(
				"│ \t└── " + 
				string_copy(e.longMessage, string_pos("(line", e.longMessage), string_length(e.longMessage) - string_pos("(line", e.longMessage))
			);
		}
		
		gmtl_suite_last_failed = true;
		gmtl_suite_continue = false;
	} finally {
		// Resets indentation
		gmtl_indent = 1;
		gmtl_test_log = [];
		
		// Executes the afterEach() events
		if (is_callable(gmtl_test_after_each)) {
			// Feather ignore once GM1041 - Since `is_callable` is used to validate, this is always a Function.
			script_execute(gmtl_test_after_each);
		}
		
		// Resets all timesources to prevent timesource leaks between tests
		gmtl_timesources = [];
	}
}

/// @func	section(name, fn)
/// @param	{String}		name
/// @param	{Function}	fn
function section(_name, _fn) {
	describe(_name, _fn);
}

/// @func	test(name, fn, args)
/// @param	{String}		name
/// @param	{Function}	fn
/// @param	{Array}			args
function test(_name, _fn, _args = []) {
	it(_name, _fn, _args);
}

/// @func	skip(name, fn, args)
/// @param	{String}		name
/// @param	{Function}	fn
/// @param	{Array}			args
function skip(_name, _fn, _args = []) {
	gmtl_test_status = __gmtl_test_status.SKIP;
	gmtl_indent = 1;
	gmtl_coverage_tests.total++;
	
	__gmtl_internal_fn_log_test_skipped(_name);
	gmtl_coverage_tests.skipped++;
	
	gmtl_test_log = [];
}

/// @func	each(name, fn, cases)
/// @param	{String}		name
/// @param	{Function}	fn
/// @param	{Array}			cases
function each(_name, _fn, _cases) {
	var _cases_len = array_length(_cases);
	var _name_with_params;
	for (var i = 0; i < _cases_len; i++) {
		_name_with_params = string_ext(_name, _cases[i]);
		it($"{_name_with_params} [Case {i + 1}]", _fn, _cases[i]);
	}
}
