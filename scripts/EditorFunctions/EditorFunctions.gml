function editorButton(x,y,w,h, selected){
	var positioned = point_in_rectangle(mouse_x, mouse_y, x,y,x+w,y+h);
	var activated = mouse_check_button(mb_left) && positioned;
	draw_set_color(make_color_rgb(120, 125, 130));
	if(selected){
		draw_set_color(make_color_rgb(105, 110, 115));
	}
	if(positioned){
		draw_set_color(make_color_rgb(100, 105, 110));
	}
	if(activated){
		draw_set_color(make_color_rgb(90, 95, 100));
	}
	draw_button(x, y, x+w, y+h, activated);
	return mouse_check_button_pressed(mb_left) && positioned;
}