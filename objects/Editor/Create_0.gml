Data = LoadPlayerData();

SelectedStruct = [];
RebuildTree = true;

TreeButtons = [];
Buttons = [];

Scroll = 0;
TreeScroll = 0;

StageCont.boundaries = {Floor: room_height/2.5-60, Ceiling: 10, LWall: 10, RWall: room_width/2.5-10};

with(Hittable){
	x = (StageCont.boundaries.LWall + StageCont.boundaries.RWall) / 2;
	y = StageCont.boundaries.Floor;
}