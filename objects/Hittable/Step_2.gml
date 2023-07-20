if(GameCont.hitstop){
	return;
}

LandingCancel = true;
sprite_index = IdleAnim;

if(iframes > 0){
	iframes--;
}

if(combo > 0 && hitstun == 0 && hitstunType == 0 && (State == noone || array_length(State.actions) == 0)){
	trace(combo);
	combo = 0;
}
EnsureStateInit(self);
while(!ParseActions(State, self)){}

for(var i = 0; i < array_length(Hitboxes); i++){
	if(Hitboxes[i].Duration <= 0){
		array_delete(Hitboxes, i, 1);
	}else{
		Hitboxes[i].Duration--;
	}
}
for(var i = 0; i < array_length(UsedHitboxes); i++){
	if(UsedHitboxes[i].Duration <= 0){
		array_delete(UsedHitboxes, i, 1);
	}else{
		UsedHitboxes[i].Duration--;
	}
}

StatusStep(self);

//TODO: Make it stick to a unit grid (with storing inaccuracies) 
//    so that subpixel shenanigans don't happen
//(having second thoughts on this todo, I don't think subpixel stuff would be bad)
if(Movement != noone){
	if(Movement.Ease > 0){
		x += Movement.Distance * 
			(power(1 - Movement.Frame / Movement.Duration, Movement.Ease) - 
			power(1 - (Movement.Frame + 1) / Movement.Duration, Movement.Ease)) * Movement.Direction
	}else{
		x += Movement.Distance * 
			(power((Movement.Frame + 1) / Movement.Duration, -Movement.Ease) - 
			power(Movement.Frame / Movement.Duration, -Movement.Ease)) * Movement.Direction
	}
	Movement.Frame++;
	if(Movement.Frame >= Movement.Duration){
		Movement = noone;
	}
}

if(y < 220 || yspeed < 0){
	y += yspeed;
	yspeed += Gravity;
	Grounded = false;
} else {
	y = 220;
	if(Grounded == false){
		if(State != noone){
			if(LandingCancel){
				State.actions = [];
				Hitboxes = [];
				UsedHitboxes = [];
				Movement = noone;
			}
			array_push(State.actions, {Action: "Wait", Tags: [], Duration: 5});
			if(hitstunType == 1){
				array_push(State.actions, 
		        {
		          "Action": "ModifyHurtbox",
		          "Hurtbox": {
		            "XOffset": 0,
		            "YOffset": 0,
		            "Width": 50,
		            "Height": 30
		          },
		          "ID": 0,
		          "Duration": 5
		        });
				array_push(State.actions, {Action: "Wait", Tags: [], Duration: 10});
				array_push(State.actions, {Action: "ResetHitstun"});
			}
			if(hitstunType == 2){
				array_push(State.actions, 
		        {
		          "Action": "ModifyHurtbox",
		          "Hurtbox": {
		            "XOffset": 0,
		            "YOffset": 0,
		            "Width": 50,
		            "Height": 30
		          },
		          "ID": 0,
		          "Duration": 40
		        });
				array_push(State.actions, {Action: "Wait", Tags: [], Duration: 50});
				array_push(State.actions, {Action: "ResetHitstun"});
			}
		}
	}
	Grounded = true;
	yspeed = 0;
}

//Hitstun
if(hitstun > 0){
	hitstun--;
	if(hitstun <= 0){
		hitstun = 0;
		if(hitstunType > 0){
			array_push(State.actions, {Action: "Knockdown"});
		}
	}
}

//Collision
var collidedHitboxes = [];
for(var i = 0; i < array_length(Hurtboxes); i++){
	with(Hittable){
		if(self.id == other.id){
			continue;
		}
		for(var i2 = 0; i2 < array_length(Hitboxes); i2++){
			if(rectangle_in_rectangle(
				other.x + other.Hurtboxes[i].XOffset * other.dir - other.Hurtboxes[i].Width / 2, 
				other.y - other.Hurtboxes[i].YOffset, 
				other.x + other.Hurtboxes[i].XOffset * other.dir + other.Hurtboxes[i].Width / 2, 
				other.y - other.Hurtboxes[i].YOffset - other.Hurtboxes[i].Height, 
				x + Hitboxes[i2].XOffset * dir - Hitboxes[i2].Width / 2, 
				y - Hitboxes[i2].YOffset - Hitboxes[i2].Height / 2, 
				x + Hitboxes[i2].XOffset * dir + Hitboxes[i2].Width / 2, 
				y - Hitboxes[i2].YOffset + Hitboxes[i2].Height / 2)){
				array_push(collidedHitboxes, [Hitboxes[i2], self, i2, (other.x < x) * 2 - 1, x + Hitboxes[i2].XOffset * dir, y - Hitboxes[i2].YOffset]);
			}
		}
	}
}

var collidedHitbox = {Disabled: true};
var collidedHitboxData = [];
for(var i = 0; i < array_length(collidedHitboxes); i++){
	if(!struct_exists(collidedHitbox, "Priority") || collidedHitboxes[i][0].Priority > collidedHitbox.Priority){
		collidedHitbox = collidedHitboxes[i][0];
		collidedHitboxData = collidedHitboxes[i];
	}
}
if(!struct_exists(collidedHitbox, "Disabled")){
	if(iframes <= 0){
		StatusHit(self);
		if(struct_exists(collidedHitbox, "OnHit") && variable_instance_exists(collidedHitboxData[1], "State")){
			collidedHitboxData[1].State.actions = collidedHitbox.OnHit;
		}
		if(struct_exists(collidedHitbox, "VerticalKnockback")){
			yspeed = -collidedHitbox.VerticalKnockback;
		}
		if(struct_exists(collidedHitbox, "Hitspark")){
			switch(collidedHitbox.Hitspark){
				case "HitSpark":
					with(effect_create(collidedHitboxData[4], collidedHitboxData[5], HitSpark)){
						image_xscale = -collidedHitboxData[3];
					}
					break;
			}
		}
		if(struct_exists(collidedHitbox, "HorizontalKnockback")){
			Movement = {Frame: 0, Distance: -collidedHitbox.HorizontalKnockback, Duration: 6, Ease: 1.5, Direction: collidedHitboxData[3]}
		}
		if(struct_exists(collidedHitbox, "Hitstop")){
			GameCont.hitstop = collidedHitbox.Hitstop;
		}
		if(struct_exists(collidedHitbox, "Hitstun")){
			hitstun = collidedHitbox.Hitstun;
			if(struct_exists(collidedHitbox, "HitstunType")){
				hitstunType = collidedHitbox.HitstunType;
			}
		}
		array_delete(collidedHitboxData[1].Hitboxes, collidedHitboxData[2], 1)
		array_push(collidedHitboxData[1].UsedHitboxes, collidedHitboxData[0])
		combo++;
	}
}

//Walls
if x > 420 x = 420;
if x < 10 x = 10;