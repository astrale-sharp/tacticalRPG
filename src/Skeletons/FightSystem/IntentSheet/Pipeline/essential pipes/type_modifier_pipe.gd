extends Pipe
"""
prototype
	modif the damage according to weakness
"""
func _init():
	type = Type.STATE_UPDATE
	place = Place.MIDDLE

func pipe(AR, OriginalIntent):
	var modifier = 1
#	if 
	AR.property[AssaultConstants.Result.damage]
	return AR
