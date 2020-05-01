extends Reference
class_name FightUserGui


var currently_playing : FightActor setget set_currently_playing
var info_dict : Dictionary setget set_info_dict


func set_currently_playing(value):
	currently_playing = value

func set_info_dict(value):
	info_dict = value