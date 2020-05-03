extends Node
class_name FightActorHistory
"""
belong to a fightActor
responsability: data stock for a fight
and i mean data:
	goes in the history no conditional data, just pure data
	implies:
		no check or condition needed for updating history, its just flowing information nothing to worry about
		later, fightActor might need to think about this data to decide what are their possible intents
			for instance in a pipeDeciding if can strike back
for -the turn now playing
	-the all fight
	
implementation : has a lot of default things its recording, all enabled by default, to be changed if it causes memory problem
has a few custom memory costly thing someone_needs to deal
for instance when condition is met
	custom['cond has been met']=true

the fightActor each turn should
	flush thisturn history
	then flow initial values to it
"""

class BasicHistory:
	extends Resource
	
	class HistoryConstants:
		extends Reference
		enum EntryTypes {REGULAR,CUSTOM}
		enum {has_attacked_n_times, has_been_attacked_n_times }
		
	var custom = {}
	
	var MyEntries = {} # const -> an increasing number
	
	func __check_where_is_entry(entry):
		#assumes entry is not in multiple entry should be tested extensivly
		push_error("not implemented")
		
	func __entry_is_in(entry,entry_base):
		push_error("not implemented")
	
	func flush():
		"""empty history"""
		custom.clear()
		MyEntries.clear()
		
	func access_entry(entry, set_value = null):
		"""
		sets the entry to value or increment it by one
		"""
		if set_value: MyEntries[entry] = set_value
		else:
			MyEntries[entry] += 1 
	
	func has_entry(entry):
		return custom.has(entry) or MyEntries.has(entry)
	
	func where_entry(entry):
		if custom.has(entry): return custom
		if MyEntries.has(entry): return MyEntries

	func get_entry(entry):
		pass

	func custom_entry_set(entry,value=null):
		if value: custom[entry] = value
		else: custom[entry] += 1
		
	func custom_entry_get(entry):
		return custom[entry]

	func set_if_exists(entry,value=null):
		if has_entry(entry):
			if value: where_entry(entry)[entry] = value
			else: where_entry(entry)[entry] += 1

	func update(data):
		pass

class HistoryResource:
	extends Resource
	"""
	data container for setting/updating an history
	"""
	var ValuesData = {}# const -> value, sets 
	var IncrementData = [] #list of constants to be incremented in history if exists
	
	var custom = {} #custom key -> custom value (value null <==> increment)
	
	
	
func get_typical_updateData_onAttacklaunch():
	var C = BasicHistory.HistoryConstants
	var H = HistoryResource.new()
	H.IncrementData = [C.has_attacked_n_times]
	return H

func get_typical_updateData_onAttacktarget():
	var C = BasicHistory.HistoryConstants
	var H = HistoryResource.new()
	H.IncrementData = [C.has_been_attacked_n_times]
	return H
	
func get_typical_SetData():
	var C = BasicHistory.HistoryConstants
	var H = HistoryResource.new()
	H.ValuesData = {
		C.has_attacked_n_times : 0,
		C.has_been_attacked_n_times : 0
		}
	return H





var thisTurn = BasicHistory.new()
var thisFight = BasicHistory.new()

func flush_turn():
	thisTurn.flush()


func update_with_data(thisTurnData : HistoryResource,thisFightData : HistoryResource):
	"""
	"""
	print("history update is not implemented yet....")
	thisTurn.update(thisTurnData)
	thisFight.update(thisFightData)
