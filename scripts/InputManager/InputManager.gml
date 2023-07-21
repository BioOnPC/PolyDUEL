
//Hooks is an array of structs, with each struct having:
// "motion" (a sequence to follow, such as 236 (or just 26))
// "input" (the input that triggers the move)
// "hook" (the function you want called if this input is true)
//  NOTE: your hook should return false if you want the input to keep buffering
//  (for example if it can't cancel yet)
// 
//State is the active state of the input manager as a struct, 
// so that players can have completely separated inputs.
// If you do not have a state, input noone.
// The state struct has:
// "log" (the motion input buffer)
// "buffer" (the regular input buffer, it is a struct with "hook" and "age")
//
//Player is the player to be affected, as an instance ID
//
//Returns an updated State for next frame
function InputManager(_Hooks, _State, _Player){
	var logLength = 9; //how long the motion buffer should last
	var pressedLogLength = 15; //how long the motion buffer should last for dash/22 inputs
	var bufferLength = 5; //how long buffered moves should buffer for (for getups and cancels and such)
	var chosenMove = noone;
	var pil_buffer = [5, 0, 0, 0, 0, 0, 0, noone, 1]; // The default current input, assuming nothing happens this frame
	var pil_last   = pil[_Player.index - 1][array_length(pil[_Player.index - 1]) - 1]; // The last log of inputs in the persistent buffer
	// Make sure the age is the same between the two so we can check if the inputs are the same later
	pil_buffer[8] = pil_last[8]; 
	
	if(_State == noone){
		_State = {
			buffer: noone,
			log: [],
			pressedLog: [],
			actions: []
		}
	}
	if(_State.buffer != noone && _State.buffer.age <= bufferLength){
		chosenMove = _State.buffer;
	}
	
	//Add the current inputs to the motion buffer
	array_push(_State.log, string(GetInputDirection(_Player)));
	array_push(_State.pressedLog, string(GetPressedInputDirection(_Player)));
	
	 // Log the current directional input in the persistent buffer
	pil_buffer[0] = GetInputDirection(_Player);
	
	//This clips the motion buffer down to logLength by cutting off of the beginning
	if(array_length(_State.log) > logLength){
		array_delete(_State.log, 0, array_length(_State.log) - logLength);
	}
	if(array_length(_State.pressedLog) > pressedLogLength){
		array_delete(_State.pressedLog, 0, array_length(_State.pressedLog) - pressedLogLength);
	}
	
	for (var i = 0; i < array_length(_Hooks); i++) {
		if(_Hooks[i].FromIdle == false){
			continue;
		}
		var logPointer = array_length(_State.log);
		var pressedLogPointer = array_length(_State.pressedLog);
		var i2 = string_length(_Hooks[i].Motion);
		
		
		var cur_pressed = GetInputPressed(_Hooks[i].Input),
			cur_held	= GetInput(_Hooks[i].Input)
		
		 // Write the current status of this input, if it is a button input, to the persistent log
		switch(_Hooks[i].Input) {
				/* 
				Each of these checks if the button was just pressed: if not, check if the last input
				is the same and consider the button held. Otherwise, the button hasn't been pressed 
				at all. Will add a on-release clause later.
				*/
			case "L": pil_buffer[1] = cur_pressed ? 1 : 
										(pil_last[1] = 1 or 
										(cur_held && pil_last[1] = 2) ? 2 : 0) break;
			case "M": pil_buffer[2] = cur_pressed ? 1 : 
										(pil_last[2] = 1 or 
										(cur_held && pil_last[2] = 2) ? 2 : 0) break;
			case "H": pil_buffer[3] = cur_pressed ? 1 : 
										(pil_last[3] = 1 or 
										(cur_held && pil_last[3] = 2) ? 2 : 0) break;
			case "S": pil_buffer[4] = cur_pressed ? 1 : 
										(pil_last[4] = 1 or 
										(cur_held && pil_last[4] = 2) ? 2 : 0) break;
			case "AD": pil_buffer[5] = cur_pressed ? 1 : 
										(pil_last[5] = 1 or 
										(cur_held && pil_last[5] = 2) ? 2 : 0) break;
			case "DA": pil_buffer[6] = cur_pressed ? 1 : 
										(pil_last[6] = 1 or 
										(cur_held && pil_last[6] = 2) ? 2 : 0) break;
		}
		
		//There's either the button input we're looking for 
		//	or the motion input of this frame is the end of an inputless motion such as dashing
		//TODO: Add buffer for multi-input moves (AKA grabbing)
		if(GetInputPressed(_Hooks[i].Input) ||
			string_length(_Hooks[i].Input) == 2 && 
			(GetInputPressed(string_char_at(_Hooks[i].Input, 1)) && 
			GetInputPressed(string_char_at(_Hooks[i].Input, 2))) || 
			_Hooks[i].Input == "!" && 
			string_char_at(_Hooks[i].Motion, i2) == _State.pressedLog[pressedLogPointer - 1] && 
			string_char_at(_Hooks[i].Motion, i2) == _State.log[logPointer - 1] || 
			_Hooks[i].Input == "" && 
			string_char_at(_Hooks[i].Motion, i2) == _State.log[logPointer - 1]){
			
			var checkPressed = false;
			while(i2 > 0 && logPointer > 0){
				if(checkPressed == false && string_char_at(_Hooks[i].Motion, i2) == _State.log[logPointer - 1]
					|| pressedLogPointer > 0
					&& string_char_at(_Hooks[i].Motion, i2) == _State.pressedLog[pressedLogPointer - 1]){
						
					checkPressed = false;
					i2--;
					//If there's an input such as 22S, it should skip someone holding down 2
					if(i2 > 0 && logPointer > 0 && 
						string_char_at(_Hooks[i].Motion, i2) == _State.log[logPointer - 1]){
						checkPressed = true;
					}
				}
				logPointer--;
				pressedLogPointer--;
			}
			if(i2 <= 0){
				if(chosenMove == noone || chosenMove.Data.Priority <= _Hooks[i].Priority){
					chosenMove = {Data: _Hooks[i], age: 0}
				}
			}
		}
	}
	_State.buffer = chosenMove;
	
	if(_State.buffer != noone){
		 // Note if the player successfully performed a move in the persistent log
		//pil_buffer = variable_struct_exists(_State.buffer.Data, "DisplayName") ? _State.buffer.Data.DisplayName : 
		//																		 _State.buffer.Data.Name;
		
		_State.buffer.age++;
		if(CheckCancels(_State, _Player, _State.buffer.Data)){
			_State.actions = [];
			for(var i = 0; i < array_length(_State.buffer.Data.Actions); i++){
				array_push(_State.actions, _State.buffer.Data.Actions[i]);
			}
			_State.buffer = noone;
			_State.log = [];
			_State.pressedLog = [];
		}
		//If the move executes successfully, dump the buffer
		/*if(script_execute(_State.buffer.hook, _Player)){
			_State.buffer = noone;
			_State.log = [];
			_State.pressedLog = [];
		}*/
	}
	
	
	if(array_equals(pil_buffer, pil_last)) { // If, after everything, the current inputs amount to the same as
											 // last frame, increase the last frame's age in the persistent log
		pil[_Player.index - 1][array_length(pil[_Player.index - 1]) - 1][8]++;
	}
		// Add the resultant sum of all of the inputs to the persistent log buffer if anything is different
	else {
		pil_buffer[8] = 1; // Reset the age of the current input
		array_push(pil[_Player.index - 1], pil_buffer);
	}
	
	return _State;
}

