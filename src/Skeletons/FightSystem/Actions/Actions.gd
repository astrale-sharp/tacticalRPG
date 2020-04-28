extends Resource
class_name FightAction
"""
representation of an action in the fight
	-a move
		in the intent sheet, the move must be communicated to the world this way
	-an attack
when done it goes in
	->animation center where it is animated
	->event_center where it warns other fightActors
	-> ??? where it serves to update the InternMap
"""

const __Constants = Constants.FightSystemConstants.FightActorConstants.ActionConstant

class FightActionMove:
	extends FightAction
	var type = __Constants.Type.move
	var from
	var to
	var F_actor

class FightActionAttack:
	extends FightAction

	var type = __Constants.Type.attack
	var launcher
	var target
	var res #:AssaultResult

	func _init(AR):
		pass

class FightActionAttackFails:
	extends FightAction
	var type = __Constants.Type.attackFails
	var launcher
	var target
	var res

class FightActionCastSpell:
	extends FightAction
	var type = __Constants.Type.cast_spell

class FightActionComplex:
	extends FightAction
	"""
	here to make sure some actions are obligatory done one after another
	they trigger the event system but cant be interrupted
	useful for implementing charge for instance (actor moves and strikes or actor moves and strikes and move and no interruption possible)
	"""
	var actionList = []
	var type = __Constants.Type.complex
