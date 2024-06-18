/// @func	__gmtl_dep_fn_string_percentage()
/// @param	{real}	current_value
/// @param	{real}	100%_value
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