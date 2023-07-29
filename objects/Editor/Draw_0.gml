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
					array_insert(TreeButtons, prechildindex, {layer: i+1, id: structNames[i2], name: structNames[i2]});
					prechildindex++;
				}else{
					array_push(TreeButtons, {layer: i+1, id: structNames[i2], name: structNames[i2]});
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
					}
					continue;
				}
				if(prechild){
					array_insert(TreeButtons, prechildindex, {layer: i+1, id: i2, name: is_struct(val) && struct_exists(val, "Name") ? val.Name : i2});
					prechildindex++;
				}else{
					array_push(TreeButtons, {layer: i+1, id: i2, name: is_struct(val) && struct_exists(val, "Name") ? val.Name : i2});
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
	if(editorButton(10, room_height*2/5 + 50*i, room_width*2/5-20, 40, Buttons[i].selected)){
		Buttons[i].selected = true;
		keyboard_string = string(struct_get(currentStruct, Buttons[i].data));
	}else if(mouse_check_button_pressed(mb_left)){
		Buttons[i].selected = false;
	}else if(Buttons[i].selected){
		var val = keyboard_string;
		var currval = struct_get(currentStruct, Buttons[i].data);
		var changeData = true;
		if(is_real(currval)){
			if(string_is_real(val)){
				val = real(val);
			}else{
				changeData = false;
			}
		}else if(!is_string(currval)){
			trace(string(currval) + " IS NOT A STRING OR NUMBER");
		}
		if(changeData){
			struct_set(currentStruct, Buttons[i].data, val);
		}
	}
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_text(room_width/5, room_height*2/5 + 50*i, string(Buttons[i].name) + ": " + string(is_struct(currentStruct) ? struct_get(currentStruct, Buttons[i].data) : currentStruct[Buttons[i].data]));
}


for(var i = 0; i < array_length(TreeButtons); i++){
	if(editorButton(room_width*2/5+TreeButtons[i].layer*50, 10 + 50 * i, room_width*3/5-10-TreeButtons[i].layer*50, 40, 
		TreeButtons[i].layer == array_length(SelectedStruct) && TreeButtons[i].id == SelectedStruct[TreeButtons[i].layer - 1])){
		while(array_length(SelectedStruct) >= TreeButtons[i].layer){
			array_pop(SelectedStruct);
		}
		array_push(SelectedStruct, TreeButtons[i].id);
		with(Hittable){
			PlayerData = struct_get(other.Data, other.SelectedStruct[0]);
			reloadCharacter();
		}
		RebuildTree = true;
		//TREE NEEDS TO BE REBUILT, DO NOT HAVE CODE THAT EXPECTS SelectedStruct TO MAKE SENSE WITH TreeButtons OR Buttons AFTER THIS POINT
	}
	draw_set_color(c_black);
	draw_set_halign(fa_left);
	draw_text(room_width*2/5+TreeButtons[i].layer*50, 10 + 50 * i, string(TreeButtons[i].name));
}