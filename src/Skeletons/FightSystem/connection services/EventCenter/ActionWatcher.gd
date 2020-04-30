extends Reference
class_name ActionWatcher

"""
should be given unique ID per FightActor
	meaning a same fightActor cant provide twice the same ID
	but different FightActor is okay
"""

var ID
var condition : WatcherCondition

signal Alert

func watch(Action):
	if condition.check(Action):
		emit_signal("Alert") #only the subscriber is listening to this and the way its binded should give data at that moment for the subscriber to decide what to do
