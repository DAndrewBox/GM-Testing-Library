/// @description 
display_set_gui_size(room_width, room_height);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_gmtl_demo);

if (log != "") {
	var _log_lines_len = array_length(log_lines);
	var _yoff = 0;
	for (var i = 0; i < _log_lines_len; i++) {
		draw_set_color(log_lines[i].color);
		draw_text(8, 8 + _yoff, log_lines[i].text);
		_yoff += 18;
	}
}