extends Option

signal Moved(from,to)

var path_move_points = "Status/MovePoints"
var path_map_pos = "Status/map_pos"
var path_Terrains = "Characteristics/Terrains"

var map : MapIntern
var pos : Position2D
var max_cost : float
var terrains : Dictionary
var _owner : FightActor
var team_id : int

func get_values(_FightContext):
	_owner  = owner
	team_id = _owner.team_id
	map = _FightContext.get_map()
	pos = _owner.get_node(path_map_pos)
	max_cost = _owner.get_node(path_move_points).value
	terrains = _owner.get_node(path_Terrains).value	

func get_possible_places(_FightContext : FightContext)->Array:
	var possibles
	get_values(_FightContext)
	return map.get_possibles(
			team_id,
			pos.position,
			terrains,
			max_cost)
	
func move_to_pos(to_pos,_FightContext : FightContext):
	#inform
	#reduce move points
	get_values(_FightContext)
	if not to_pos in get_possible_places(_FightContext):
		return printerr("posiiton non reachable")

	var cost = map.get_cost_to(team_id, pos.position,to_pos, max_cost,terrains)
	emit_signal("Moved",pos,to_pos)
	
