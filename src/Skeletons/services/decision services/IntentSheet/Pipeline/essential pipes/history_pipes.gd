extends Pipe
"""
the FightActor knows whether its being attacked or attacking when he gives the pipe
he precise it in is_Attacking and the pipe deals with generic_history_updates
if the attack is succesful, update history

checkpipes,
	adjust the history of the FightActor according to the AR received
each concerned actor should put them on each pipeline,

"""

#these two resource are given by the actor about how its history should be updated according to the assault
#for now they are a bit pointless since history doesnt care how you get it but if i want, it will be really simple to implement
var is_Attacking : bool
var history : FightActorHistory


func _init() -> void:
	type = Type.CHECK

func _custom_history_update(AR,intent):
	"""
	overwrite me so i can do stuff with your history while in the pipeline
	"""
	
func pipe(AR,intent):
	#for the sake of a simplified prototype, instead of passing accurate data, it will be automatic, note that this is very ugly
	history.update_with_data(FightActorHistory.new().get_typical_updateData_onAttacklaunch() if is_Attacking else FightActorHistory.new().get_typical_updateData_onAttacktarget())
	return AR
