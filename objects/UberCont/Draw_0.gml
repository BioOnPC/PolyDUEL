var pil_len = array_length(pil[0]);

for(var i = pil_len - 1; i > 0; i--) {
	draw_set_color(c_white);
	draw_set_font(UI);
	draw_text(view_xview + 20, view_yview + 200 + (i * 10) - (pil_len * 10), string(pil[0][i][0]));
	draw_text(view_xview + 60, view_yview + 200 + (i * 10) - (pil_len * 10), string(min(99, pil[0][i][8])));
}
