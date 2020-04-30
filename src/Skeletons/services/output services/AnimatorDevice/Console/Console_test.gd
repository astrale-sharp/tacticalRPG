extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Console.lecture_speed = Constants.Gui.console_lecture_speed
	$twrow_text.connect("button_down",$Console,"throw",[["le temps est bon...","le ciel est bleu...","j'ai deux amants qui sont aussi mes amoureux."]])
	$force_next.connect("button_down",$Console,"_OnInputReceived")
	$flush.connect("button_down",$Console,"flush")
	$read.connect("button_down",$Console,"read")
	
	$twrow_text.emit_signal("button_down")
	$read.emit_signal("button_down")
	set_process(true)

func _process(delta):
	pass
	var text = str( $Console.currentArray )
	$TextEdit.text = text
