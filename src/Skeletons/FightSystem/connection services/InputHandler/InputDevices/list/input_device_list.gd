extends InputDevice

onready var menu : PopupMenu= $menu
var id_to_elem = {}
var sending := true

func gui_data_request(List : Array):
	"""
	special device code that should trigger a data response in OnGuiResponse
	"""
	id_to_elem.clear()
	menu.clear()
	sending = true
	var elem 
	for i in range(List.size()):
		elem = List[i]
		menu.add_check_item(elem,i)
		id_to_elem[i] = elem
	
	menu.popup_centered()

func OnCancel():
	if not sending: return
	emit_signal("DataRetrievingDone")
	emit_signal("SendData",Constants.FightSystemConstants.Inputs.Choices.CANCEL)
	sending = false
	
func OnGuiResponse(list_id):
	sending = false
	emit_signal("DataRetrievingDone")
	emit_signal("SendData",id_to_elem[list_id])

