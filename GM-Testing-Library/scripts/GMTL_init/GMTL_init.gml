/*
	GameMaker Testing Library
	Version: v1.1.1c
	Release date: 2025-09-23
	Author:	DAndrëwBox
	https://github.com/DAndrewBox/GM-Testing-Library
*/

gml_pragma("global", "GMTL_init()");
gml_pragma("global", "GMTL_definitions()");
gml_pragma("global", "GMTL_enums()");
gml_pragma("global", "GMTL_internal()");
gml_pragma("global", "GMTL_core_test_setup()");
gml_pragma("global", "GMTL_core_test_events()");
gml_pragma("global", "GMTL_core_test_simulations()");
gml_pragma("global", "GMTL_core_TestCase()");
gml_pragma("global", "GMTL_core_TimeSource()");
gml_pragma("global", "GMTL_core_MouseState()");

gml_pragma("global", "__gmtl_setup()");
gml_pragma("global", "__gmtl_init()");

/// @func __gmtl_setup()
/// @ignore
function __gmtl_setup() {
	gmtl_internal = {
		indent:	0,
		indent_describe_offset: 0,
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
		keys: {},
		gamepad: array_create_ext(8, function() {
			return {}
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
		timesources: [],
		initializing: true,
		finished: false,
	};
}

/// @func __gmtl_init()
/// @ignore
function __gmtl_init() {
	gmtl_internal.initializing = false;

	// Skip all tests
	if (!gmtl_run_at_start) {
		gmtl_internal.finished = true;
		return;
	}

	// Run all tests a few frames after project start.
	original_call_later(gmtl_wait_frames_before_start, time_source_units_frames, function() {
		//__gmtl_internal_fn_find_coverage_files();	// @TODO: Feature not ready. Possibly v1.2.
		
		var _t_start = get_timer();
		var _suites_len = array_length(gmtl_suite_list);
		for (var i = 0; i < _suites_len; i++) {
			__gmtl_internal_fn_call_suite(gmtl_suite_list[i]);
		}
		__gmtl_internal_fn_finish_suites(_t_start);
		// __gmtl_internal_fn_show_coverage_table(); // @TODO: Feature not ready. Possibly v1.2.
		
		// Clean memory
		delete gmtl_internal.tests;
		delete gmtl_internal.suites;
		delete gmtl_internal.coverage;
		
		// Remove all timesources references
		var _all_ts_len = array_length(gmtl_timesources);
		for (var i = 0; i < _all_ts_len; i++) {
			if (is_struct(gmtl_timesources[i])) {
				delete gmtl_timesources[i];
			} else {
				gmtl_timesources[i] = undefined;
			}
		}
		gmtl_timesources = [];
	});
}
