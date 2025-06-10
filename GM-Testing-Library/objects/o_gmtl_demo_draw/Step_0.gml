if (gmtl_internal.finished && log == "") {
	log = string_replace_all(gmtl_log, "\t", "  ");
	log_lines = string_split(log, "\n", false);
	
	var _log_lines_len = array_length(log_lines);
	for (var i = 0; i < _log_lines_len; i++) {
		var _line_color = c_white;
		
		if (string_pos("✔", log_lines[i])) _line_color = c_lime;
		if (string_pos("❌", log_lines[i])) _line_color = c_red;
		if (string_pos("⚠", log_lines[i])) _line_color = c_orange;
		if (string_pos("├", log_lines[i])) _line_color = c_ltgrey;
		if (string_pos("└", log_lines[i])) _line_color = c_ltgrey;

		log_lines[i] = {
			text: log_lines[i],
			color: _line_color
		};
	}
}