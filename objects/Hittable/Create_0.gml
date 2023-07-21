Hurtboxes = [{
	XOffset: 0,
	YOffset: 0,
	Width: sprite_width,
	Height: sprite_height
}];
Hitboxes = [];
UsedHitboxes = [];
StatusEffects = [];

State = noone;
WaitTimer = 0;
Movement = noone;
Jumping = noone;
Grounded = true;
Gravity = 1;
LandingCancel = true;
yspeed = 0;
hitstun = 0;
hitstunType = 0;
combo = 0;
iframes = 0;
dir = 1;
inputdir = 1;

team = 0;

IdleAnim = sprite_index;

PlayerData = {
  Name: "TargetDummy",
  Attributes: {
    Hurtboxes: [
      {
        XOffset: 0,
        YOffset: 0,
        Width: 40,
        Height: 80
      }
    ],
    ForwardWalkSpeed: 2,
    BackwardWalkSpeed: 2,
    Gravity: 1,
    IdleAnim: "Sprite1"
  },
  Moves: [
  ]
}