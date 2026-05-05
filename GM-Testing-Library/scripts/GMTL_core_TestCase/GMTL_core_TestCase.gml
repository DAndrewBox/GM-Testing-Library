/// @func	TestCase(value)
/// @param	{Any}	value
/// @param	{Array}	args
function TestCase(_val, _args) constructor {
	__internal_value = _val;
	__internal_args = _args;

	// Mark coverage when a named function is passed to expect()
	if (gmtl_show_coverage && is_callable(_val)) {
		var _fn_name = "";
		var _idx = is_method(_val) ? method_get_index(_val) : _val;
		if (is_real(_idx) && script_exists(_idx)) {
			_fn_name = script_get_name(_idx);
		}
		if (_fn_name != "" && _fn_name != "<undefined>" && string_pos("anon@", _fn_name) == 0) {
			__gmtl_internal_fn_coverage_mark(_fn_name);
		}
	}
	
	__not = false;
	__not_str_method = "";
	__not_str_expected = "";
	
	/// @func	never()
	function never() {
		__not = !__not;
		__not_str_method = ".never";
		__not_str_expected = "(Not)";
		return self;
	}
	
	/// @func toBe(expected_result)
	/// @param	{Any}	expected_result
	function toBe(_expectedResult) {
		var _isValid;
		if (is_array(__internal_value) && is_array(_expectedResult)) {
			_isValid = array_equals(__internal_value, _expectedResult);
		} else {
			_isValid = __internal_value == _expectedResult;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBe({_expectedResult}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? _expectedResult : $"{__not_str_expected} {_expectedResult}"}");
			array_push(gmtl_test_log, $"- Received Result: {__internal_value}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeEqual(expected_result)
	/// @param	{Any}	expected_result
	function toBeEqual(_expectedResult) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		
		switch (_typeOf) {
			case "array":
				_isValid = array_equals(__internal_value, _expectedResult);
				break;
			case "struct":
				_isValid = variable_get_hash(__internal_value) == variable_get_hash(_expectedResult);
				break;
			default:
				toBe(_expectedResult);
				return;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeEqual({_expectedResult}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? _expectedResult : $"{__not_str_expected} {_expectedResult}"}");
			array_push(gmtl_test_log, $"- Received Result: {__internal_value}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toHaveReturned()
	function toHaveReturned() {
		var _isValid = !is_undefined(__internal_value) && is_callable(__internal_value);
		if (_isValid) {
			var _received = undefined;
			var _fn_to_run = __gmtl_internal_fn_get_fn_index(__internal_value);
			if (is_callable(_fn_to_run)) {
				try {
					_received = script_execute_ext(_fn_to_run, __internal_args);
				} catch(e) {
					var _prev_indent = gmtl_indent;
					gmtl_indent = 2;
					__gmtl_internal_fn_log(e.message);
					gmtl_indent = _prev_indent;
				}
			}
			
			_isValid = _received != undefined;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toHaveReturned():");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? "true" : $"{__not_str_expected} true"}");
			array_push(gmtl_test_log, $"- Received Result: {__internal_value}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {			
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toHaveReturnedWith(expected_result)
	/// @param	{Any}	expected_result
	function toHaveReturnedWith(_expectedResult) {
		var _isValid = !is_undefined(__internal_value) && is_callable(__internal_value);
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			var _received = undefined;
			var _fn_to_run = __gmtl_internal_fn_get_fn_index(__internal_value);
			if (is_callable(_fn_to_run)) {
				try {
					_received = script_execute_ext(_fn_to_run, __internal_args);
				} catch(e) {
					var _prev_indent = gmtl_indent;
					gmtl_indent = 2;
					__gmtl_internal_fn_log(e.message);
					gmtl_indent = _prev_indent;
				}
			}
			
			array_push(gmtl_test_log, $"> expect({__internal_value}, {__internal_args}).toHaveReturnedWith({_expectedResult}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? _expectedResult : $"{__not_str_expected} {_expectedResult}"}");
			array_push(gmtl_test_log, $"- Received Result: {_received}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toHaveLength(number)
	/// @param	{Real}	number
	function toHaveLength(_n) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		var _len	 = 0;
		
		switch (_typeOf) {
			case "array":
				_len = array_length(__internal_value);
				break;
			case "struct":
				_len = array_length(variable_struct_get_names(__internal_value));
				break;
			case "string":
				_len = string_length(__internal_value);
				break;
			default:
				_typeInvalid = true;
		}		
		
		_isValid = _n == _len;
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			var _type_of_msg = $"<Invalid Type: {_typeOf}>";
			_type_of_msg = (_typeInvalid ? _type_of_msg  : string(_len));
			array_push(gmtl_test_log, $">expect({__internal_value}){__not_str_method}.toHaveLength({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? string(_n) : $"{__not_str_expected} {_n}"}");
			array_push(gmtl_test_log, $"- Received Result: {_type_of_msg}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toHaveProperty(key, value)
	/// @param	{String}	key
	/// @param	{Any}	value
	function toHaveProperty(_key, _value = undefined) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		var _valueIsUndefined = is_undefined(_value);
		
		switch (_typeOf) {
			case "struct":
				if (!_valueIsUndefined) {
					_isValid = __internal_value[$ _key] == _value;
				} else {
					_isValid = !is_undefined(__internal_value[$ _key]);
				}
				break;
				
			case "ref":
				// If is not an instance
				if !(instance_exists(__internal_value)) {
					_isValid = false;
					break;
				}
				
				var _propValue = variable_instance_get(__internal_value, _key);
				_isValid = !_valueIsUndefined ? _propValue == _value : _propValue;
				break;
				
			default:
				_typeInvalid = true;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			var _expected_not_undefined_msg = $"{_key} = {_value}";
			var _expected_undefined_msg = $"_key != undefined";
			var _expected_message = (!_valueIsUndefined ? _expected_not_undefined_msg : _expected_undefined_msg);
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toHaveProperty({_key}, {_value}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? _expected_message : $"{__not_str_expected} {_expected_message}"}");
			
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				var _isStruct = is_struct(__internal_value);
				if (_isStruct) {
					array_push(gmtl_test_log, $"- Received Result: {_key} = {__internal_value[$ _key]}");
				} else {
					array_push(gmtl_test_log, $"- Received Result: {_key} = {variable_instance_get(__internal_value, _key)}");
				}
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeGreaterThan(number)
	/// @param	{Real}	number
	function toBeGreaterThan(_n) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		
		switch (_typeOf) {
			case "int32":
			case "int64":
			case "number":
				_isValid = __internal_value > _n;
				break;
			default:
				_typeInvalid = true;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeGreaterThan({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} {__internal_value} > {_n}");
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				array_push(gmtl_test_log, $"- Received Result: {__internal_value} <= {_n}");
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeGreaterThanOrEqual(number)
	/// @param	{Real}	number
	function toBeGreaterThanOrEqual(_n) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		
		switch (_typeOf) {
			case "number":
				_isValid = __internal_value >= _n;
				break;
			default:
				_typeInvalid = true;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeGreaterThanOrEqual({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} {__internal_value} >= {_n}");
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				array_push(gmtl_test_log, $"- Received Result: {__internal_value} < {_n}");
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeLessThan(number)
	/// @param	{Real}	number
	function toBeLessThan(_n) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		
		switch (_typeOf) {
			case "number":
				_isValid = __internal_value < _n;
				break;
			default:
				_typeInvalid = true;
		}		
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeLessThan({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} {__internal_value} < {_n}");
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				array_push(gmtl_test_log, $"- Received Result: {__internal_value} >= {_n}");
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeLessThanOrEqual(number)
	/// @param	{Real}	number
	function toBeLessThanOrEqual(_n) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		
		switch (_typeOf) {
			case "number":
				_isValid = __internal_value <= _n;
				break;
			default:
				_typeInvalid = true;
		}		
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeLessThanOrEqual({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} {__internal_value} <= {_n}");
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				array_push(gmtl_test_log, $"- Received Result: {__internal_value} > {_n}");
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeFalsy()
	function toBeFalsy() {
		var _isValid = false;
		var _type_of = typeof(__internal_value);
		
		switch (_type_of) {
			case "bool":
				_isValid = (__internal_value != true);
				break;
			case "string":
				_isValid = (__internal_value == "");
				break;
			default:
				_isValid = is_undefined(__internal_value) || __internal_value <= 0;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeFalsy():");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? "false" : $"{__not_str_expected} false"}");
			array_push(gmtl_test_log, $"- Received Result: true");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toBeTruthy()
	function toBeTruthy() {
		var _isValid = false;
		var _type_of = typeof(__internal_value);
		
		switch (_type_of) {
			case "bool":
				_isValid = (__internal_value == true);
				break;
			case "string":
				_isValid = (__internal_value != "");
				break;
			default:
				_isValid = !is_undefined(__internal_value) || __internal_value > 0;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toBeTruthy():");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} {true}");
			array_push(gmtl_test_log, $"- Received Result: {false}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
	
	/// @func toThrow(expected_message)
	/// @param	{String}	[expected_message]
	function toThrow(_expectedMessage = undefined) {
		var _isCallable = !is_undefined(__internal_value) && is_callable(__internal_value);
		if (!_isCallable) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect({__internal_value}).toThrow(): value is not callable");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
			return;
		}

		var _threw = false;
		var _thrownMessage = "";
		var _fn_to_run = __gmtl_internal_fn_get_fn_index(__internal_value);
		try {
			script_execute_ext(_fn_to_run, __internal_args);
		} catch(e) {
			_threw = true;
			_thrownMessage = is_struct(e) && variable_struct_exists(e, "message") ? e.message : string(e);
		}

		var _isValid = _threw;
		if (_threw && !is_undefined(_expectedMessage)) {
			_isValid = string_pos(string(_expectedMessage), _thrownMessage) > 0;
		}

		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			var _expected = is_undefined(_expectedMessage) ? "throw" : $"throw \"{_expectedMessage}\"";
			var _expected_str = __not_str_expected == "" ? _expected : __not_str_expected + " " + _expected;
			var _received_str = _threw ? "threw \"" + _thrownMessage + "\"" : "did not throw";
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toThrow({_expectedMessage ?? ""}):");
			array_push(gmtl_test_log, $"- Expected Result: {_expected_str}");
			array_push(gmtl_test_log, $"- Received Result: {_received_str}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}

	/// @func toHaveBeenCalled()
	function toHaveBeenCalled() {
		var _isSpy = is_struct(__internal_value) && variable_struct_exists(__internal_value, "__gmtl_spy");
		if (!_isSpy) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect({__internal_value}).toHaveBeenCalled(): value is not a spy - wrap with spy()");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
			return;
		}

		var _isValid = __internal_value.calls > 0;
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect(spy){__not_str_method}.toHaveBeenCalled():");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? "called at least once" : $"{__not_str_expected} called"}");
			array_push(gmtl_test_log, $"- Received Result: called {__internal_value.calls} time(s)");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}

	/// @func toHaveBeenCalledTimes(n)
	/// @param	{Real}	n
	function toHaveBeenCalledTimes(_n) {
		var _isSpy = is_struct(__internal_value) && variable_struct_exists(__internal_value, "__gmtl_spy");
		if (!_isSpy) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect({__internal_value}).toHaveBeenCalledTimes(): value is not a spy - wrap with spy()");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
			return;
		}

		var _isValid = __internal_value.calls == _n;
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect(spy){__not_str_method}.toHaveBeenCalledTimes({_n}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? string(_n) : $"{__not_str_expected} {_n}"} call(s)");
			array_push(gmtl_test_log, $"- Received Result: {__internal_value.calls} call(s)");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}

	/// @func toHaveBeenCalledWith(args)
	/// @param	{Array}	args
	function toHaveBeenCalledWith(_args) {
		var _isSpy = is_struct(__internal_value) && variable_struct_exists(__internal_value, "__gmtl_spy");
		if (!_isSpy) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect({__internal_value}).toHaveBeenCalledWith(): value is not a spy - wrap with spy()");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
			return;
		}

		var _isValid = false;
		var _call_history = __internal_value.call_args;
		var _history_len  = array_length(_call_history);
		for (var i = 0; i < _history_len; i++) {
			if (array_equals(_call_history[i], _args)) {
				_isValid = true;
				break;
			}
		}

		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			array_push(gmtl_test_log, $"> expect(spy){__not_str_method}.toHaveBeenCalledWith({_args}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected == "" ? string(_args) : $"{__not_str_expected} {_args}"}");
			array_push(gmtl_test_log, $"- Received Result: {_history_len > 0 ? string(_call_history) : "never called"}");
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}

	/// @func toContain(value)
	/// @param	{Any}	value
	function toContain(_value) {
		var _typeOf	 = typeof(__internal_value);
		var _isValid = false;
		var _typeInvalid = false;
		var _onPos	 = -1;
		var _arr_len = 0;
		
		switch (_typeOf) {
			case "array":
				_arr_len = array_length(__internal_value);
				_onPos = -1;
				
				for (var i = 0; i < _arr_len; i++) {
					if (__internal_value[i] == _value) {
						_isValid = true;
						_onPos = i;
						break;
					}
				}
				break;
			case "struct":
				var _keys = struct_get_names(__internal_value);
				_arr_len = array_length(_keys);
				_onPos = "";
				
				for (var i = 0; i < _arr_len; i++) {
					if (_keys[i] == _value || __internal_value[$ _keys[i]] == _value) {
						_isValid = true;
						_onPos = _keys[i];
						break;
					}
				}
				break;
			default:
				_typeInvalid = true;
		}
		
		_isValid = __not ? !_isValid : _isValid;
		if (!_isValid) {
			__gmtl_internal_fn_stacktrace();
			
			var _msg_if_string = $"as or in key {_onPos}";
			var _msg_if_array = $"on position index {_onPos}";
			var _expected_message = (is_string(_onPos) ? _msg_if_string : _msg_if_array);
			
			array_push(gmtl_test_log, $"> expect({__internal_value}){__not_str_method}.toContain({_value}):");
			array_push(gmtl_test_log, $"- Expected Result: {__not_str_expected} Found {_expected_message}");
			if (_typeInvalid) {
				array_push(gmtl_test_log, $"- Received Result: <Invalid Type: {_typeOf}>");
			} else {
				array_push(gmtl_test_log, $"- Received Result: Not Found.");
			}
			gmtl_test_status = __gmtl_test_status.FAILED;
			gmtl_suite_continue = false;
		} else {
			gmtl_test_status = __gmtl_test_status.SUCCESS;
		}
	}
}
