if(instance_number(StageCont) > 1){
	instance_destroy();
}

boundaries		= {Floor: 220, Ceiling: 0, LWall: -190, RWall: 620};
cameraBoundary	= 40;
cameraFloor		= 40;
maxCameraSize	= 700;
minCameraSize	= 450;