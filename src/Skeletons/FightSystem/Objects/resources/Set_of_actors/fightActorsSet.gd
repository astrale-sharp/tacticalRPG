extends Reference
class_name SetOfActors


#-----------------------#
#-----------------------#
var actors : Array
var is_AI = false
#-----------------------#
#------dependancy------#
var IA_choice_maker

func _init(_actors : Array) -> void:
    actors = _actors

func empty():
    return actors.empty()

func IA_choice()->FightActor:
    if not is_AI: printerr('actorset :cant IAchoice if Im not AI')
    var actor : FightActor = IA_choice_maker.make()
    return actor