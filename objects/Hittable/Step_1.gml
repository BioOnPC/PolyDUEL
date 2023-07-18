if(GameCont.hitstop){
	return;
}

LandingCancel = true;

if(State == noone || array_length(State.actions) == 0){
	var changedir = true;
	var enemies = false;
	with(Hittable){
		if(team != other.team){
			enemies = true;
			if(x > other.x && other.dir == 1){
				changedir = false;
				break;
			}
			if(x < other.x && other.dir == -1){
				changedir = false;
				break;
			}
		}
	}
	if(changedir && enemies){
		if(dir == 1){
			dir = -1;
		}else{
			dir = 1;
		}
	}

	if(dir == 1){
		image_xscale = abs(image_xscale);
	}
	if(dir == -1){
		image_xscale = -abs(image_xscale);
	}
}