/// @func	__gmtl_dep_fn_string_percentage()
/// @param	{Real}	current_value
/// @param	{Real}	100%_value
/// @ignore
function __gmtl_dep_fn_string_percentage(_val, _max) {	
	static percentage = function (_val, _max) {
		static round_dec = function (_x, _dec = 0) {
			var _n = power(10, _dec);
			return round(_x * _n) / _n;
		}
		
		return round_dec(100 * (_val / _max), 2);
	}
	return string(percentage(_val, _max)) + "%";
}

/// @func	__gmtl_dep_fn_string_pad_right(string, char, size)
/// @param	{String}	string
/// @param	{String}	char
/// @param	{Real}		size
/// @ignore
function __gmtl_dep_fn_string_pad_right(_str, _char, _size) {
	if (_char == "") return _str;
	var _pad = "";
	var _pad_size = _size - string_length(_str);
	
	for (var i = 0; i < _pad_size; i++) {
		_pad += _char;
	}
	
	return _str + _pad;
}