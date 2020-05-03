extends Reference
class_name Team

var unique_id := 0
var is_AI := false
var actorList := []

func _init(actors,isAI) -> void:
	actorList = actors
	is_AI = isAI
