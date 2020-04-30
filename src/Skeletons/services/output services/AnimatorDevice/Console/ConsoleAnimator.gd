extends AnimatorDevice
class_name ConsoleAnimator
"""
interface between FightMapDisplay and the console able to be animated
it reads Animation events to the console to ensure correct animation is done
"""

signal Finished

var console : Console

func _init(cons):
	console = cons
	
	
func readConstant(_const):
	"""
	for each constant in console_enum, implement a different call to console
	appear
	disappear
	read line
	read_all
	pause #fixed time for now
	
	#later
	change_style #need a way to have args, can wait
	tremble
	"""
	match _const:
		0:pass

func animate(ConsoleData):
	console.throw(ConsoleData.throw)
	# it is imply first constant should be appear
	# if not ConsoleData.description[0] == constant_appear: read(constant_appear)
	for AdequateConstant in ConsoleData.description:#this is read as constant in an enum belonging to Constant!!!
		yield(readConstant(AdequateConstant),"completed")
	
	#it is implied last constant should be disappear
	# if not ConsoleData.description[-1] == constant_disappear: read(constant_disappear)
