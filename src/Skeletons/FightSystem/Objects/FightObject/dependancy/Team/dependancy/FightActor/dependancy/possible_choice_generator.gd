extends Reference
class_name ActorChoiceGenerator
"""
given context, tells whatever choice are accessible to the player
attack if on_range(player_ranges, MapData.EntityLayer)
move if at least on place where can move
object
spell (if there is spell left?)
pass

"""

var possible_choice = [
	Constants.FightSystemConstants.Inputs.Choices.PASS,
	Constants.FightSystemConstants.Inputs.Choices.ITEM,
	Constants.FightSystemConstants.Inputs.Choices.SPELL,
						]


func can_move(context):
	return true
func can_attack(context):
	return true

func generate(context):
	var send = possible_choice.duplicate(true)
	var move_context = context[0]
	var attack_context = context[1]
	if can_move(move_context): send.append(Constants.FightSystemConstants.Inputs.Choices.MOVE)
	if can_attack(attack_context): send.append(Constants.FightSystemConstants.Inputs.Choices.ATTACK)
	return send
