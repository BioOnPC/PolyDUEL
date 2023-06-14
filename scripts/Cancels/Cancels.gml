function CheckCancels(_State, _Player, _MoveData){
	if(_Player.hitstun > 0){
		return false;
	}
	if(_Player.hitstunType > 0){
		return false;
	}
	if(!(_State == noone || array_length(_State.actions) <= 0)){
		return false;
	}
	if(!_Player.Grounded && !_MoveData.Aerial || _Player.Grounded && _MoveData.Aerial){
		return false;
	}
	return true;
}