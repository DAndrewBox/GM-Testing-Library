/// @description
display_set_gui_size(room_width, room_height);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_gmtl_demo);

if (log != "") {
	var _view_width  = display_get_gui_width();
	var _view_height = display_get_gui_height();

	// Draw text lines offset by scroll_y
	var _log_lines_len = array_length(log_lines);
	for (var i = 0; i < _log_lines_len; i++) {
		var _y = 8 + i * line_height - scroll_y;
		if (_y + line_height < 0 || _y > _view_height) continue;
		draw_set_color(log_lines[i].color);
		draw_text(8, _y, log_lines[i].text);
	}

	// Scrollbar
	var _max_scroll = max(0, content_height - _view_height);
	if (_max_scroll > 0) {
		var _bar_x      = _view_width - scrollbar_width - scrollbar_padding;
		var _track_h    = _view_height - scrollbar_padding * 2;
		var _thumb_h    = max(24, _track_h * (_view_height / content_height));
		var _thumb_y    = scrollbar_padding + (_track_h - _thumb_h) * (scroll_y / _max_scroll);

		// Track
		draw_set_color(make_color_rgb(40, 40, 40));
		draw_rectangle(_bar_x, scrollbar_padding, _bar_x + scrollbar_width, scrollbar_padding + _track_h, false);

		// Thumb
		draw_set_color(make_color_rgb(140, 140, 140));
		draw_rectangle(_bar_x, _thumb_y, _bar_x + scrollbar_width, _thumb_y + _thumb_h, false);
	}
}