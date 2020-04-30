extends Node

var animcenter

func suite_test_console():
	var test = [
		[
			Constants.Gui.FightAnimation.AnimCode.CONSOLE_APPEAR,
			
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.CONSOLE_SUBMIT,
			["je suis un cheval de troie", "lentement dans mon sang je me noie","blablablablablabliblablabla..."]
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.CONSOLE_READ_ONE
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.CONSOLE_READ_ALL
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.CONSOLE_DISAPPEAR,
		]
	]
	for animAction in test:
		animcenter.animate(animAction)
		yield(get_tree().create_timer(0.5),"timeout")
		print("actionDone")
		
func suite_test_map():
	var sprite := Sprite.new()
	sprite.texture = load("res://icon.png")
	add_child(sprite)
	
	var test = [
		[
			Constants.Gui.FightAnimation.AnimCode.MAPGUI_APPEAR
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.MAPGUI_BLOCK_APPEAR,
			[Vector2.ONE,Vector2(2,2),Vector2(3,3)]
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.MAPGUI_BLOCK_DISAPPEAR
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.MAPGUI_FROM_A_TO_B,
			sprite,
			Vector2.ZERO,
			Vector2.ONE*5
			
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.MAPGUI_BLOCK_DISAPPEAR
		],
	]
	for animAction in test:
		animcenter.animate(animAction)
		yield(get_tree().create_timer(1),"timeout")
		print("actionDone")
		
func suite_test_dual_screen():
	var test = [
		[
			Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_APPEAR
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_DISAPPEAR
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_SET_LEFT_RIGHT
		],
		
		[
			Constants.Gui.FightAnimation.AnimCode.DUALSCREEN_LEFT_ANIM
		],
		
	]
	for animAction in test:
		animcenter.animate(animAction)
		yield(get_tree().create_timer(1),"timeout")
		print("actionDone")

