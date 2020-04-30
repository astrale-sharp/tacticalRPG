extends Reference
class_name ITeams
"""
interface for groups of team
"""
var Teams : Array
func _init(Team_list):
	Teams = Team_list


func init_sort(actor1,actor2):
	if actor1.initiative > actor2.initiative: return true
	else: return false
	
func active_filter(actor):
	if actor.is_active(): return true
	else: return false

func filter(list : Array,_func : FuncRef):
	for elem in list:
		if not _func.call_func(elem):
			list.erase(elem)


func get_all_actors():
	var all_actors
	for eachTeam in Teams:
		for eachActor in eachTeam.actorList:
			all_actors.append(eachActor)
	return all_actors
	
	
func __poll_consecutive_actor_of_a_team(list : Array):
	var TheTeam
	var res := []
	TheTeam = list[0].Team
	for actor in list:
		if actor.Team != TheTeam:
			break
		res.append(actor)
	return res

func next_actor_list():
	var all_actors : Array = get_all_actors()
	#filter active
	filter(
		all_actors,\
		funcref(self,"active_filter")
		)
	#sort by init
	all_actors.sort_custom(self,"init_sort")
	#split by teams
	return __poll_consecutive_actor_of_a_team(all_actors)	
	
