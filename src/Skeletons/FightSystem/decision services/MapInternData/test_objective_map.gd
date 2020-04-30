extends "res://addons/gut/test.gd"

var ObjMap : ObjectiveMap
var Utils = Astar2Dutils.new()
func before_each():
	ObjMap = ObjectiveMap.new(2)
	gut.p("test :")

func after_each():
	gut.p("_____")


#-----------------AstarUtils-----------------#

func test_generate_map():
	assert_eq(Utils.generate_map(1), [[1]] )
	assert_eq(Utils.generate_map(1,2), [[2]] )
	
	
	assert_eq(Utils.generate_map(2),
				[[1,1],\
				 [1,1] \
				])
	
	assert_eq(Utils.generate_map(3),
								[ \
								[1,1,1],\
								[1,1,1], \
								[1,1,1] \
								])

func test_out_of_bounds():
	
	#------size = 1 --------#
	
	gut.p("all size : 1")
	assert_false(Utils.out_of_bonds(Vector2(0,0),1),"in for all size")
	assert_true(Utils.out_of_bonds(Vector2(-1,0),1),"out for all size")
	
	gut.p("out for size 1")
	assert_true(Utils.out_of_bonds(Vector2(1,0),1))
	assert_true(Utils.out_of_bonds(Vector2(0,1),1))
	assert_true(Utils.out_of_bonds(Vector2(1,1),1))
	
	#------size = 2 --------#
	gut.p("all size : 2")
	assert_false(Utils.out_of_bonds(Vector2(0,0),2),"in for all size")
	assert_true(Utils.out_of_bonds(Vector2(-1,0),2),"out for all size")

	gut.p("in for size 2")
	assert_false(Utils.out_of_bonds(Vector2(1,0),2))
	assert_false(Utils.out_of_bonds(Vector2(0,1),2))
	assert_false(Utils.out_of_bonds(Vector2(1,1),2))
	
	gut.p("out for size 2")
	assert_true(Utils.out_of_bonds(Vector2(2,0),2))
	assert_true(Utils.out_of_bonds(Vector2(0,2),2))
	assert_true(Utils.out_of_bonds(Vector2(1,2),2))
	assert_true(Utils.out_of_bonds(Vector2(2,2),2))
	


func test_compute_cost():
	pending()
	gut.p("case  A : cost 1-> B :cost 2 -> C : cost 4")
	var astar = AStar2D.new()
	astar.add_point(1, Vector2(10,10),1)
	astar.add_point(2, Vector2(20,20),2)
	astar.add_point(3, Vector2(30,30),4)

	astar.connect_points(1,2)
	astar.connect_points(2,3)
		
	gut.p("A -> C : 2 + 4")
	assert_eq(Utils.compute_cost(astar,1,3),6)
	gut.p("C -> A : 1 + 2")
	assert_eq(Utils.compute_cost(astar,3,1),3)

	
func test_id_to_vec_to_id():
	var size = 4
	
	var vec = Vector2(3,1)
	var id = Utils.vector_to_id(vec,size)
	assert_eq( Utils.id_to_vector(id,size) ,vec,"you get the initial vector back")
	
	#----------------------------------#
	size = 25
	var vecs = [Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(12,8),Vector2(24,1),Vector2(24,24)]
	var ids = []
	for v in vecs: ids.append(Utils.vector_to_id(v,size))
	gut.p("the vecs : id")
	for i in range( vecs.size()):
		gut.p(str(vecs[i]) + " : " + str(ids[i]))
	
	for i in range( vecs.size()):
		var v = vecs[i]
		var Myid = ids[i]
		assert_eq(Utils.id_to_vector(Myid,size),v,"getting the initial vector back from id: " + str(Myid))
	#----------------------------------#
	
	id = 5
	vec = Utils.id_to_vector(id,size)
	assert_eq(Utils.vector_to_id(vec,size),5,"you should get the initial id back")
	
	# size is too small
	size = 2
	
	vec = Vector2(3,1)
	id = Utils.vector_to_id(vec,size)
	assert_ne(Utils.id_to_vector(id,size),vec,"if size is too small, it shouldnt work :/")
	 


func test_get_neigbour():
	#test when no size pb
	var size = 5
	var vec = Vector2(2,2)
	var expect = [Vector2(1,2),Vector2(3,2),Vector2(2,1),Vector2(2,3)]
	for testNeig in Utils.get_neighbour(vec,size):
		assert_has(expect,testNeig,"only those four neigbours")
		
	pending("test inner out of bounds")
	

func test_connect_map():
	pending()

func test_copyvalues():
	pending()

func test_accessible():
	pending()
