extends "res://addons/gut/test.gd"

func test_basicCalculator():
	
	var E = Example_Assault
	var F = Assault
	var calculator = E.ExampleCalculator.new()
	var att = F.AttackData.new()
	var def = F.DefenceData.new()
	var AR = F.AssaultResult.new()
	
	att.property["force"] = 50
	att.property["precision"] = 100
	att.property["crit"] = false
	
	def.property["resistance"] = 50
	def.property["escape"] = 0
	AR = calculator.calculate(att,def)
	assert_eq(AR.property["damage"],1,"calcul is exact")
	assert_eq(AR.property["escaped"],false,"shouldnt escape")
	
	att.property["crit"] = true
	AR = calculator.calculate(att,def)
	assert_eq(AR.property["damage"],1.5,"factor crit is 1.5")
	assert_eq(AR.property["escaped"],false,"shouldnt escape")
	assert_eq(AR.property["crit"],true,"should crit")
	
	
	
	att.property["force"] = 50
	att.property["precision"] = 0
	att.property["crit"] = false
	
	def.property["resistance"] = 50
	def.property["escape"] = 100
	AR = calculator.calculate(att,def)
	assert_eq(AR.property["damage"],0,"0 dg when escaped")
	assert_eq(AR.property["escaped"],true,"escaped")
	


#func test_():
#	pending()
