
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
	array_push(_State.log, string(GetInputDirection()));
	array_push(_State.pressedLog, string(GetPressedInputDirection()));
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
	
	return _State;
}

function GetInputDirection(){
	var _l = GetLeft();
	var _r = GetRight();
	var _u = GetUp();
	var _d = GetDown();
	return 5 - _l + _r - _d * 3 + _u * 3;
}

function GetPressedInputDirection(){
	var _l = GetLeftPressed();
	var _r = GetRightPressed();
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
			break;
		case "M":
			return keyboard_check(ord("J"));
			break;
		case "H":
			return keyboard_check(ord("K"));
			break;
		case "S":
			return keyboard_check(ord("L"));
			break;
	}
}

function GetInputPressed(Name){
	switch(Name){
		case "L":
			return keyboard_check_pressed(ord("H"));
			break;
		case "M":
			return keyboard_check_pressed(ord("J"));
			break;
		case "H":
			return keyboard_check_pressed(ord("K"));
			break;
		case "S":
			return keyboard_check_pressed(ord("L"));
			break;
	}
}