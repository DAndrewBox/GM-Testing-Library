/// @description 
timer++;

if (timer >= 200) {
	instance_destroy();
}

if (keyboard_check_pressed(ord("A")) || keyboard_check(ord("A"))) {
	timer_key_hold += 1;
}

if (keyboard_check_released(ord("A"))) {
	timer_key_hold = 0;
}

if (gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check(0, gp_face1)) {
	timer_gamepad_button_hold += 1;	
}

if (gamepad_button_check_released(0, gp_face1)) {
	timer_gamepad_button_hold = 0;
}

var _mouse_inside = point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom);
if (_mouse_inside && mouse_check_button_pressed(mb_left)) {
	times_clicked_inside += 1;
}

if (_mouse_inside && mouse_check_button_pressed(mb_right)) {
	times_clicked_inside -= 1;
}

if (!_mouse_inside && mouse_check_button_pressed(mb_left)) {
	times_clicked_outside += 1;
}

if (_mouse_inside && mouse_check_button(mb_middle)) {
	timer_click_hold += 1;
}

if (!mouse_check_button(mb_middle)) {
	timer_click_hold = 0;
}
