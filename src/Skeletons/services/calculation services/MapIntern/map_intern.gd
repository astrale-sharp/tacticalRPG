extends Reference
class_name MapIntern
"""
this is the spatial repres of the world
used to know 
	where can move
	how far is who
	who is accessible

it must be informed when player moves or die to update dispo cases accordingly
	when obstacle are destroyed/moved
	
it has a layers
	ground
		case are filled with a score or a tag == info for how hard it is to move
	obstacle
		it is updated when obstacles are moved or destroyed
	map_bodies
		contains ref th=o the actors, updated when they move/die

"""
const EMPTY = -1
var map := IDijkstraMap.new()

#pos -> Actor, Obstacle, Ground
var Team_id_to_BodiesLayer
var ObstacleLayer
var GroundLayer


func _OnBodyDisapepear():
	pass

func _OnObstacleDisapepear():
	pass

func _OnBodyDissappear():
	pass

func _OnBodyMoved():
	pass

func _OnObstacleMoved():
	pass


func enable_positions(list : Array):
	pass	
	
func disable_positions(list : Array):
	pass

func reachable_positions_from(pos,unavailable)-> Array:
	var reachables : Array
	#disable unreachable positions for player such as ennemy, obstacles
	#get undercost
	#remove busycase from available
	return reachables

func case_is_busy(pos):
	var body_on_case
	if body_on_case or ObstacleLayer[pos] != EMPTY: return true
	return false

# does not support moving two thing on the same place
#these object may be multiple case large, you should call this on each case

func move_body_case_from_to(team_id,from,to):
	if case_is_busy(to): return FAILED
	var BodiesLayer = Team_id_to_BodiesLayer[team_id]
	
	BodiesLayer[to] = BodiesLayer[from]
	BodiesLayer[from] = EMPTY
	return OK
	
func move_obstacle_case_from_to(from,to):
	if case_is_busy(to): return FAILED
	ObstacleLayer[to] = ObstacleLayer[from]
	ObstacleLayer[from] = EMPTY
	return OK
	
func free_obstacle_case(team_id,pos):
	var BodiesLayer = Team_id_to_BodiesLayer[team_id]
	ObstacleLayer[pos] = EMPTY
	
func free_body_case(team_id,pos):
	var BodiesLayer = Team_id_to_BodiesLayer[team_id]	
	BodiesLayer[pos] = EMPTY

func get_possibles(team_id,map_pos,terrains = {},max_cost = INF):
	"returns all reachable positions from map_pos for the member of team_id, map_pos excluded"
	var possibles := []
	map.recalculate(
		PoolIntArray(map.position_to_id(map_pos)),
		{
		'input is destination' : false,
		'maximum cost' : max_cost,
		'initial costs' : 0.0,
		'terrain weights' : terrains,
		}
	)
func get_cost_to(team_id, from : Vector2,to : Vector2, max_cost = INF,terrains={}):
#	var BodiesLayer = Team_id_to_BodiesLayer[team_id]
	map.recalculate(
					PoolIntArray(map.position_to_id(from)),
					{'input is destination' : false,
					'maximum cost' : max_cost,
					'initial costs' : 0.0,
					'terrain weights' : terrains
					}
					)
	map.NativeMap.get_cost_at_point()
