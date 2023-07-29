//https://yal.cc/gamemaker-checking-whether-a-string-is-a-valid-number/
function string_is_real(str){
	var s = str;
	var n = string_length(string_digits(s));
	return n > 0 && n == string_length(s) - (string_ord_at(s, 1) == ord("-")) - (string_pos(".", s) != 0);
}