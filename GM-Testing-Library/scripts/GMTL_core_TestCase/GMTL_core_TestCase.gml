/// @func	TestCase(value)
/// @param	{Any}	value
/// @param	{Array}	args
function TestCase(_val, _args) constructor {
	__internal_value = _val;
	__internal_args = _args;
	
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
