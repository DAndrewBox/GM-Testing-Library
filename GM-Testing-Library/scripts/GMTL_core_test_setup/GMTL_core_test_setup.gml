/// @func	suite(fn)
/// @param	{function}	fn
function suite(_suite) {
	__gmtl_internal_fn_suite_add_to_queue(_suite);
}

/// @func	describe(name, fn)
/// @param	{string}	name
/// @param	{function}	fn
function describe(_name, _fn) {
	gmtl_suite_continue = true;
	gmtl_indent = 0;
	__gmtl_internal_fn_log($"\n------- {_name} -------");

	try {
		if (is_callable(gmtl_test_before_all)) {
			script_execute(gmtl_test_before_all);
		}
		
		_fn();
		
		if (is_callable(gmtl_test_after_all)) {
			script_execute(gmtl_test_after_all);
		}
	} catch(e) {
		__gmtl_internal_fn_log(e);
	} finally {
		gmtl_indent = 0;
		gmtl_test_before_all = noone;
		gmtl_test_after_all = noone;
		gmtl_test_before_each = noone;
		gmtl_test_after_each = noone;
	}
}

/// @func	it(name, fn, args)
/// @param	{string}		name
/// @param	{function}	fn
/// @param	{array}		args
function it(_name, _fn, _args = []) {
	gmtl_test_status = __gmtl_test_status.RUN;
	gmtl_indent = 1;
	gmtl_coverage_tests.total++;
	
	gmtl_internal.keys.hold		= vk_nokey;
	gmtl_internal.keys.press	= vk_nokey;
	gmtl_internal.keys.release	= vk_nokey;
	__gmtl_internal_fn_mouse_reset();
	
	if (!gmtl_suite_continue) {
		__gmtl_internal_fn_log_test_skipped(_name);
		gmtl_coverage_tests.skipped++;
		return;
	}

	var _fn_to_run = __gmtl_internal_fn_get_function_index(_fn);
	var _time = get_timer();
	try {
		if (is_callable(gmtl_test_before_each)) {
			script_execute(gmtl_test_before_each);
		}
		
		if (_fn_to_run == -1) {
			gmtl_indent = 2;
			__gmtl_internal_fn_log("ERROR: Trying to run a function or method that doesn't exist or is not callable.");
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
			gmtl_indent = 2;
			var _tests_stacktrace_len = array_length(gmtl_test_log);
			for (var i = 0; i < _tests_stacktrace_len; i++) {
				__gmtl_internal_fn_log(gmtl_test_log[i]);
			}
		}
	} catch(e) {
		_time = get_timer() - _time;
		__gmtl_internal_fn_log_test_failed(_name, _time);
		gmtl_coverage_tests.failed++;
		
		gmtl_indent = 2;
		var _tests_stacktrace_len = array_length(gmtl_test_log);
		for (var i = 0; i < _tests_stacktrace_len; i++) {
			__gmtl_internal_fn_log(gmtl_test_log[i]);
		}
		__gmtl_internal_fn_log(e.message);
		__gmtl_internal_fn_log(
			string_copy(e.longMessage, string_pos("(line", e.longMessage), string_length(e.longMessage) - string_pos("(line", e.longMessage))
		);
		
		gmtl_suite_last_failed = true;
		gmtl_suite_continue = false;
	} finally {
		gmtl_indent = 1;
		gmtl_test_log = [];
		if (is_callable(gmtl_test_after_each)) {
			script_execute(gmtl_test_after_each);
		}
	}
}

/// @func	section(name, fn)
/// @param	{string}	name
/// @param	{function}	fn
function section(_name, _fn) {
	describe(_name, _fn);
}

/// @func	test(name, fn, args)
/// @param	{string}	name
/// @param	{function}	fn
/// @param	{array}		args
function test(_name, _fn, _args = []) {
	it(_name, _fn, _args);
}

/// @func	skip(name, fn, args)
/// @param	{string}	name
/// @param	{function}	fn
/// @param	{array}		args
function skip(_name, _fn, _args = []) {
	gmtl_test_status = __gmtl_test_status.SKIP;
	gmtl_indent = 1;
	gmtl_coverage_tests.total++;
	
	__gmtl_internal_fn_log_test_skipped(_name);
	gmtl_coverage_tests.skipped++;
	
	gmtl_test_log = [];
}

/// @func	each(name, fn, cases)
/// @param	{string}	name
/// @param	{function}	fn
/// @param	{array}		cases
function each(_name, _fn, _cases) {
	var _cases_len = array_length(_cases);
	var _name_with_params;
	for (var i = 0; i < _cases_len; i++) {
		_name_with_params = string_ext(_name, _cases[i]);
		it($"{_name_with_params} [Case {i + 1}]", _fn, _cases[i]);
	}
}
