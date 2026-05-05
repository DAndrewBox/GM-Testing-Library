if (gmtl_has_finished && !gmtl_is_initializing && log == "") {
	log = string_replace_all(gmtl_log, "\t", "  ");
	log_lines = string_split(log, "\n", false);

	var _log_lines_len = array_length(log_lines);
	for (var i = 0; i < _log_lines_len; i++) {
		var _line_color = c_white;

		if (string_pos("✔", log_lines[i])) _line_color = c_lime else
		if (string_pos("❌", log_lines[i])) _line_color = c_red else
		if (string_pos("⚠", log_lines[i])) _line_color = c_orange else
		if (string_pos("├", log_lines[i])) _line_color = c_ltgrey else
		if (string_pos("└", log_lines[i])) _line_color = c_ltgrey;

		log_lines[i] = {
			text: log_lines[i],
			color: _line_color
		};
	}

	content_height = array_length(log_lines) * line_height;
}

var _view_height = display_get_gui_height();
var _max_scroll = max(0, content_height - _view_height);

if (mouse_wheel_up()) {
	scroll_y = max(0, scroll_y - scroll_speed);
}
if (mouse_wheel_down()) {
	scroll_y = min(_max_scroll, scroll_y + scroll_speed);
}