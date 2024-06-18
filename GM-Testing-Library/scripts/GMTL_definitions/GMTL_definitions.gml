
enum __gmtl_test_status {
	RUN,
	SUCCESS,
	FAILED,
	SKIP
}

#macro	gmtl_internal			global.__gmtl_internal
#macro	gmtl_indent				gmtl_internal.indent
#macro	gmtl_log				gmtl_internal.log
#macro	gmtl_test_log			gmtl_internal.tests.log
#macro	gmtl_test_status		gmtl_internal.tests.status
#macro	gmtl_suite_continue		gmtl_internal.suites.should_continue
#macro	gmtl_suite_list			gmtl_internal.suites.list
#macro	gmtl_suite_last_failed	gmtl_internal.suites.last_failed
#macro	gmtl_coverage_suites	gmtl_internal.coverage.suites
#macro	gmtl_coverage_tests		gmtl_internal.coverage.tests

#macro	gmtl_test_before_all	gmtl_internal.tests.before_all
#macro	gmtl_test_after_all		gmtl_internal.tests.after_all
#macro	gmtl_test_before_each	gmtl_internal.tests.before_each
#macro	gmtl_test_after_each	gmtl_internal.tests.after_each

#macro	original_keyboard_check				keyboard_check
#macro	original_keyboard_check_pressed		keyboard_check_pressed
#macro	original_keyboard_check_released	keyboard_check_released

#macro	keyboard_check						__gmtl_internal_fn_keyboard_check
#macro	keyboard_check_pressed				__gmtl_internal_fn_keyboard_check_pressed
#macro	keyboard_check_released				__gmtl_internal_fn_keyboard_check_released

#macro	original_mouse_check_button				mouse_check_button
#macro	original_mouse_check_button_pressed		mouse_check_button_pressed
#macro	original_mouse_check_button_released	mouse_check_button_released

#macro	mouse_check_button						__gmtl_internal_fn_mouse_check_button
#macro	mouse_check_button_pressed				__gmtl_internal_fn_mouse_check_button_pressed
#macro	mouse_check_button_released				__gmtl_internal_fn_mouse_check_button_released

#macro	mouse_x		__gmtl_internal_fn_mouse_get_x()
#macro	mouse_y		__gmtl_internal_fn_mouse_get_y()
