event_inherited();

if(GameCont.p1 != noone){
	PlayerData = LoadPlayerData()[$ GameCont.p1];
}else{
	trace(GameCont.p1);
	//TODO
}

Gravity = PlayerData.Attributes.Gravity;

IdleAnim = asset_get_index(PlayerData.Attributes.IdleAnim);
sprite_index = IdleAnim;

Hurtboxes = [];

for(var i = 0; i < array_length(PlayerData.Attributes.Hurtboxes); i++){
	array_push(Hurtboxes, PlayerData.Attributes.Hurtboxes[i]);
}