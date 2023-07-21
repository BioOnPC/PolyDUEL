function set_stage(_stage) {
	/// @function                 set_stage(_stage);
	/// @param {string}			  _stage	The stage being called for
	/// @description              Set the stage across all relevant objects. Returns whether the stage was successfully set correctly
	var struct_stage;
	
	with(UberCont) {
		stage = _stage;
		struct_stage = variable_struct_get(list_stages, stage); // Get the current stage information
		if(struct_stage = undefined) return false;				// Return false if no stage is found with that name
	}
	
	with(StageCont) {
		 // Set the sprite used for the stage
		stage_image = struct_stage.sprite;
		stage_index = foreground ? 0 : struct_stage.foreground;
		
		 // Copies the relevant layers
		array_copy(layers, 0, struct_stage.layers, foreground ? 0 : struct_stage.foreground, foreground ? struct_stage.foreground : array_length(struct_stage.layers));
		trace(layers)
		trace(foreground)
	}
	
	return true;
}

function scrStageHandler() {
	/*
		Each layer is listed with the following values:
			- Image alpha for the given layer (default 1)
			- Multiplier the given layer is parallaxed by (default 0)
			
		'foreground' defines the lowest layer in the foreground
	*/
	
	list_stages = {};
	
	with(list_stages) {
		order = [];
		
		training = { name : "Training Room", sprite : stgTraining, foreground: 2, 
					 layers : [
						 [1, 0],
						 [1, 0],
						 [1, 0],
						 [1, 0],
						 [1, 0]
					 ]};
		array_push(order, training); // Push the stage to the order of stages as its added
	}
}