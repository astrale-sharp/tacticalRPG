extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var guimap = preload("res://src/Skeletons/FightSystem/AnimationCenter/FightMapDisplay/AnimatorDevice/GUIMapAnimator/GuiMap.tscn")
# Called when the node enters the scene tree for the first time.
var mygui
func _ready() -> void:
	mygui = guimap.instance()
	add_child(mygui)
	yield(get_tree().create_timer(0.5),"timeout")
	mygui.block_appear([Vector2.ONE])
	yield(get_tree().create_timer(0.5),"timeout")
	mygui.block_appear([Vector2.ONE + Vector2.RIGHT,Vector2.ONE + Vector2.LEFT,
						Vector2.ONE*2, Vector2.RIGHT,Vector2.LEFT,
						Vector2.ZERO,Vector2.UP,Vector2.ONE*2,Vector2.ONE*3
						,Vector2(1,2)
						]
						)
