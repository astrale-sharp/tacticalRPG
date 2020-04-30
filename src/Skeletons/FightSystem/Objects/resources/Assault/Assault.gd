extends Node
class_name Assault
"""
responsible for an Assault ::== an attack from a fightActor A To another B
		with A giving AttackData
			B DefenceData
			
Flow of data:
	FightSystem.AttackResultCalculator.decide(AttackData,DefenceData) --> AttackResult

essentially dictates how much damage what attack does to what defence according to what you want (armor, weakness, etc)

for instance, YourGameAttackData inherints AttackData
	YourGameAttackData.type = WOOD
	YourGameDefenceData.type = Silver(WeakAgainstWood)
	AttackResultCalculator multiply the dommage by 1.5 ( or sqrt(pi*YourGameAttackData.mood) for all I care)

this is the first Result, this result is inserted in the pipeline, possibly changing it and doing other stuff this class doesnt care about


you should overwrite each class in new scripts in should place in Assaults
"""
class AttackData:
	extends Reference
	var property = {}

class DefenceData:
	extends Reference
	var property = {}
	
class AssaultResult:
	extends Reference
	var property = {}
	var conclusion_string # text that explains what happenned during the assault to the players through a gui, has been accessied by the pipes
	
class AssaultCalculator:
	"""should be NEEDED by FightSystem in his AttackResultCalculator"""
	extends Reference
	
	func decide():
		return AssaultResult.new()
