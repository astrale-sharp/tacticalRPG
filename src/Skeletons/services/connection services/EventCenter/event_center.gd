extends Reference
class_name EventCenter
"""
responsability:
	this center receive all the actions that are happening to the world
	it must signal to those who subscribed event when those event occurs according to the actions arriving

its important that subscriber unsuscribe when they dont listen to the event no more
	for memory problems, anyway this should be fine for a reduce number of fight actors
current implementation:
	subscriber subscribe a list of ActionWatcher that are called on each action
possible better implementation:
	subscriber subscribe for each type of action, a list of actionWatcher etc
possible even better implementation (but crap as hell to write):
	ActionWatcher are merged as much as possible, to avoid having to check a lot of them, this would be hard to do but not technicly impossoble or worth it

note MapInternData has watchers:
	SomeOne dies -> its case is freed
	SoneOne moves -> update cases accordingly
"""
func _init():
	pass

var Subscribers_to = {}

"""
sub1 -> [watcher1,watcher2,...]
sub2 -> .....
"""

func subscribe(subscriber : WatcherSubscriber, actionWatcher :ActionWatcher,listener : WatcherListener,AlertData):
	"""
	should be called by fightActor wishing to watch an action and possibly submit an intent to intentsheet if the action occur
	
	get added to subscriber if not in here
	Watcher get appended 
	"""
	actionWatcher.connect("Alert",listener,"_OnAlert",[AlertData])
	if Subscribers_to.has(subscriber):
		Subscribers_to[subscriber].append(actionWatcher)
	else:
		Subscribers_to[subscriber] = [actionWatcher]


func unsubscribe_a_watcher(subscriber, watcherID):
	for watcher in Subscribers_to[subscriber]:
		if watcher.ID == watcherID:
			Subscribers_to[subscriber].erase(watcher)
			return

func unsubscribe_a_subscriber(subscriber):
	Subscribers_to[subscriber] = []


func _onActionDone(Action):
	for watcherList in Subscribers_to.values():
		for watcher in watcherList:
			watcher.watch(Action) #watcher determine if it should warn its subscriber, if so it does, by himself
