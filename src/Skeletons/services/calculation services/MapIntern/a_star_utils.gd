extends Reference
class_name Astar2Dutils
"""
here to perform map operation
on objectiveMaps (=full of numbers)

?Consider removing astar2D dependancies as, my use of it currently is very poor,
	its likely reimplementing it in gdscript will give better performance than my current use
"""
#for all case
#for neigbourh(case) #generate if included in the map 4 voisin proches
#connecting neigbours 

func compute_cost(astar : AStar2D, from , to, size = -1):
	"""
	if from and two are vectors, size must be set
	otherwise from and two are ids 
	"""
	if from == to: return 0
	var sum = 0
	
	if size != -1:  #convert vect2->id
		from = vector_to_id(from,size)
		to = vector_to_id(to,size)
	#sum weigh shortest path
	var path_ids = astar.get_id_path(from,to)
	#weight of starting_point doesnt count
	path_ids.remove(0)
	for id in path_ids:
		sum += astar.get_point_weight_scale(id)

	return sum

func vector_to_id(pos : Vector2,size):
	return pos.x + size*pos.y

func id_to_vector(id : int,size):
	#trust me im the doctor
	var y = int(id/size) 
	var x = id - y*size
	return Vector2(x,y)


func out_of_bonds(pos : Vector2,size):
	if pos.x < 0 or pos.y <0 or pos.x >= size or pos.y >= size: return true
	return false

func generate_map(size,value = 1):
	"""
	return a sized map filled with value
	"""
	var l = []
	var whole = []
	if size == 0: push_error("size zero not supported")
	for k in size:
		l.append(value)
	for k in size:
		whole.append(l.duplicate(true))
	return whole

func get_neighbour(pos : Vector2, size):
	"""
	get up to 4 direct neigbourh of pos
	not if they are out of bonds
	?not if score = INF
	"""
	var res = []
	var new_vec
	
	for new_x in [-1,1]:
		new_vec = Vector2(pos.x + new_x, pos.y )
		res.append(new_vec)
		
	for new_y in [-1,1]:
		new_vec = Vector2(pos.x ,\
						pos.y + new_y)
		res.append(new_vec)
	
	for r in res: 
		if out_of_bonds(r,size):
			res.erase(r)
	
	return res

