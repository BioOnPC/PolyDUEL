event_inherited();

index = 1;
cpu   = 0;

if(GameCont.p1 != noone){
	PlayerData = LoadPlayerData()[$ GameCont.p1];
}else{
	trace(GameCont.p1);
	//TODO
	index = 2;
	array_push(pil, [[5, 0, 0, 0, 0, 0, 0, noone, 1]]); 
}

Gravity = PlayerData.Attributes.Gravity;

IdleAnim = asset_get_index(PlayerData.Attributes.IdleAnim);
sprite_index = IdleAnim;

Hurtboxes = [];

for(var i = 0; i < array_length(PlayerData.Attributes.Hurtboxes); i++){
	array_push(Hurtboxes, PlayerData.Attributes.Hurtboxes[i]);
}