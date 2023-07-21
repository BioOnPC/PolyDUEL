if(array_length(layers)) {
	 // Cycle through each layer and draw it in order
	for(var i = array_length(layers) - 1; i >= 0; i--) {
		draw_set_alpha(layers[i][0]);
		draw_sprite(stage_image, i + stage_index, room_width/2, room_height/2 - 15);
		draw_set_alpha(1);
	}
}