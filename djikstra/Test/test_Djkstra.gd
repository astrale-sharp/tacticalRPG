extends "res://addons/gut/test.gd"

func test_basic():
	var map := DijkstraMap.new()
	gut.p(map.add_point(1))
	map.add_point(2)
	gut.p(map.connect_point(1,2,1.0))
	map
