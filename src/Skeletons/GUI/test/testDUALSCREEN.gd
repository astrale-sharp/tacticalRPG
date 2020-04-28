extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	$dualScreen.set_left_right($FightActor/DualScreenAvatar,$FightActor2/DualScreenAvatar)
	print("111")
	$dualScreen.left_anim("appear")
	yield(get_tree().create_timer(1.5),"timeout")
	
	$dualScreen.right_anim("appear")
