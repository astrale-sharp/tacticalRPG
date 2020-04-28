extends "res://addons/gut/test.gd"
"""
test for essential pipes and the pipeline reader
"""

var Ppl : Pipeline
var p1 : Pipe
var p2 : Pipe
var pa : Pipe
var pb : Pipe
var I : Intent

func before_each():
	Ppl = Pipeline.new()
	p1 = Pipe.new()
	p2 = Pipe.new()
	p1.type = p1.Type.STATE_UPDATE
	p2.type = p2.Type.STATE_UPDATE
	
	pa = Pipe.new()
	pb = Pipe.new()
	I = Intent.new()
	

func test_get_upper_pipe():
	assert_ne(p2,p1,"this would sxrew test")
	
	assert_eq(Ppl.get_upper_pipe(p1,p2),p1,"same prio, defenseur wins")
	p2.priority = 1
	assert_eq(Ppl.get_upper_pipe(p1,p2),p2,"higher prio, wins")
	assert_eq(Ppl.get_upper_pipe(null,p2),p2,"default, wins")
	assert_eq(Ppl.get_upper_pipe(p1,null),p1,"default, wins")
	

func test_sort_one_pipe():
	pending()
	#goes to the right place
	p1.place = p1.Place.FIRST
	p2.place = p1.Place.LAST
	Ppl.sort_one_pipe(p1,false)
	Ppl.sort_one_pipe(p2,false)
	assert_eq(Ppl.firstPipe,p1)
	assert_eq(Ppl.lastPipe,p2)
	#higher prio wins the place
	p2.place = p2.Place.FIRST
	p2.priority = 1
	Ppl.sort_one_pipe(p2,false)
	assert_eq(Ppl.firstPipe,p2)

func ReadPipeline_with_pipes(pipes):
	pass

func test_pipelineRead():
	pending()
	var P = Pipe.new()
	#define P here
