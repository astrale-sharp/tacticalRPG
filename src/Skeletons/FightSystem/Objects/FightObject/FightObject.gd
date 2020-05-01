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

signal TurnStarted
signal TurnEnded

signal SetStarted
signal SetEnded

signal PlayStarted
signal PlayEnded

#------------DEPENDANCY--------------#
#------------------------------------#

#-------------RESOURCE-----------------#
var _FightData : FightData  #will contain all the data given for doing the fight
	#a map,teams, condition for end fight
var _FightContext: FightContext #contains all the now data of the fight
	#needed by actors
#---------------OUTPUT DEVICES---------------#

#user info query
var FightGui : FightUserGui #general display of info and permaOption or choice that dont require the map FightObject Wires as it likes the input requested to gui devices here or in the fightmap

# connected outputs
var MapGui : GuiMapAnimator # handles repres of blocks, player obstacle
var DualScreenGui : DualScreenAnimator
var ConsoleGui : Console

var _Cursor : Cursor #optionnal

#---------------CALCULATION------------------#
var _MapIntern : MapIntern# handles calculationn can i go there, what cost?

#-----------CONNECTIONS--------------------#
var InputHandler : FightInputHandler #if you require an input you have access to that, it will require it for you and give you the data
var MyAnimationCenter : FightAnimationCenter #you have to animate something on screen talk to me
var event_center : EventCenter
#--------------DECISIONS--------------#
var intent_sheet : IntentSheet

#-------------UTILS-----------------#
var MyITeams : ITeams #interface for Teams, is given by me a func for deciding things 
#------------------------------------#
#------------PRIVATE-----------------#
var KeepFight : Condition


#------------------------------------#
#------------------------------------#
func fight():
	emit_signal("FightStarted")
	#this is wrong, you should check at the end of each actor turn or after each action
	while KeepFight.evaluate():
		emit_signal("TurnStarted")
		while MyITeams.someone_can_play():
			yield(play_set_of_actors(),"completed")
		emit_signal("TurnEnded")
	emit_signal("FightEnded")


func play_set_of_actors():
	"""
	will do for a prototype
	but i'd like to be possible for an actor to be able to play later in the turn, by resorting the list for instance
	"""
	var curr_player : FightActor
	emit_signal("SetStarted")
	
	var next_actor_set : SetOfActors = MyITeams.next_set_of_player() #get a list of actors of the same team sorted by init
		#sortedsort func isnt enough to be fair! if get_reamaining always return same list, you should beware that at equal init, equally likely to start!


	
	#itering the actor
#	for list_of_fight_actors_by_team in list_of_list_of_fightActors_by_team:
	if not next_actor_set.isAI:#is joueur
		#give choice and play choice until the mini list is empty
		while not next_actor_set.empty():
			#gui choice in next actor list
			var state : GDScriptFunctionState = GUI_GET_next_actor_set_from(next_actor_set)
			curr_player = state.resume()

			
			while not curr_player.is_active(_FightContext):
				emit_signal("PlayStarted")
				yield(curr_player.play_turn(_FightContext) ,"completed")
				emit_signal("PlayEnded")
				
			if not KeepFight.evaluate(): break
		emit_signal("SetEnded")
	else:
		while not next_actor_set.empty():
			var actor = next_actor_set.IA_choice()
			yield(actor.play_turn(),"completed") #note set of actors can share a number of DijkstraMaps
			if not KeepFight.evaluate(): break
	emit_signal("TurnEnded")


func OnActorTurnEnded(Actor):
	print("Actor turn ended : {}.".format(Actor.name))
	if not KeepFight.evaluate():
		end_fight()

func end_fight():
	emit_signal("FightEnded")
	print("Fight Ended !")

func GUI_GET_next_actor_set_from(actor_set):#test me
	var input_type = Constants.FightSystemConstants.Inputs.Types.choice_in_actor_list
	var requester = FightInputRequester.new()
	InputHandler.request_input(input_type, actor_set, requester )
	yield(requester,"Received")
	return requester.buffer
	
	
#------------------------------------#
#------------------------------------#
func initiate():
	#load all and try to fulfill the dependancy or fails
	#------------SELF------------#
	dependancy_check()
	wire_actors()
	KeepFight = _FightData.EndCondition
	
	InputHandler = FightInputHandler.new()
	MyAnimationCenter = FightAnimationCenter.new(ConsoleGui,MapGui,DualScreenGui)
	
	intent_sheet.connect("PortThisToWorld",MyAnimationCenter,"ReceiveAction" )
	intent_sheet.connect("PortThisToWorld",event_center,"_onActionDone" )
	#------------Childs----------------#
	#connect everything that needs to be connected on order to do the fight

#	connects all player to InputRequester
#	connect decision services to gui output services

	
	#initiate everyObject to fullfill dependancies
	
	#FightMap is initiated
	#ListUtils = ...new(InputHandler)

func wire_actors():
	var actors = MyITeams.get_all_actors()
	for actor in actors:
		actor.wire(intent_sheet,InputHandler,MapIntern)


func dependancy_check():
	if not MyITeams:
		printerr("no Teams, cant initiate")
		queue_free()
	if not _FightData:
		printerr("no _FightData, cant initiate")
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


	
