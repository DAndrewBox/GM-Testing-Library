/*
	GameMaker Testing Library
	Version: v1.0.0
	Release date: 2024-07-19
	Author:	DAndrëwBox
*/
gml_pragma("global", "GMTL_init()");
gml_pragma("global", "GMTL_definitions()");
gml_pragma("global", "GMTL_internal()");
gml_pragma("global", "GMTL_core_test_setup()");
gml_pragma("global", "GMTL_core_test_events()");
gml_pragma("global", "GMTL_core_TestCase()");

gml_pragma("global", "__gmtl_init()");

/// @func __gmtl_init()
function __gmtl_init() {
	gmtl_internal = {
		indent:	0,
		log:	"",
		tests: {
			log:	[],
			status: __gmtl_test_status.RUN,
			before_all: noone,
			after_all: noone,
			before_each: noone,
			after_each: noone,
		},
		suites: {
			list:				[],
			should_continue:	true,
			last_failed:		false,
		},
		coverage: {
			suites: {
				total:		0,
				success:	0,
				failed:		0,
				skipped:	0,
			},
			tests: {
				total:		0,
				success:	0,
				failed:		0,
				skipped:	0,
			},
			files: [],
			table: "",
		},
		keys: {
			hold:		vk_nokey,
			press:		vk_nokey,
			release:	vk_nokey,
		},
		gamepad: array_create_ext(8, function() {
			return {
				hold:		noone,
				press:		noone,
				release:	noone,
			}
		}),
		mouse: {
			left:	new GTML_MouseState(),
			right:	new GTML_MouseState(),
			middle:	new GTML_MouseState(),
			side1:	new GTML_MouseState(),
			side2:	new GTML_MouseState(),
			x:		0,
			y:		0,
		},
		finished: false,
	};

	call_later(10, time_source_units_frames, function() {
		// __gmtl_internal_fn_find_coverage_files();
		
		var _t_start = get_timer();
		var _suites_len = array_length(gmtl_suite_list);
		for (var i = 0; i < _suites_len; i++) {
			__gmtl_internal_fn_call_suite(gmtl_suite_list[i]);
		}
		__gmtl_internal_fn_finish_suites(_t_start);
		// __gmtl_internal_fn_show_coverage_table();
	});
}
