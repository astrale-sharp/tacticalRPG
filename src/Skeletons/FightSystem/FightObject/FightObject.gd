extends Node2D
class_name FightObject
"""
skeleton about Fights
	responsible for everything a fight should hold
		and how it connects
		
	a map
	gui
	turn
	when fight is over
	fight logic
	


children attackresultcalculator
gui
teams -> FightActors
intentSheet -> pipeline ?
pipeline?

	
"""
signal FightStarted
signal FightEnded

signal TurnStarted
signal TurnEnded


var KeepFight : Condition#decides if it should go on

var FightData #will contain all the data given for doing the fight
	#a map,teams
	
var InputHandler : FightInputHandler #if you require an input you have access to that, it will require it for you and give you the data
var FightGui #general display of info and permaOption or choice that dont require the map FightObject Wires as it likes the input requested to gui devices here or in the fightmap
var MyAnimationCenter : FightAnimationCenter
var MyFightMapDisplay : FightMapGui # useful for displaying the map with actors on it, and specific gui (like a cursor) on it for some choice
var MyFightMap# : FightMap # does all map calculation, what does it cost from here to here? what does this path cost? whith that much, where can i go ->cangoData
	#is the internal state of the map

#var Teams #info about fightActors, listing ability#stock pls Team Object
var MyITeams #interface for Teams, is given by me a func for deciding things 
	#has ref to each team

func init_fight(FightData):
	MyITeams = ITeams.new(FightData.Teams)
	
	#this is very hacky and should be changed
	KeepFight = Condition.new(MyITeams)
	
func initiate_insides():
	#initiate everyObject to fullfill dependancies
	#FightMap is initiated
	InputHandler = FightInputHandler.new()
	MyAnimationCenter = FightAnimationCenter.new(MyFightMapDisplay.MyConsoleAnimator,MyFightMapDisplay.MyGUIMapAnimator,MyFightMapDisplay.MyDual_screenAnimator)
	#ListUtils = ...new(InputHandler)
	#connect everything that needs to be connected on order to do the fight
	pass


func fight():
	emit_signal("FightStarted")
	#this is wrong, you should check at the end of each actor turn or after each action
	while KeepFight.carry_on():
		yield(turn(),"completed")
	
	emit_signal("FightEnded")

#for testing me, start with something very simple, a console with only one possible action but info displayed about mini list en cours + initiative, player en cours etc

func get_actor_list_choice(list,buffer):
	"""
	request a choice in actor list to be put in buffer
	"""
	var input_type = Constants.FightSystemConstants.Inputs.Types.choice_in_actor_list
	var requester = FightInputRequester.new()
	InputHandler.request_input(input_type, list, requester )
	yield(requester,"Received")
	return requester.buffer
	
func turn():
	"""
	will do for a prototype
	but i'd like to be possible for an actor to be able to play later in the turn, by resorting the list for instance
	"""
	var curr_player : FightActor
	emit_signal("TurnStarted")
	
	var next_actor_list = MyITeams.next_actors_list() #get a list of actors of the same team sorted by init
		#sortedsort func isnt enough to be fair! if get_reamaining always return same list, you should beware that at equal init, equally likely to start!
	
	#whats responsible for giving user choice in that list, interface between classic requester and unclassic data, a list of actors
	var gui_next_actor_list 
	yield(get_actor_list_choice(next_actor_list,gui_next_actor_list),'completed')
		
	#itering the actor
#	for list_of_fight_actors_by_team in list_of_list_of_fightActors_by_team:
	if not MyITeams.last_given.isAI():#is joueur
		#give choice and play choice until the mini list is empty
		while not next_actor_list.empty():
			#gui choice in next actor list
			yield(gui_next_actor_list.give_user_choice(),"completed")#might need gui or might already be connected or have reference probably the last two ;)
			curr_player = gui_next_actor_list.buffer #is the buffer where the choice has been put
			
			
			yield(curr_player.play_turn(),"completed")#player already connected or is passed info now?
			if curr_player.turn_done(): next_actor_list.erase(curr_player)
			if not KeepFight.carry_on(): break
	else:#if is AI
		while not next_actor_list.empty():
			var actor
			yield(actor.play_turn(),"completed")
			if not KeepFight.carry_on(): break


	emit_signal("TurnEnded")
