extends AnimatorDevice
class_name Console
"""
is thrown list of text to be read
	and maybe implemented later, style that goes with those text that the console should be looking, for instants, constants allowing to switch between different existing style for console
reads them 'line by line' where a line is an elem of the array

ne supporte pas pour l'instant de recevoir plusieurs message à la fois
"""

var output : RichTextLabel

signal LineRead
signal MessageRead
signal InputContinueReceived

onready var tween := $Tween

var currentArray := []
var lecture_speed


func flush():
	currentArray = []

func submit(arr):
	currentArray = arr

func _OnInputReceived():
	emit_signal("InputContinueReceived")


func read_one(my_text):
	output.percent_visible = 0.0
	output.text = my_text
	tween.start()
	tween.interpolate_property(self,
					"percent_visible",
					0.0,
					1.0,
					len(output.text)/lecture_speed,
					Tween.TRANS_LINEAR,
					Tween.EASE_IN)
	yield(tween,"tween_completed")
	emit_signal("LineRead")


func read_all():
	"""
	write line by line on the console, pausing between each input OR for a time
	"""
	for elem in currentArray:
		yield(read_one(elem),"completed")#alternativly may work
#		yield(__read_one_line(),"LineRead")
		yield(self,"InputContinueReceived")
	emit_signal("MessageRead")
	
