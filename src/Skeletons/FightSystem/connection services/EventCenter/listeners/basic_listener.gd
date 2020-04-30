extends WatcherListener

"""
on alert, alertData is [intent]
	intentsheet.subscribe(intent)
"""

var intentsheet : IntentSheet
func _OnAlert(AlertData):
	intentsheet.submit(AlertData)
