extends Reference
class_name Example_Assault
"""
a first calculator idea
	attack must have force (for damage) in 0,100 , precision (for if you hit) in 0 10, critic : bool , critic modifier > 1
	defence must have resistance in 1 ,100 , escape in 0 10 
	
calcul is dg = 0 if escape > precision else force/resitance * critmodif if crit
return Ar.dg Ar.escaped true if escape > precision
"""



class ExampleCalculator:
	extends "res://src/Skeletons/FightSystem/Assault/Assault.gd".AssaultCalculator

	func calculate(launch : Assault.AttackData ,target : Assault.DefenceData ):
		var effect = Assault.AssaultResult.new()
			
		var dg
		effect.property["escaped"] = false
		effect.property["crit"] = false
		
		if launch.property["precision"] < target.property["escape"]:
			dg = 0
			effect.property["escaped"] = true
		else:
			dg = launch.property.force/target.property.resistance
			if launch.property["crit"]:
				effect.property["crit"] = true
				dg *= 1.5
				
		effect.property["damage"] = dg
		
		return effect

