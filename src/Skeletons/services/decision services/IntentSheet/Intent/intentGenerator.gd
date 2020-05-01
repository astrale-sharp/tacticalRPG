extends Reference
class_name IntentGenerator
"""
owned by a fight actor
generates its intent when it is its turned based on guiInputs, or IAdecision
"""
var fight_actor : FightActor

func _init(_FightActor) -> void:
	fight_actor = _FightActor

func generate(context : FightContext,decision)-> Intent:
	
	return Intent.new()
