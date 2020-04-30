extends Reference
class_name WatcherSubscriber

"""
the representation of a fightActor view by the event_center
"""

var currentID := 0

func __give_uniq_ID():
	currentID += 1
	return currentID
