if(GameCont.hitstop){
	return;
}

if(State == noone || array_length(State.actions) <= 0){
	if(Grounded){
		if(GetUp()){
			//Leap(self);
			//array_push(State.actions, {Action: "Wait", Tags: [], Duration: 25});
			Jumping = true;
		}else if(GetRight()){
			Movement = {Distance: PlayerData.Attributes.ForwardWalkSpeed, Duration: 1, Ease: 1, Frame: 0}
		}else if(GetLeft()){
			Movement = {Distance: -PlayerData.Attributes.BackwardWalkSpeed, Duration: 1, Ease: 1, Frame: 0}
		}
	}
}

/*if(Jumping != noone){
	if(GetRight()){
		CallMove(State, self, "JumpForward");
	}else if(GetLeft()){
		CallMove(State, self, "JumpBackward");
	}else{
		CallMove(State, self, "JumpNeutral");
	}
	Jumping = noone;
}*/