extends "res://addons/gut/test.gd"

class TestCalculators:
	extends "res://addons/gut/test.gd"
	func test_BaseCalculator():
		var calculator = load("res://src/GameArchitec/CoreGameplay/LivingEntity/Fight/Calculators/BaseCalcul.gd").new()
		var Att = attackState.new()
		var Def = defenceState.new()
		Att.AttackScore = 1
		Att.damage = 10
		Att.crit = false
		
		Def.DefenceScore = 1
		Def.miss = false
		var effect : AttackEffect= calculator.calculate(Att,Def)
		assert_eq(10,effect.damage,"no modifier, same damege")
		assert_eq(effect.state,effect.STATE.OK,"base state is ok")
		
		Att.crit = true
		var effect2 : AttackEffect= calculator.calculate(Att,Def)
		assert_gt(effect2.damage,effect.damage,"crit should deal more damage")
		
		Att.crit = false
		Att.AttackScore = 10
		var effect4 : AttackEffect= calculator.calculate(Att,Def)
		assert_gt(effect4.damage,effect.damage,"crit should deal more damage")
		
		Def.miss = true
		var effect3 : AttackEffect= calculator.calculate(Att,Def)
		assert_eq(effect3.state,AttackEffect.STATE.MISSED,"state should have changed ")