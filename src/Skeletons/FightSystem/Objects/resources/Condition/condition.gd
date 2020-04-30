extends Reference
class_name Condition

#should be overwritten to do what you want
var data
func _init(Data):
	data = Data

func evaluate()->bool:
	print("you should overwrite condition")
	return false
