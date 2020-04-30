extends AnimatorDevice
class_name DualScreenAnimator
"""
goal is
	I receive correct data
	I animate it correctly on a dualScreen device (the screen where you see two people being animated you know)
"""

var leftActor #have a anim_play func
var rightActor

func set_left_right(left,right):
	if left: 
		leftActor = left
		leftActor.rect_position = $left.position
	if right:
		rightActor = right
		rightActor.rect_position = $right.position
func left_anim(anim_name):
	leftActor.anim_play(anim_name)

func right_anim(anim_name):
	rightActor.anim_play(anim_name)
