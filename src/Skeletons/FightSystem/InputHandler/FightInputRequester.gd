extends Reference
class_name FightInputRequester
"""
its where the data is received and the buffer is filled with Data
	When an inputRequest has been fulfilled
"""
signal Received

var buffer

func DataReceived(Data):
	buffer = Data
	emit_signal("Received")
