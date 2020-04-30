extends Node
class_name FightAnimationCenter
"""
animActions [ Animaction1,... ]
animAction [AnimConstant, OptionArgs1,...]
everything that is ported to world goes through me and my goal is to make it appear pretty on the screen
from AR.result_string i print on the console
from FightActor mutiple moving_event i animate a smooth movement (i have access to tilemap so)
from resolved Assault i make a miniscreen appear on which a repres of fightActors launch animation for the eyes of the player, representing whats happening


Techinicly inplementable: (but this prototype will have less)
___________
an action arrive, it is animated by step for each device
-console init style, console appear, text display, console dissappear #the first console appear may be omitted, at the end on the array , a console dissapear is implicit 
console anim style
-move p from a->b then b->c, possibly map blink, map tremble, gui_map.launch.animation(map_anim_string)

-duel screen
style_set, appear, disappear, set player on topright/bottomleft, launch anim animeString on bottomLeft or TopRight
style_anim, dualscreen anim


for this first implementation, anim will play one at a time and the following will be started when the one before finishes
possible:
	parrallel some animation if their media(console, map,etc) is available
"""

signal AllAnimationDone
signal AnimationStarted
signal AnimationDone


#var console
#var MapGui
#var DuelScreen #mini screen that pops showing animation of the attack/ the speel 
var IAction # interface between action and animation center, get animation steps
var __type_to_AnimatorDevice = {}
var __queue = []

func _init(_consoleAnimator : AnimatorDevice,\
	_MapGuiAnimator : AnimatorDevice,\
	_DuelScreenAnimator : AnimatorDevice\
	)-> void:
	__type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE] = _consoleAnimator
	__type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI] = _MapGuiAnimator
	__type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN] = _DuelScreenAnimator
	
func ReceiveAction(AnimActions):
	#put action on a queue
	__queue.push_back(AnimActions)
	# if not animating something, start animating again
	pass
	
func animate_all():
	"""
	animate all action in my queue until done
	do not call be again before i finished, it will launch parrallel process that empty the same queue at the same time...
	"""
	var AnimAction
	while not __queue.empty():
		AnimAction = __queue.pop_front()
		yield( animate(AnimAction) ,"completed")
	
	emit_signal("AllAnimationDone")
	# if moveAction, stall for complete movement 
		#MEANING, MOVE_ACTION_SHOULD WARN IF THEIR THE LAST MOVEMENT OR IF NOT POSSIBLE SOMEONE ELSE NEEDS TO DO IT
		#MEANING EITHER ANIMATION CENTER STALL FOR COMPLETE MOVEMENT OR INTENT_SHEET_DOES
		#not my responsibility to know what a moving event should look like, just give me a normal event i dont have to process i feel lazy

func animate(AnimAction : Array):
	
	var _const = AnimAction.pop_front()
	var device
	emit_signal("AnimationStarted")
	match _const:
		Constants.Gui.FightAnimation.AnimCode.CONSOLE_APPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE]
			device.visible = true
			
		Constants.Gui.FightAnimation.AnimCode.CONSOLE_DISAPPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE]
			device.visible = false
			
		Constants.Gui.FightAnimation.AnimCode.CONSOLE_READ_ONE:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE]
			device.callv("read_one",AnimAction)
			yield(device,"LineRead")
			
		Constants.Gui.FightAnimation.AnimCode.CONSOLE_READ_ALL:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE]
			device.callv("read_all",AnimAction)
			yield(device,"MessageRead")
			
		Constants.Gui.FightAnimation.AnimCode.CONSOLE_SUBMIT:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.CONSOLE]
			device.callv("submit",AnimAction)
		#----------------------------------------------------------------------------------------#
		#----------------------------------------------------------------------------------------#
		#----------------------------------------------------------------------------------------#
			
		Constants.Gui.FightAnimation.AnimCode.MAPGUI_APPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI]
			device.visible = true
		
		Constants.Gui.FightAnimation.AnimCode.MAPGUI_FROM_A_TO_B:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI]
			device.callv("FromAtoB",AnimAction)
		
		Constants.Gui.FightAnimation.AnimCode.MAPGUI_DISAPPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI]
			device.visible = false
			
		Constants.Gui.FightAnimation.AnimCode.MAPGUI_BLOCK_APPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI]
			device.callv("block_appear",AnimAction)
		Constants.Gui.FightAnimation.AnimCode.MAPGUI_BLOCK_DISAPPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.MAP_GUI]
			device.callv("block_disappear",AnimAction)
		#----------------------------------------------------------------------------------------#
		#----------------------------------------------------------------------------------------#
		#----------------------------------------------------------------------------------------#


			
		Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_SET_LEFT_RIGHT:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN]
			device.callv("set_left_right",AnimAction)
	
		Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_APPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN]
			device.visible = true
			
		Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_DISAPPEAR:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN]
			device.visible = false
			
		Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_LEFT_ANIM:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN]
			device.callv("left_anim",AnimAction)
			
		Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_RIGHT_ANIM:
			device = __type_to_AnimatorDevice[Constants.Gui.FightAnimation.DUEL_SCREEN]
			device.callv("right_anim",AnimAction)
