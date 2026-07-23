/*
	GameMaker Testing Library
	Version: v1.2
	Release date: 2026-05-04
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
	// Idempotent: never wipe an already-initialized state. Suites are registered
	// synchronously by suite() and, depending on the game's global-init order, that can
	// happen before this pragma runs. A second setup call must not discard them.
	if (variable_global_exists("__gmtl_internal")) return;

	global.__gmtl_async_event_map = -1;
	gmtl_internal = {
		indent:	0,
		indent_describe_offset: 0,
		log:	"",
		tests: {
			log:	[],
			status: __gmtl_test_status.RUN,
			before_all: noone,
			before_all_ran: false,
			after_all: noone,
			before_each: [],
			after_each: [],
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
		running: false,
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
		if (gmtl_show_coverage) {
			__gmtl_internal_fn_find_coverage_files();
		}

		var _t_start = get_timer();
		var _suites_len = array_length(gmtl_suite_list);

		// Mocking is only active while suites are actually executing. Any timesource,
		// input, etc. created by game/library code OUTSIDE this window hits the real
		// engine functions. Prevents boot-window timesources from being silently mocked.
		gmtl_internal.running = true;
		for (var i = 0; i < _suites_len; i++) {
			__gmtl_internal_fn_call_suite(gmtl_suite_list[i]);
		}
		gmtl_internal.running = false;

		__gmtl_internal_fn_finish_suites(_t_start);

		if (gmtl_show_coverage) {
			__gmtl_internal_fn_show_coverage_table();
		}
		
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
