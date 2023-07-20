function LoadPlayerData(){
	moveCharacterData();
	var Players = {};
	var file_name = file_find_first("Characters/*.json", 0);

	while (file_name != "")
	{
		var file = file_text_open_read("Characters/" + file_name);
		var json = "";
		while (!file_text_eof(file))
		{
			json += file_text_read_string(file) + "\n";
		    file_text_readln(file);
		}
		trace(file_name);
		Players[$ file_name] = json_parse(json);
		file_text_close(file);
	    file_name = file_find_next();
	}

	file_find_close(); 
	return Players;
}

function moveCharacterData(){
	var file_name = file_find_first("Characters/*.json", 0);
	if (file_name == ""){
		var included_file_name = file_find_first("IncludedCharacters/*.json", 0);
		while (included_file_name != "")
		{
			file_copy("IncludedCharacters/" + included_file_name, "Characters/" + included_file_name);
			included_file_name = file_find_next();
		}
	}
}