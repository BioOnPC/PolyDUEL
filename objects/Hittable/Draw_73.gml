draw_set_color(c_green);
if(iframes > 0){
	draw_set_color(c_blue);
}
draw_set_alpha(0.4);
for(var i = 0; i < array_length(Hurtboxes); i++){
	draw_rectangle(x + Hurtboxes[i].XOffset - Hurtboxes[i].Width / 2, 
		y - Hurtboxes[i].YOffset, 
		x + Hurtboxes[i].XOffset + Hurtboxes[i].Width / 2, 
		y - Hurtboxes[i].YOffset - Hurtboxes[i].Height, 0);
	draw_set_alpha(0.8);
	draw_rectangle(x + Hurtboxes[i].XOffset - Hurtboxes[i].Width / 2, 
		y - Hurtboxes[i].YOffset, 
		x + Hurtboxes[i].XOffset + Hurtboxes[i].Width / 2, 
		y - Hurtboxes[i].YOffset - Hurtboxes[i].Height, 1);
}
	
for(var i = 0; i < array_length(Hitboxes); i++){
	draw_set_color(c_red);
	draw_set_alpha(0.4);
	draw_rectangle(x + Hitboxes[i].XOffset - Hitboxes[i].Width / 2, 
		y - Hitboxes[i].YOffset - Hitboxes[i].Height / 2, 
		x + Hitboxes[i].XOffset + Hitboxes[i].Width / 2, 
		y - Hitboxes[i].YOffset + Hitboxes[i].Height / 2, 0);
	draw_set_alpha(0.8);
	draw_rectangle(x + Hitboxes[i].XOffset - Hitboxes[i].Width / 2, 
		y - Hitboxes[i].YOffset - Hitboxes[i].Height / 2, 
		x + Hitboxes[i].XOffset + Hitboxes[i].Width / 2, 
		y - Hitboxes[i].YOffset + Hitboxes[i].Height / 2, 1);
}
	
for(var i = 0; i < array_length(UsedHitboxes); i++){
	draw_set_color(make_color_rgb(100,50,50));
	draw_set_alpha(0.4);
	draw_rectangle(x + UsedHitboxes[i].XOffset - UsedHitboxes[i].Width / 2, 
		y - UsedHitboxes[i].YOffset - UsedHitboxes[i].Height / 2, 
		x + UsedHitboxes[i].XOffset + UsedHitboxes[i].Width / 2, 
		y - UsedHitboxes[i].YOffset + UsedHitboxes[i].Height / 2, 0);
	draw_set_alpha(0.8);
	draw_rectangle(x + UsedHitboxes[i].XOffset - UsedHitboxes[i].Width / 2, 
		y - UsedHitboxes[i].YOffset - UsedHitboxes[i].Height / 2, 
		x + UsedHitboxes[i].XOffset + UsedHitboxes[i].Width / 2, 
		y - UsedHitboxes[i].YOffset + UsedHitboxes[i].Height / 2, 1);
}
	
draw_set_alpha(1);