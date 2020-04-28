extends Reference
class_name FightInputHandler

"""
the connection between request of an input, the gui that gives the choice, the buffer in which the data is put

for each type, you must wire type -> [InterfaceDevice,Device]
"""
#might be needed
signal RequestedInput
signal DealedInput(ID)

var wireData = {}

func wire(type,interface_to_gui):
	wireData[type] = interface_to_gui
	
func _init():
	pass

func __OnInputHandled(ID):
	emit_signal("DealedInput",ID)
	
func __check_type_supported(type):
	if not type in wireData.keys():
		return FAILED
	return OK


func request_input(input_type, inputData, requester : FightInputRequester, requester_func = "DataReceived", ID=-1):
	"""
	input_type corresponds to a gui capable of retrieving a choice in InputData in a graphical way
	this func connect the choosing of the gui and the requester that wants the final choice
	
	
	#a more elegant implementation:
		requesterData contains requester and requester_func
		im a little worried that (requester_func = 'DataReceived') defines here the convention for the requester which is not its responsability so i made it a default meaning you can bring your own requester convention
		
	#so i guess requester kind of is an interface? im only learning about this stuff
	Im only the last gui request
	beware:
		to implement a queue of event request, you cant simply call me multiple times, you have to make a queue and make it wait between each inputs of a single gui is handled
		this is due to the static bind of ID in Interface.connect
		current problem : cant have multiple input_request for different gui at the same time and it should be possible
			it doesnt matter very much though 
		you may want to change that and give unique InputRequestID in the whole system
		to then implement the queue, on request_input, the interface store a queue for its gui
	"""
	if not __check_type_supported(input_type) == OK:
		push_error("submitted an unsupported type")
	#get interface and gui
	var InterfaceGUI : InputDevice = wireData[input_type] #func and test this line if problems
	#make the gui fill the DataBuffer
	InterfaceGUI.connect("DataRetrievingDone", self,"__OnInputHandled", [ID] ,CONNECT_ONESHOT)
	InterfaceGUI.connect("SendData", requester, requester_func, [] , CONNECT_ONESHOT)

