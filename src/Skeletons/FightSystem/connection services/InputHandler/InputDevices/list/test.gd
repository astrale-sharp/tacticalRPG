extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('ready')
	$make_request.connect("button_down",$device_list,"gui_data_request",[["a first choice","a second choice","a third choice"]])
	$device_list.connect("SendData",$TextEdit,"set_text")
