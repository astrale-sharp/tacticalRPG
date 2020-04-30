extends Reference
class_name ObjectiveMap
"""
its a one layerMap full of number
obtained by operation on a more complex map
its suitable to perform lots of A* operation obdviously
"""
const EMPTY = 0 #cost should never be zero, setting a 0 score manually will crash

var map = [] # do i need this map in the end? i would have needed if wigth belong to the arrows but it velongs to the point
var MyAstar = AStar2D.new()
var MyAstarUtils = Astar2Dutils.new()
var MySize

func _init(size):
	MySize = MySize
	generate_map(size)
	connect_map() # generate corresponding MyAstar


#helpers
func generate_map(size):
	MySize = size
	map = MyAstarUtils.generate_map(size)

func out_of_bonds(pos : Vector2):
	MyAstarUtils.out_of_bonds(pos,MySize)

func id_to_vector(id):
	return MyAstarUtils.id_to_vector(id,MySize)

func vector_to_id(vec):
	return MyAstarUtils.vector_to_id(vec,MySize)

func get_neighbour(pos : Vector2):
	"""
	get up to 4 direct neigbourh of pos
	not if they are out of bonds
	?not if score = INF
	"""
	return MyAstarUtils.get_neighbour(pos,MySize)

func connect_map(gates = []):
	#connects neigboug on the astar2D backend
	var each_point
	var score
	
	var neigbour_score
	for x in range(MySize):
		for y in range(MySize):
			each_point = Vector2(x,y)
#			score = map[x][y]
			for each_neigbour in get_neighbour(each_point):
#				neigbour_score = map[each_neigbour.x][each_neigbour.y]
				MyAstar.connect_points( MyAstarUtils.vector_to_id(each_point,MySize),MyAstarUtils.vector_to_id(each_neigbour,MySize))
			#for each neighbour , connect 2 ways weigh = score du point auquel on connecte 
	#connect gates
	pass

func copy_values(_2Darray : Array,optional_translation=null,gates = []):
	"""
	copy x and y values (should be float or int) to my map, optionnaly applying a translation_func
	2D array should have the right size
	might make this a byte_array
	"""
	MyAstar.clear()
	
	if MySize != _2Darray.size() :printerr("array has the wrong dim")
	for x in range(MySize):
		for y in range(MySize):
			var score = _2Darray[x][y] if not optional_translation else optional_translation.call_func(_2Darray[x][y])
			if score == EMPTY: push_error("")
			map[x][y] = score
			#this is terrible performance, i wont remove astar before my prototype is over though
			MyAstar.add_point(MyAstarUtils.vector_to_id(Vector2(x,y)),Vector2(x,y),score)
	connect_map(gates)


func accessible(start_pos : Vector2,thresh_hold):
	"""
	return a list of accessible position : Vector2D from pos, with score
	?in the order A* finds them? no dont care, sort it later lazy ass 
	par convention, la position de départ n'est pas accessible
	"""
	var to_check = [MyAstarUtils.vector_to_id(start_pos,MySize)]
	var accessList = []
	var curr_id
	#start_pos
	while not to_check.empty():
		#part d'un point
		curr_id = to_check.pop_front()
		#accessible et à check ssi cost (start -> curr_point) < threshhold
		#si ce point est accessible, ses 'voisins' sont à check si ils sont pas déjà accessible et lui est accessible
		if MyAstarUtils.compute_cost(MyAstar,MyAstarUtils.vector_to_id(start_pos,MySize),curr_id) <= thresh_hold:
			accessList.append( MyAstarUtils.id_to_vector(curr_id,MySize))
			for id in MyAstar.get_point_connections(curr_id):
				if not id in accessList:
					to_check.append(id)
		
		#trouve le chemin vers les autres points, si ils sont accessible, accessible.add à trier.add
	accessList.erase(MyAstarUtils.vector_to_id(start_pos,MySize))#par convention , la case sur laquelle on est est inacessible
	return accessList
