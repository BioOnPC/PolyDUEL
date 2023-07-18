draw_set_color(make_color_rgb(80, 90, 100));
draw_rectangle(0,0,room_width, room_height, 0);

draw_set_color(make_color_rgb(0, 0, 0));
draw_rectangle(10,10,room_width/2.5-10, room_height/2.5-10, 0);

if(RebuildTree){
	RebuildTree = false;
	TreeButtons = [];
	Buttons = [];
	
	for(var i = array_length(SelectedStruct); i >= 0; i--){
		var struct = Data;
		var prechild = true;
		var prechildindex = 0;
		for(var i2 = 0; i2 < i; i2++){
			if(is_struct(struct)){
				struct = struct_get(struct, SelectedStruct[i2]);
			}else if(is_array(struct)){
				struct = struct[SelectedStruct[i2]];
			}
		}
		if(is_struct(struct)){
			var structNames = struct_get_names(struct);
			for(var i2 = 0; i2 < array_length(structNames); i2++){
				var val = struct_get(struct, structNames[i2]);
				if(!is_array(val) && !is_struct(val)){
					if(i == array_length(SelectedStruct)){
						array_push(Buttons, {selected: false, name: structNames[i2], data: structNames[i2]});
					}
					continue;
				}
				if(prechild){
					array_insert(TreeButtons, prechildindex, {layer: i, name: structNames[i2]});
					prechildindex++;
				}else{
					array_push(TreeButtons, {layer: i, name: structNames[i2]});
				}
				if(prechild && i < array_length(SelectedStruct) && structNames[i2] == SelectedStruct[i]){
					prechild = false;
				}
			}
		}else if(is_array(struct)){
			for(var i2 = 0; i2 < array_length(struct); i2++){
				var val = struct[i2];
				if(!is_array(val) && !is_struct(val)){
					if(i == array_length(SelectedStruct)){
						array_push(Buttons, {selected: false, name: i2, data: i2});
						show_debug_message(string(i2));
					}
					continue;
				}
				if(prechild){
					array_insert(TreeButtons, prechildindex, {layer: i, name: i2});
					prechildindex++;
				}else{
					array_push(TreeButtons, {layer: i, name: i2});
				}
				if(prechild && i < array_length(SelectedStruct) && i2 == SelectedStruct[i]){
					prechild = false;
				}
			}
		}
	}
}

var currentStruct = Data;

for(var i = 0; i < array_length(SelectedStruct); i++){
	if(is_struct(currentStruct)){
		currentStruct = struct_get(currentStruct, SelectedStruct[i]);
	}else if(is_array(currentStruct)){
		currentStruct = currentStruct[SelectedStruct[i]];
	}
}

for(var i = 0; i < array_length(Buttons); i++){
	if(button(10, room_height*2/5 + 50*i, room_width*2/5-20, 40, Buttons[i].selected)){
		Buttons[0].selected = true;
		keyboard_string = struct_get(Data, Buttons[i].data);
	}else if(mouse_check_button_pressed(mb_left)){
		Buttons[0].selected = false;
	}else if(Buttons[0].selected){
		struct_set(Data, Buttons[0].data, keyboard_string);
	}
	draw_set_color(c_black);
	draw_set_halign(fa_middle);
	draw_text(room_width/5, room_height/2.5, string(Buttons[0].name) + ": " + (is_struct(currentStruct) ? struct_get(currentStruct, Buttons[i].data) : currentStruct[Buttons[i].data]));
}


for(var i = 0; i < array_length(TreeButtons); i++){
	if(button(room_width*2/5+TreeButtons[i].layer*50, 10 + 50 * i, room_width*3/5-10-TreeButtons[i].layer*50, 40, 
		TreeButtons[i].layer == array_length(SelectedStruct) - 1 && TreeButtons[i].name == SelectedStruct[TreeButtons[i].layer])){
		while(array_length(SelectedStruct) > TreeButtons[i].layer){
			array_pop(SelectedStruct);
		}
		array_push(SelectedStruct, TreeButtons[i].name);
		RebuildTree = true;
		//TREE NEEDS TO BE REBUILT, DO NOT HAVE CODE THAT EXPECTS SelectedStruct TO MAKE SENSE WITH TreeButtons OR Buttons AFTER THIS POINT
	}
	draw_set_color(c_black);
	draw_set_halign(fa_left);
	draw_text(room_width*2/5+TreeButtons[i].layer*50, 10 + 50 * i, string(TreeButtons[i].name));
}

function button(x,y,w,h, selected){
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