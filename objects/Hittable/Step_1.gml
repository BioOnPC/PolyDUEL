if(GameCont.hitstop){
	return;
}

LandingCancel = true;

var changedir = 0;
var enemies = false;
with(Hittable){
	if(team != other.team){
		enemies = true;
		if(x < other.x && other.dir == 1){
			changedir = -1;
			break;
		}
		if(x > other.x && other.dir == -1){
			changedir = 1;
			break;
		}
		if(x == other.x){
			changedir = 0;
			break;
		}
	}
}
if(changedir != 0 && enemies){
	if(State == noone || array_length(State.actions) == 0){
		dir = changedir
	}
	inputdir = changedir;
}

if(dir == 1){
	image_xscale = abs(image_xscale);
}
if(dir == -1){
	image_xscale = -abs(image_xscale);
}