/*
	User defined properties.
	You can edit the value here if needed.
	
	Name							|	Description											|	Default Value
	----------------------------------------------------------------------------------------------------------
	gmtl_run_at_start				|	Run GMTL tests at game start.						|	true
	gmtl_wait_frames_before_start	|	Frames to wait before start running GMTL suites.	|	10

*/
#macro	gmtl_run_at_start					true
#macro	gmtl_wait_frames_before_start		10

/*
	* Internal GTML definitions.
	* DO NOT EDIT BELOW THIS LINE.
*/
#macro	gmtl_internal				global.__gmtl_internal
#macro	gmtl_indent					gmtl_internal.indent
#macro	gmtl_indent_offset			gmtl_internal.indent_describe_offset
#macro	gmtl_log					gmtl_internal.log
#macro	gmtl_test_log				gmtl_internal.tests.log
#macro	gmtl_test_status			gmtl_internal.tests.status
#macro	gmtl_suite_continue			gmtl_internal.suites.should_continue
#macro	gmtl_suite_list				gmtl_internal.suites.list
#macro	gmtl_suite_last_failed		gmtl_internal.suites.last_failed
#macro	gmtl_coverage_files			gmtl_internal.coverage.files
#macro	gmtl_coverage_table			gmtl_internal.coverage.table
#macro	gmtl_coverage_suites		gmtl_internal.coverage.suites
#macro	gmtl_coverage_tests			gmtl_internal.coverage.tests
#macro	gmtl_timesources			gmtl_internal.timesources
#macro	gmtl_has_finished			__gmtl_internal_fn_has_finished()
#macro	gmtl_is_initializing		__gmtl_internal_fn_is_initializing()

#macro	gmtl_test_before_all		gmtl_internal.tests.before_all
#macro	gmtl_test_after_all			gmtl_internal.tests.after_all
#macro	gmtl_test_before_each		gmtl_internal.tests.before_each
#macro	gmtl_test_after_each		gmtl_internal.tests.after_each

/**
	* Redefine input functions to allow mocking.
	* Original functions are still accessible with the "original_" prefix.
	* e.g. original_keyboard_check() will call the original keyboard_check() function.
*/
#macro	original_keyboard_check				keyboard_check
#macro	original_keyboard_check_pressed		keyboard_check_pressed
#macro	original_keyboard_check_released	keyboard_check_released
#macro	original_keyboard_clear				keyboard_clear

#macro	keyboard_check						__gmtl_internal_fn_keyboard_check
#macro	keyboard_check_pressed				__gmtl_internal_fn_keyboard_check_pressed
#macro	keyboard_check_released				__gmtl_internal_fn_keyboard_check_released
#macro	keyboard_clear						__gmtl_internal_fn_keyboard_clear

/**
	* Redefine mouse functions to allow mocking.
	* Original functions are still accessible with the "original_" prefix.
	* e.g. original_mouse_check_button() will call the original mouse_check_button() function.
	* mouse_x and mouse_y constants are also redefined to allow mocking.
	* io_clear is also redefined due to its relation to input handling.
*/
#macro	original_mouse_check_button				mouse_check_button
#macro	original_mouse_check_button_pressed		mouse_check_button_pressed
#macro	original_mouse_check_button_released	mouse_check_button_released
#macro	original_io_clear						io_clear
#macro	mouse_x									__gmtl_internal_fn_mouse_get_x()
#macro	mouse_y									__gmtl_internal_fn_mouse_get_y()

#macro	mouse_check_button						__gmtl_internal_fn_mouse_check_button
#macro	mouse_check_button_pressed				__gmtl_internal_fn_mouse_check_button_pressed
#macro	mouse_check_button_released				__gmtl_internal_fn_mouse_check_button_released
#macro	io_clear								__gmtl_internal_fn_io_clear 

/**
	* Redefine gamepad functions to allow mocking.
	* Original functions are still accessible with the "original_" prefix.
	* e.g. original_gamepad_button_check() will call the original gamepad_button_check() function.
*/
#macro	original_gamepad_button_check			gamepad_button_check
#macro	original_gamepad_button_check_pressed	gamepad_button_check_pressed
#macro	original_gamepad_button_check_released	gamepad_button_check_released

#macro	gamepad_button_check					__gmtl_internal_fn_gamepad_button_check
#macro	gamepad_button_check_pressed			__gmtl_internal_fn_gamepad_button_check_pressed
#macro	gamepad_button_check_released			__gmtl_internal_fn_gamepad_button_check_released

/**
	* Time source functions.
	* These functions are redefined to allow mocking and tracking of time sources created during tests.
	* Original functions are still accessible with the "original_" prefix.
*/
#macro	original_time_source_create		time_source_create
#macro	original_time_source_start		time_source_start
#macro	original_time_source_stop		time_source_stop
#macro	original_time_source_pause		time_source_pause
#macro	original_time_source_resume		time_source_resume
#macro	original_time_source_destroy	time_source_destroy
#macro	original_call_later				call_later

#macro	time_source_create				__gmtl_internal_fn_time_source_create
#macro	time_source_start				__gmtl_internal_fn_time_source_start
#macro	time_source_stop				__gmtl_internal_fn_time_source_stop
#macro	time_source_pause				__gmtl_internal_fn_time_source_pause
#macro	time_source_resume				__gmtl_internal_fn_time_source_resume
#macro	time_source_destroy				__gmtl_internal_fn_time_source_destroy
#macro	call_later						__gmtl_internal_fn_call_later