extends Node
class_name FightActor
"""
responsible for an entity in the context of a fight

has an history concerning the fight
is in a team
has characs
	FightActor
		-> Team
		-> history .thisTurn .thisFight
		-> characs .initiative .force .dexterité .volonté .intelligence
		sig endOfTurn LevelUp
		
"""
signal PlayerTurnStart
signal PlayerTurnEnded



#-------------Dependancy-------------#
#EXTERN
var MyInputHandler : FightInputHandler
var IinputHandler #useful for making good request, when passing choice.const
var requester := FightInputRequester.new()
var intentSheet
#INTERN
var History : FightActorHistory= FightActorHistory.new()

#------------------SelfModule----------------#
var intent_generator #with a const from Constants.FightSystemConstants.Inputs.Choices and the data from an adequate request
		#generate an intent
var possible_choice_generator : ActorChoiceGenerator # generates choice dpending of context




var __decided_not_active : bool # should be set to false at the beginning of each turn

func OnBeginningTurn():
	#each fight turn
	History.flush_turn()
	 

func OnPlayerTurnStarted():
	"""
	"""
	__decided_not_active = false
	pass

func is_dead():
	print("fix player is dead")
	return false

func is_active():
	print("fix player is active")
	if __decided_not_active: return false
	return true
	#do other test to check if should be active

func turn_done():
	return is_active()

const myconst = Constants.FightSystemConstants.Inputs

func play_turn():
	emit_signal("PlayerTurnStart")
	#attirer le MapGui sur moi!!!!
	var context = [0,0] #elem1 = move context, elem2 = attack context
	var choice_list = possible_choice_generator.generate(context) #needs context,dont generate empty choices
	var choice = myconst.Choices.CANCEL


	while choice != myconst.Choices.CANCEL:
		#will you pass, move attack spell item?
		MyInputHandler.request_input(myconst.Types.choice_in_list,choice_list,requester)
		yield(requester,"Received")
		choice = requester.buffer #THIS SHOULD BE A CONST FROM Constants.FightSystemConstants.Inputs
	#how will you pass,etc
	if choice == myconst.Choices.PASS:
		#player decided it will not play, make him not active
		__decided_not_active = true
		emit_signal("PlayerTurnEnded")
		return
	else:
		# en fonction du type d'action décidé, demander le bon type d'input, se servir des données arrivantes pour générer une intent
		#type of action
		IinputHandler.intent_request(choice,requester,MyInputHandler)
		yield(requester,"Received")
		#specific of the action
		var intent = intent_generator.generate(choice,requester.buffer)
		intentSheet.submit(intent)
		
	emit_signal("PlayerTurnEnded")
