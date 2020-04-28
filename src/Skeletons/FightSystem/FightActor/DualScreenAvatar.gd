extends TextureRect


onready var animP = $AnimationPlayer

func anim_play(anim):
	animP.play(anim)
