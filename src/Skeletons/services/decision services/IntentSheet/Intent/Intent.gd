extends Reference
class_name Intent

"""
responsability : representents an action a FightActor wants to occur
its gonna go on the intnt sheet where it will be treated in due time
its gonna be decided if and how the intent succeeds and what is the final result

who sees this intent?

assaultDealer must 'deal' with the intent, meaning getting an AssaultAttackData AssaultDefenceData out of it
-> intent.get_assault_data()

intentSheet needs to sort them by priority : last, 0,1,2,3,... first
intent.priority
	.still_applies()
	.fails() -> return action needed when action is failed
	.succeed() -> return action corresponding to immediate and total success of the intent  //generally called on moving which requires no check before succeeding in this prototype see comment in intentsheet.read() for more info
pipeline.generate(intent)
	uses intent data to extract pipes before it sorts them and be okay with itself

intent is generated on the turn of a fight actor by this fightActor by FightActor.intentGenerator
"""

var priority

var _attackorPipes
var _defensorPipes

var _assaultAttack
var _assaultDefence

func get_pipes():
	return [_attackorPipes,_defensorPipes]

func get_assault_data():
	return [_assaultAttack,_assaultDefence]#assaultAttack,AssaultDefence

func _still_applies():
	"""
	should be overwritten to see when the intent might not make sense anymore
	most of the time (so it should be automatic)
	if launcher or target is dead -> false
	if target is out of reach -> false
	"""

func fails():
	"""
	return action corresponding to automatic fails
	-might be ignored silently
	-might be animated in animation_center 
		ex: console prints wanted to attack but is to far
	"""
	return

func succeeds():
	"""
	return action corresponding to automatic success
	-movement action for instance
	"""
	return
	
