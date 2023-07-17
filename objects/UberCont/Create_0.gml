if(instance_number(UberCont) > 1){
	instance_destroy();
}

pil					= [[[5, 0, 0, 0, 0, 0, 0, noone, 1]]];

/*	
	For documentation reasons, I'm going to write a quick reference with regards to what each index
	in each player's 'pil' array refers to. All told, inputs are written to the array in the following 
	order within a nested array in pil:
	  0 - Current directional input (or the last if it was just released this frame)
	  1 - A value ranging from -1 to 2 to note if Light was just released, not touched at all, just started
		  being pressed this frame, or is currently being held
	  2 - The above but for Medium
	  3 - Ditto for Heavy
	  4 - Ditto for Signature
	  5 - Ditto for Autodriver
	  6 - Ditto for Dash
	  7 - The name of any move that was successfully performed this frame
	  8 - The amount of frames all of this information has stayed the same for
*/

input_mode			= [[]];		// Tracks which input method either player is using, will be implemented later
mode				= m_menu;	// Tracks the current gamestate
save_replay			= false;	// Determines whether inputs should be saved for replays

#macro pil				UberCont.persistent_input_log

#macro m_menu		0	// Menus
#macro m_tran		1	// Training Mode
#macro m_stry		2	// PVE Modes
#macro m_locl		3	// Local Multiplayer
#macro m_onln		4	// Online Multiplayer

 // GML QOL macros
#macro view_xview	camera_get_view_x(view_camera[0])
#macro view_yview	camera_get_view_y(view_camera[0])
#macro view_height	camera_get_view_height(view_camera[0])
#macro view_width	camera_get_view_width(view_camera[0])
#macro str			string