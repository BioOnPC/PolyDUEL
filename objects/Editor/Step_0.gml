with(Hittable){
	if(State != noone && array_length(State.actions) <= 0 && Movement == noone && y >= StageCont.boundaries.Floor && array_length(other.SelectedStruct) > 2 && other.SelectedStruct[1] == "Moves"){
		var move = other.Data
		
		for(var i = 0; i < array_length(other.SelectedStruct); i++){
			if(is_struct(move) && struct_exists(move, "Input")){
				break;
			}else if(is_struct(move)){
				move = struct_get(move, other.SelectedStruct[i]);
			}else if(is_array(move)){
				move = move[other.SelectedStruct[i]];
			}
		}
		if(is_struct(move) && struct_exists(move, "Input")){
			x = (StageCont.boundaries.LWall + StageCont.boundaries.RWall) / 2;
			y = StageCont.boundaries.Floor;
			yspeed = 0;
			Grounded = true;
			CallAction(State, move.Actions);
		}
	}
}