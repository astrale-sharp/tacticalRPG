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
const EMPTY = 0
var map := DijkstraMap.new()

#pos -> Actor, Obstacle, Ground
var BodiesLayer
var ObstacleLayer
var GroundLayer



func enable_positions(list : Array):
	pass
	
func disable_positions(list : Array):
	pass

func case_is_busy(pos):
	if BodiesLayer[pos] != EMPTY or ObstacleLayer[pos] != EMPTY:return true
	return false

# does not support moving two thing on the same place
#these object may be multiple case large, you should call this on each case

func move_body_case_from_to(from,to):
	if case_is_busy(to): return FAILED
	
	BodiesLayer[to] = BodiesLayer[from]
	BodiesLayer[from] = EMPTY
	return OK
	
func move_obstacle_case_from_to(from,to):
	if case_is_busy(to): return FAILED
	ObstacleLayer[to] = ObstacleLayer[from]
	ObstacleLayer[from] = EMPTY
	
	return OK
	
func free_obstacle_case(pos):
	ObstacleLayer[pos] = EMPTY
	
func free_body_case(pos):
	BodiesLayer[pos] = EMPTY


