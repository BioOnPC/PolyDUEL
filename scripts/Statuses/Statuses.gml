function StatusStep(_Player){
	for(var i = 0; i < array_length(_Player.StatusEffects); i++){
		var Status = _Player.StatusEffects[i];
		switch(Status.Effect){
			case "Gravity":
				Status.Duration--;
				_Player.Gravity = Status.Amount;
				if(Status.Duration <= 0){
					_Player.Gravity = _Player.PlayerData.Attributes.Gravity;
					array_delete(_Player.StatusEffects, i, 1);
					i--;
					continue;
				}
			break;
			case "HurtboxModification":
				Status.Duration--;
				_Player.Hurtboxes[Status.ID] = Status.Hurtbox;
				if(Status.Duration <= 0){
					_Player.Hurtboxes[Status.ID] = _Player.PlayerData.Attributes.Hurtboxes[Status.ID];
					array_delete(_Player.StatusEffects, i, 1);
					i--;
					continue;
				}
			break;
			case "SetSprite":
				Status.Duration--;
				sprite_index = asset_get_index(Status.Sprite);
				if(Status.Duration <= 0){
					array_delete(_Player.StatusEffects, i, 1);
					i--;
					continue;
				}
				break;
		}
	}
}

function StatusHit(_Player){
	for(var i = 0; i < array_length(_Player.StatusEffects); i++){
		var Status = _Player.StatusEffects[i];
		switch(Status.Effect){
			case "Gravity":
				_Player.Gravity = _Player.PlayerData.Attributes.Gravity;
				array_delete(_Player.StatusEffects, i, 1);
				i--;
				continue;
			break;
			case "HurtboxModification":
				_Player.Hurtboxes[Status.ID] = _Player.PlayerData.Attributes.Hurtboxes[Status.ID];
				array_delete(_Player.StatusEffects, i, 1);
				i--;
				continue;
			break;
			case "SetSprite":
				array_delete(_Player.StatusEffects, i, 1);
				i--;
				continue;
		}
	}
}