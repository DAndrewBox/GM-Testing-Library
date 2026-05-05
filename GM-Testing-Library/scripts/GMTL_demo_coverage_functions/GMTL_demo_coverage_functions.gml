/// @func	coverage_add(a, b)
/// @ignore
/// @param	{Real}	a
/// @param	{Real}	b
function coverage_add(_a, _b) {
	return _a + _b;
}

/// @func	coverage_subtract(a, b)
/// @ignore
/// @param	{Real}	a
/// @param	{Real}	b
function coverage_subtract(_a, _b) {
	return _a - _b;
}

/// @func	coverage_multiply(a, b)
/// @ignore
/// @param	{Real}	a
/// @param	{Real}	b
function coverage_multiply(_a, _b) {
	return _a * _b;
}

/// @func	coverage_divide(a, b)
/// @ignore
/// @param	{Real}	a
/// @param	{Real}	b
function coverage_divide(_a, _b) {
	if (_b == 0) return undefined;
	return _a / _b;
}

/// @func	coverage_clamp(value, min, max)
/// @ignore
/// @param	{Real}	value
/// @param	{Real}	min
/// @param	{Real}	max
function coverage_clamp(_val, _min, _max) {
	return clamp(_val, _min, _max);
}

/// @func	coverage_is_even(n)
/// @ignore
/// @param	{Real}	n
function coverage_is_even(_n) {
	return (_n mod 2) == 0;
}

/// @func	coverage_string_reverse(str)
/// @ignore
/// @param	{String}	str
function coverage_string_reverse(_str) {
	var _result = "";
	var _len = string_length(_str);
	for (var i = _len; i >= 1; i--) {
		_result += string_char_at(_str, i);
	}
	return _result;
}

/// @func	coverage_array_sum(arr)
/// @ignore
/// @param	{Array}	arr
function coverage_array_sum(_arr) {
	var _sum = 0;
	var _len = array_length(_arr);
	for (var i = 0; i < _len; i++) {
		_sum += _arr[i];
	}
	return _sum;
}

/// @func	coverage_fibonacci(n)
/// @ignore
/// @param	{Real}	n
function coverage_fibonacci(_n) {
	if (_n <= 1) return _n;
	return coverage_fibonacci(_n - 1) + coverage_fibonacci(_n - 2);
}

/// @func	coverage_uncalled_function()
/// @ignore
function coverage_uncalled_function() {
	// This function is intentionally never called in tests
	// It should appear as uncovered in the coverage report
	return "never called";
}
