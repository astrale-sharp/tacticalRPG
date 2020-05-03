extends Option


func get_possible_places(_FightContext : FightContext)->Array:
	var possibles
	var _owner : FightActor = owner
	var team_id = _owner.team_id
	var map : MapIntern = _FightContext.get_map()
	var pos : Position2D = _owner.get_node("Status/map_pos")
	var max_cost = _owner.get_node("Status/MovePoints").value
	var terrains = _owner.get_node("Characteristics/Terrains").value
	return map.get_possibles(
			team_id,
			pos.position,
			terrains,
			max_cost)
	
func move_to_pos():
	#inform
	#reduce move points
	pass
