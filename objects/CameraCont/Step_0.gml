var left = 0;
var leftSet = false;
var right = 0;
var rightSet = false;
with(Hittable){
	if(!leftSet || x < left){
		left = x;
		leftSet = true;
	}
	if(!rightSet || x > right){
		right = x;
		rightSet = true;
	}
}

var camSize = abs(left-right) + 50;
camSize = min(camSize, StageCont.maxCameraSize);
camSize = max(camSize, StageCont.minCameraSize);
camera_set_view_size(cam, camSize, round(camSize/16*9));
var camPos = (left+right)/2;
camPos = max(camPos, StageCont.boundaries.LWall - StageCont.cameraBoundary + camera_get_view_width(cam)/2);
camPos = min(camPos, StageCont.boundaries.RWall + StageCont.cameraBoundary - camera_get_view_width(cam)/2);
camera_set_view_pos(cam, camPos - camera_get_view_width(cam)/2, StageCont.boundaries.Floor - camera_get_view_height(cam) + StageCont.cameraFloor);