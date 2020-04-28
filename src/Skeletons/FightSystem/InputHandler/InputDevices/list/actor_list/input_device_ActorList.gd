extends InputDevice

onready var menu : PopupMenu= $menu
var id_to_elem = {}

func gui_data_request(List : Array):
	"""
	special device code that should trigger a data response in OnGuiResponse
	"""
	id_to_elem.clear()
	menu.clear()
	var elem : FightActor
	for i in range(List.size()):
		elem = List[i]
		menu.add_check_item(elem.name,i)
		id_to_elem[i] = elem
	
	menu.popup_centered()

func OnGuiResponse(list_id):
	emit_signal("DataRetrievingDone")
	emit_signal("SendData",id_to_elem[list_id])
