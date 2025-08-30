/// @func	expect(value, args)
/// @param	{Any}	value
/// @param	{Array}	args
function expect(_val, _args = []) {
	if (gmtl_suite_continue) {
		return new TestCase(_val, _args);
	}
}

/// @func	create(x, y, object_index, params)
/// @param	{Real}				x
/// @param	{Real}				y
/// @param	{Asset.GMObject}	object_index
/// @param	{Struct}			params
function create(_x, _y, _obj, _params = {}) {
	if (gmtl_suite_continue) {
		static _layer_name = "__GMTL_LAYER_TESTING";
		var _layer = layer_exists(_layer_name) ? layer_get_id(_layer_name) : layer_create(0, _layer_name);
		var _inst = instance_create_layer(_x, _y, _layer, _obj, _params);
		_inst.waitFor = method(_inst.id, function (_time, _unit) {
			__gmtl_internal_fn_wait_for(id, _time, _unit);
		});
		
		return _inst;
	}
}

/// @func	beforeAll(fn)
/// @param	{Function | Asset.GMScript}	fn
function beforeAll(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_before_all = _fn;
}

/// @func	afterAll(fn)
/// @param	{Function | Asset.GMScript}	fn
function afterAll(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_after_all = _fn;
}

/// @func	beforeEach(fn)
/// @param	{Function | Asset.GMScript}	fn
function beforeEach(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_before_each = _fn;
}

/// @func	afterEach(fn)
/// @param	{Function | Asset.GMScript}	fn
function afterEach(_fn) {
	_fn = __gmtl_internal_fn_get_fn_index(_fn);
	gmtl_test_after_each = _fn;
}
