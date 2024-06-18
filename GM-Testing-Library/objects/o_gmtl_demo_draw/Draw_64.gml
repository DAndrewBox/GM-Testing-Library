/// @description 
display_set_gui_size(room_width, room_height);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_gmtl_demo);

if (gmtl_log != "") {
	var _log = string_replace_all(gmtl_log, "\t", "  ");
	draw_text(8, 8, _log);
}
