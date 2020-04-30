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
#------------------------------------#
#------------SIGNALS-----------------#
signal FightStarted
signal FightEnded

signal SetStarted
signal SetEnded
#------------DEPENDANCY--------------#
#------------------------------------#

#------------------------------------#
var FightData #will contain all the data given for doing the fight
	#a map,teams, condition for end fight

#------------------------------------#

#user info query
var FightGui #general display of info and permaOption or choice that dont require the map FightObject Wires as it likes the input requested to gui devices here or in the fightmap

# connected outputs
var MapGui # handles repres of blocks, player obstacle
var DualScreenGui 
var ConsoleGui

var Cursor #optionnal

#---------------CALCULATION------------------#
var MapIntern # handles calculationn can i go there, what cost?

#-----------CONNECTIONS--------------------#
var InputHandler : FightInputHandler #if you require an input you have access to that, it will require it for you and give you the data
var MyAnimationCenter : FightAnimationCenter #you have to animate something on screen talk to me

#-------------UTILS-----------------#
var MyITeams #interface for Teams, is given by me a func for deciding things 
#------------------------------------#
#------------PRIVATE-----------------#
var KeepFight : Condition


#------------------------------------#
#------------------------------------#
func fight():
	emit_signal("FightStarted")
	#this is wrong, you should check at the end of each actor turn or after each action
	while KeepFight.carry_on():
		yield(play_set_of_actors(),"completed")
	
	emit_signal("FightEnded")


func play_set_of_actors():
	"""
	will do for a prototype
	but i'd like to be possible for an actor to be able to play later in the turn, by resorting the list for instance
	"""
	var curr_player : FightActor
	emit_signal("SetStarted")
	
	var next_actor_set #: SetOfPlayer = MyITeams.next_set_of_player() #get a list of actors of the same team sorted by init
		#sortedsort func isnt enough to be fair! if get_reamaining always return same list, you should beware that at equal init, equally likely to start!
	yield(PUT_next_actor_in(curr_player),\
		"completed")

	
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
	else:
		while not next_actor_list.empty():
			var actor = pop_IA_list_choice(next_actor_list)
			yield(actor.play_turn(),"completed")
			if not KeepFight.carry_on(): break


	emit_signal("TurnEnded")

func PUT_next_actor_in(buffer):
	var input_type = Constants.FightSystemConstants.Inputs.Types.choice_in_actor_list
	var requester = FightInputRequester.new()
	InputHandler.request_input(input_type, next_actor_set, requester )
	yield(requester,"Received")
	var buffer  = requester.buffer
	
	
#------------------------------------#
#------------------------------------#
func initiate():
	#load all and try to fulfill the dependancy or fails
	#------------SELF------------#
	dependancy_check()
	
	KeepFight = FightData.EndCondition
	
	InputHandler = FightInputHandler.new()
	MyAnimationCenter = FightAnimationCenter.new(ConsoleGui,MapGui,DualScreenGui)
	#------------Chils----------------#
	#connects them to connection Objects
	
	#initiate everyObject to fullfill dependancies
	
	#FightMap is initiated
	#ListUtils = ...new(InputHandler)
	#connect everything that needs to be connected on order to do the fight
	pass

func dependancy_check():
	if not MyITeams:
		printerr("no Teams, cant initiate")
		queue_free()
	if not FightData:
		printerr("no FightData, cant initiate")
		queue_free()
	if not MapGui:
		printerr("no MapGui, cant initiate")
		queue_free()	
	if not ConsoleGui:
		printerr("no ConsoleGui, cant initiate")
		queue_free()
	if not DualScreenGui:
		printerr("no DualScreenGui, cant initiate")
		queue_free()
	if not MapIntern:
		printerr("no MapIntern, cant initiate")
		queue_free()


#for testing me, start with something very simple, a console with only one possible action but info displayed about mini list en cours + initiative, player en cours etc
#------------------------------------#
#-------------horrible fixes-----------------#

	
func pop_IA_list_choice(list : Array):
	return list.pop_front()
	
