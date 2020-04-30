extends Condition

#should be overwritten to do what you want

func evaluate()->bool:
	var d #:ITeam = data
	return d.one_team_left()
