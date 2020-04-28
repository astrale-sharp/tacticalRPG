extends Control
class_name InputDevice
"""
its the link between a gui interface capable of generating data and the code
details of the implementation about how you get data from your gui scene should go here (or by inherithing this class)
"""

signal DataRetrievingDone
signal SendData(Data)

var type
var input_device 


func gui_data_request(InputData):
	"""
	special device code that should trigger a data response in OnGuiResponse
	"""
	
	
func OnGuiResponse(OutputData):
	emit_signal("DataRetrievingDone")
	emit_signal("SendData",OutputData)
