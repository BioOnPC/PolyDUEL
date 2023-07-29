var pil_len = array_length(pil[0]);

if(instance_exists(Hittable)){
	draw_set_color(c_white);
	draw_set_font(UI);
	for(var i = pil_len - 1; i >= 0; i--) {
		//draw_text(view_xview + 20, view_yview + 200 + (i * 10) - (pil_len * 10), string(pil[0][i][0]));
		draw_sprite(DirectionSprites, pil[0][i][0], view_xview + 10, view_yview + 200 + (i * 10) - (pil_len * 10))
		draw_sprite(ButtonSprites, pil[0][i][1], view_xview + 20, view_yview + 200 + (i * 10) - (pil_len * 10))
		draw_sprite(ButtonSprites, pil[0][i][2] + 3, view_xview + 30, view_yview + 200 + (i * 10) - (pil_len * 10))
		draw_sprite(ButtonSprites, pil[0][i][3] + 6, view_xview + 40, view_yview + 200 + (i * 10) - (pil_len * 10))
		draw_sprite(ButtonSprites, pil[0][i][4] + 9, view_xview + 50, view_yview + 200 + (i * 10) - (pil_len * 10))
	
		draw_text(view_xview + 65, view_yview + 200 + (i * 10) - (pil_len * 10) - 1, string(min(99, pil[0][i][8])));
	}
	draw_set_font(-1);
}
