if(GameCont.hitstop){
	return;
}

if(State == noone || array_length(State.actions) <= 0){
	if(Grounded){
		if(GetInputDirection() >= 7){
			//Leap(self);
			//array_push(State.actions, {Action: "Wait", Tags: [], Duration: 25});
			Jumping = true;
		}
		else if(GetInputDirection() == 6){
			Movement = {Distance: PlayerData.Attributes.ForwardWalkSpeed, Duration: 1, Ease: 1, Frame: 0}
		}
		else if(GetInputDirection() == 4){
			Movement = {Distance: -PlayerData.Attributes.BackwardWalkSpeed, Duration: 1, Ease: 1, Frame: 0}
		}
		else if(GetInputDirection() == 3 && variable_struct_exists(PlayerData.Attributes, "ForwardCrawlSpeed")){
			Movement = {Distance: PlayerData.Attributes.ForwardCrawlSpeed, Duration: 1, Ease: 1, Frame: 0}
		}
		else if(GetInputDirection() == 1 && variable_struct_exists(PlayerData.Attributes, "BackwardCrawlSpeed")){
			Movement = {Distance: -PlayerData.Attributes.BackwardCrawlSpeed, Duration: 1, Ease: 1, Frame: 0}
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