// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function instance_create(_x,_y,_GameObject){
	instance_create_layer(_x,_y,layer,_GameObject);
}
function effect_create(_x,_y,_GameObject){
	instance_create_layer(_x,_y,layer_get_id("Effects"),_GameObject);
}