extends Reference
class_name Pipe
"""
object destined to be in a Pipeline
	yielded by a FightActor
	
responsability : receive a AttackResult Object + original data that have generated it
has the power to change it (and most of the time changes the history of the FightActor)
-> StateUpdatingPipes
might inform (by trigger of signal?) the FightActor so he might want to trigger a response later if the AttackResult correspond
-> CheckPipes


"""
enum Type {CHECK,STATE_UPDATE}
enum Place {FIRST, MIDDLE, LAST}

var priority = 0
var type = Type.CHECK
var place = Place.MIDDLE
var AssaultConstants = load("res://Autoload/Constants.gd").FightSystemConstants.FightActorConstants.AssaultConstant

func isMiddlePipe():
	return place == Place.MIDDLE
func isFirstPipe():
	return place == Place.FIRST
func isLastPipe():
	return place == Place.LAST
func isCheckPipe():
	return type == Type.CHECK
func isStateUpdatePipe():
	return type == Type.STATE_UPDATE

func pipe(AR, intent ):
	"""
	intent contains original data having generated AR, according to this and to AR i might
		StateUpdatingPipe : change AR property, change my fightActor history accordingly
		CheckPipe : inform my fightActor of something according to a condition (leading him to trigger new intent) OR i trigger new intent directly?
	"""
	var new_AR = AR
	return new_AR