function GetInputDirection(_Player){
	var _l, _r;
	if(_Player.inputdir == 1){
		_l = GetLeft();
		_r = GetRight();
	} else {
		_l = GetRight();
		_r = GetLeft();
	}
	var _u = GetUp();
	var _d = GetDown();
	return 5 - _l + _r - _d * 3 + _u * 3;
}

function GetPressedInputDirection(_Player){
	var _l, _r;
	if(_Player.inputdir == 1){
		_l = GetLeftPressed();
		_r = GetRightPressed();
	} else {
		_l = GetRightPressed();
		_r = GetLeftPressed();
	}
	var _u = GetUpPressed();
	var _d = GetDownPressed();
	return 5 - _l + _r - _d * 3 + _u * 3;
}

function GetLeft(){
	return keyboard_check(ord("A"));// || gamepad_axis_value(0, gp_axislh) < 0;
}

function GetRight(){
	return keyboard_check(ord("D"));// || gamepad_axis_value(0, gp_axislh) > 0;
}

function GetUp(){
	return keyboard_check(ord("W"));// || gamepad_axis_value(0, gp_axislv) < 0;
}

function GetDown(){
	return keyboard_check(ord("S"));// || gamepad_axis_value(0, gp_axislv) > 0;
}

function GetLeftPressed(){
	return keyboard_check_pressed(ord("A"));
}

function GetRightPressed(){
	return keyboard_check_pressed(ord("D"));
}

function GetUpPressed(){
	return keyboard_check_pressed(ord("W"));
}

function GetDownPressed(){
	return keyboard_check_pressed(ord("S"));
}

function GetInput(Name){
	switch(Name){
		case "L":
			return keyboard_check(ord("H"));
		case "M":
			return keyboard_check(ord("J"));
		case "H":
			return keyboard_check(ord("K"));
		case "S":
			return keyboard_check(ord("L"));
	}
}

function GetInputPressed(Name){
	switch(Name){
		case "L":
			return keyboard_check_pressed(ord("H"));
		case "M":
			return keyboard_check_pressed(ord("J"));
		case "H":
			return keyboard_check_pressed(ord("K"));
		case "S":
			return keyboard_check_pressed(ord("L"));
	}
}