extends Node2D

class Gui:
	extends Node2D
	const console_lecture_speed = 10
	class Inputs:
		extends Node2D
		const console_next = [KEY_SPACE,KEY_ENTER]
	
	class FightAnimation:
		extends Reference
		enum {CONSOLE,MAP_GUI,DUEL_SCREEN}
		enum AnimCode \
		{
			CONSOLE_APPEAR,
			CONSOLE_DISAPPEAR,
			CONSOLE_READ_ONE,
			CONSOLE_READ_ALL,
			CONSOLE_SUBMIT,
			
			MAPGUI_APPEAR,
			MAPGUI_DISAPPEAR,
			MAPGUI_BLOCK_APPEAR,
			MAPGUI_BLOCK_DISAPPEAR,
			MAPGUI_FROM_A_TO_B,
			
			DUALSCREEN_SET_LEFT_RIGHT,
			DUALSCREEN_APPEAR,
			DUALSCREEN_DISAPPEAR,
			DUALSCREEN_LEFT_ANIM,
			DUALSCREEN_RIGHT_ANIM,
			
		}
	
	
class FightSystemConstants:
	extends Node2D
	
	class Inputs:
		extends Node2D
		enum Choices {MOVE,ATTACK,CANCEL,SPELL,ITEM,PASS}
		enum Types {choice_in_list,bool_choice,map_choice,item_choice,spell_choice,choice_in_actor_list}
	
	class Modifier:
		extends Node2D
		const type_modifier = 0.5 #for type related damage 1 + modifier
		func type_weak_against(t1,t2):
			"""
			returns true if t1 weak against t2
			#pipe using this should update in fonction of the type modifier and send a message in AR.portToWorldString about efficiency
			"""
			if t2 in FightSystemConstants.FightActorConstants.__weak_against[t1]:
				return true
			return false
			
		func type_strong_against(t1,t2):
			"returns true if t1 strong against t2"
			if t2 in FightSystemConstants.FightActorConstants.__strong_against [t1]:
				return true
			return false
		
	class FightActorConstants:
		extends Reference
		enum Characteristics {Force, Precision, Resitance, Initiative}
		enum AttackType {cinglant, contondant, estoc, magic}
		enum DefenceType {naked, plate, maille, magic}
		const __weak_against = {
					AttackType.cinglant : 
										[
											DefenceType.maille,
											DefenceType.plate
										] ,
					AttackType.contondant : [DefenceType.maille],
					AttackType.estoc : [DefenceType.plate],
					AttackType.magic : []
					}
								
		const __strong_against = {
					AttackType.cinglant : [DefenceType.naked],
					AttackType.estoc : [DefenceType.maille],
					AttackType.contondant : [DefenceType.plate],
					AttackType.magic : []
			
		}
		class ActionConstant:
			extends Reference
			enum Type {attack,attackFails,move,complex,cast_spell}
			
		class AssaultConstant:
			extends Reference
			enum Attack {Type,}
			enum Defence {Type,}
			enum Result {damage}
