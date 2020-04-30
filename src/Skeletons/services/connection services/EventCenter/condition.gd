extends Reference

class_name WatcherCondition

func _check(Action)->bool:
	"""
	should be overwritten to correspond to the check you want to trigger an event watcher when a certain action is submitted
	"""
	return false
