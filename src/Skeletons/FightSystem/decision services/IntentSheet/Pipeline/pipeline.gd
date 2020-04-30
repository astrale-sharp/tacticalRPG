extends Reference
class_name Pipeline
"""
the pipeline is constructed(handled in construct or init) with the pipes of 2 FightActor involved in an assault
an AR is presented to the pipeline
an AR (the final one that should be applied) goes out of the pipeline
along the way checkpipes inform FightActors of their now intents they might want to submit to the IntentSheet

#TODO how do we sort the pipes
	attacked actor has final word on the UpdateStatesPipes
	no need to sort CheckPipes
"""
var firstPipe
var lastPipe
var __check_pipes = []
var __MiddlePipes = []

var __current_intent # is this useful?
func get_upper_pipe(p1Defensor : Pipe, p2 : Pipe):
#	if p1Defensor.type == p2.Type.CHECK or p2.type == p2.Type.CHECK: push_error("cant sort check pipes")
	#assume p1 or p2 is not null.......
	if not p1Defensor: return p2
	if not p2: return p1Defensor
	#assume p1 and p2 are not null
	if p2.priority > p1Defensor.priority:
		return p2
	else: return p1Defensor
	
	
func sort_one_pipe(pipe :Pipe, isDefenseurPipe):
	# assumes a defensor doesnt send multiple competitive pipes at the same place
	if pipe.isMiddlePipe():
		__MiddlePipes.append(pipe)
		
	elif pipe.isFirstPipe():
		if isDefenseurPipe:firstPipe = get_upper_pipe(pipe,firstPipe)
		else: firstPipe = get_upper_pipe(firstPipe,pipe)
		
	elif pipe.isLastPipe():
		if isDefenseurPipe: lastPipe = get_upper_pipe(pipe,lastPipe)
		else: lastPipe = get_upper_pipe(lastPipe,pipe)
		
	else: printerr("where the fuck is that pipe supposed to go then ")

func generate(intent : Intent):
	"""
	#-----------#
	needs to construct itself according to the pipes of attack and defence (stocked in intent)
	the first attack result has been generated and his given here(generic one)
	#-----------#
	
	"""
	#generate and sort the structure thats going to be read
	__current_intent = intent
	var x = intent.get_pipes()
	var _attackorPipes = x[0]
	var _DefensorPipes = x[1]
	# separate check pipes
	for p in _attackorPipes:
		if p.type == Pipe.Type.CHECK:
			__check_pipes.append(p)
			_attackorPipes.erase(p)
		
	for p in _DefensorPipes:
		if p.type == Pipe.Type.CHECK:
			__check_pipes.append(p)
			_DefensorPipes.erase(p)
	
	#resolve fight between first pipes
	for p in _attackorPipes:
		sort_one_pipe(p,false)
	for p in _DefensorPipes:
		sort_one_pipe(p,true)
	# add all check pipes at the end
	
func read(originalAR):
	"""
	return final AR
	"""
	var readingorder = __MiddlePipes.duplicate(true)
	if firstPipe: readingorder.push_front(firstPipe)
	if lastPipe:readingorder.push_back(lastPipe)
	for ckP in __check_pipes:
		readingorder.append(ckP)

	var AR = originalAR
	for each_pipe in readingorder:
		AR = each_pipe.pipe(AR,__current_intent)

	return AR
	
