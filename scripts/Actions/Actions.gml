function EnsureStateInit(_Player){
	if(_Player.State == noone){
		_Player.State = {
			buffer: noone,
			log: [],
			pressedLog: [],
			actions: []
		}
	}
}

function ParseActions(_State, _Player){
	if(_State == noone || array_length(_State.actions) <= 0){
		return true;
	}
	var Action = _State.actions[0];
	switch(Action.Action){
		case "Wait":
			if Action.Duration > _Player.WaitTimer {
				_Player.WaitTimer++;
				if(struct_exists(Action, "RepeatActions")){
					_State.actions = array_concat(Action.RepeatActions, _State.actions);
				}
				return true;
			}else{
				_Player.WaitTimer = 0;
			}
			break;
		case "WaitForGround":
			_Player.LandingCancel = false;
			if !_Player.Grounded {
				if(struct_exists(Action, "RepeatActions")){
					_State.actions = array_concat(Action.RepeatActions, _State.actions);
				}
				return true;
			}
			break;
		case "Knockdown":
			_Player.LandingCancel = false;
			if !_Player.Grounded {
				_Player.iframes = 1;
				return true;
			}
			break;
		case "Move":
			_Player.Movement = {
				Distance: Action.Distance,
				Duration: Action.Duration,
				Ease: Action.Ease,
				Frame: 0,
				Direction: _Player.dir
			}
			break;
		case "SetYSpeed":
			_Player.yspeed = -Action.Amount
			if(_Player.yspeed < 0){
				Grounded = false;
			}
			break;
		case "SetGravity":
			array_push(_Player.StatusEffects, {Effect: "Gravity", Amount: Action.Amount, Duration: Action.Duration})
			break;
		case "Hitbox":
			array_push(_Player.Hitboxes, copyStruct(Action.Hitbox));
			break;
		case "ModifyHurtbox":
			array_push(_Player.StatusEffects, {Effect: "HurtboxModification", ID: Action.ID, Hurtbox: Action.Hurtbox, Duration: Action.Duration})
			break;
		case "SetSprite":
			array_push(_Player.StatusEffects, {Effect: "SetSprite", Sprite: Action.Sprite, Duration: Action.Duration})
			break;
		case "CallMoveIfDirectionHeld":
			if(string(GetInputDirection()) == Action.Button){
				CallMove(_State, _Player, Action.Move);
				return false;
			}
			break;
		case "CallMoveIfDirectionPressed":
			if(string(GetPressedInputDirection()) == Action.Button){
				CallMove(_State, _Player, Action.Move);
				return false;
			}
			break;
		case "CallMoveIfButtonHeld":
			if(GetInput(Action.Button)){
				CallMove(_State, _Player, Action.Move);
				return false;
			}
			break;
		case "CallMoveIfButtonPressed":
			if(GetInputPressed(Action.Button)){
				CallMove(_State, _Player, Action.Move);
				return false;
			}
			break;
		case "CallMoveIfButtonReleased":
			if(!GetInput(Action.Button)){
				CallMove(_State, _Player, Action.Move);
				return false;
			}
			break;
		case "ResetHitstun":
			_Player.hitstun = 0;
			_Player.hitstunType = 0;
			break;
	}
	array_delete(_State.actions, 0, 1);
	return false;
}

function CallMove(_State, _Player, _Move){
	var MoveToCall = [];
	for(var i = 0; i < array_length(_Player.PlayerData.Moves); i++){
		if(_Player.PlayerData.Moves[i].Name == _Move){
			MoveToCall = _Player.PlayerData.Moves[i];
			break;
		}
	}
	_State.actions = [];
	for(var i = 0; i < array_length(MoveToCall.Actions); i++){
		array_push(_State.actions, MoveToCall.Actions[i]);
	}
}