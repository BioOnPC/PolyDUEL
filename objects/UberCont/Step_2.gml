if(mode > m_tran and !save_replay) save_replay = true; // Add a condition to check for if the player disabled replays once options are implemented
else save_replay = false;

for(var l = 0; l < array_length(pil); l++) { // Cycle through each Player's inputs
	 // Used to clip long lists of inputs
	if(array_length(pil[l]) >= 600 /* Amounts to effectively a full second's worth of constant differing inputs */) {
		if(save_replay) { // Copy soon-to-be delted inputs so you can access them later for replays and such
			var save = [];
			array_copy(save, 0, pil[l], 0, 540); 
			// PUT A SYSTEM FOR SAVING THE ARRAY TO A REPLAY FILE HERE LATER //
		}
		
		array_delete(pil[l], 0, 540); // Remove excess inputs from the log
	}
}