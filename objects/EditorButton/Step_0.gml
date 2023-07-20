if(point_in_rectangle(mouse_x, mouse_y, x - 50, y - 25, x + 50, y + 25) && mouse_check_button_pressed(1)){
	room_goto(room_Editor);
}