var CharacterList = LoadPlayerData();
var CharacterFileNames = struct_get_names(CharacterList);
for(var i = 0; i < array_length(CharacterFileNames); i++){
	with(instance_create_layer(
		((room_width-100)/(array_length(CharacterFileNames) + 1))*(i + 1)+50, 
		room_height/2, layer, CharSelectButton)){
		Character = CharacterFileNames[i];
		Text = CharacterList[$ CharacterFileNames[i]].Name;
		trace(Text);
	}
}
instance_create_layer(room_width/2, room_height/2 + 150, layer, EditorButton)