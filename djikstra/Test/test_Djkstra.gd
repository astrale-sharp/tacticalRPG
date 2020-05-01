extends "res://addons/gut/test.gd"

func test_basic():
	var map := DijkstraMap.new()
	gut.p(map.add_point(1))
	map.add_point(2)
	gut.p(map.connect_points(1,2,1.0))
	
func test_create_as_grid():
	var relative_connections := {}
	var initial_offset := 0
	var map = DijkstraMap.new()
	#UNCOMMENT IF YOU WANT TO SEE SOME DATA
#	for size in 4:
#		gut.p("size : " +str(size))
#		gut.p("id to pos :")
#		gut.p(Tcreate_as_grid(map,relative_connections,initial_offset,size))
	#END UNCOMMENT

	map = DijkstraMap.new()
	relative_connections = {Vector2.RIGHT : 1.0}
	
	var id_to_pos : Dictionary = Tcreate_as_grid(map,relative_connections,0,5)
	## we get a way to pos -> id
	var pos_to_id = {}
	for each_id in id_to_pos.keys():
		var each_pos = id_to_pos[each_id]
		pos_to_id[each_pos] = each_id
	##
	var this_pos = Vector2(2,2)
	
	assert_true(\
			map.has_connection(\
						pos_to_id[this_pos],\
						pos_to_id[this_pos + Vector2.RIGHT]\
						),\
			"a point not on the edge should be connected to its Right neighbour"
				)
	assert_false(\
			map.has_connection(pos_to_id[this_pos + Vector2.RIGHT],\
								pos_to_id[this_pos]\
								),\
			"but its not reciprocal"
				)
	
	
	
func Tcreate_as_grid(map,relatvConnect,initaloffset,size):
	var bitmap := BitMap.new()
	bitmap.create(Vector2.ONE * size)
	bitmap.set_bit_rect(Rect2(Vector2.ZERO,\
						Vector2.ONE * size),\
						true
					)
	
	
	return map.initialize_as_grid(bitmap,relatvConnect,initaloffset)


