event_inherited();

team = 1;
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

reloadCharacter();

sprite_index = IdleAnim;