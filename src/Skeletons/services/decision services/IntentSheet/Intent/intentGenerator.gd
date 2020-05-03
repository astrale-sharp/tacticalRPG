extends Reference
class_name IntentGenerator
"""
owned by a fight actor
generates its intent when it is its turned based on guiInputs, or IAdecision
"""

func generate(context : FightContext,decision)-> Intent:
	
	return Intent.new()
