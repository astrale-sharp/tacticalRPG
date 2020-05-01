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

#TODO
func can_move(context)->bool:
	#checks if there is at least one case on which you can move
	return false

func can_attack(context):
	#checks if there's at least one target you can hit
	return false

func can_spell(context):
	#checks one spell you can cast
	return false


func generate_without():
	return possible_choice.duplicate(true)

func generate(context : FightContext):
	var send = generate_without()
	var move_context = context.move #FIXME
	var attack_context = context.attacl #FIXME
	if can_move(move_context):
		send.append(Constants.FightSystemConstants.Inputs.Choices.MOVE)
	
	if can_attack(attack_context):
		send.append(Constants.FightSystemConstants.Inputs.Choices.ATTACK)
	return send