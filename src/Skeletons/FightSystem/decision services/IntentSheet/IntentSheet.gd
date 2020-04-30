extends Reference
class_name IntentSheet

"""
-someone wants to do something, it submits an intent here
-the intent will be check in due time (maybe someOne or someThing can act before it, this is handled in 'sorting the intent')
-if its not possible it will be ported to the world as a failure
	might be silent, 'Xavier couldnt hit cause he is dead' should be silent
	or verbose, 'Xavier couldnt hit cause its target is now to far away'
-otherwise its ported to the world, as a sucess with consequences (animated, should change history of actors concerned) but NONE OF THOSE IS RESPONSABILITY OF INTENT SHEET

-the way its read
	if there are still intent to deal with
	look at first one on the pile
		check if intent is applyable no?-> intent.failed(context) added to result (later result is ported to world, animation etc)
			yes?-> 
				if is assault
					calculate AR
					construct pipeline
					AR through pipeline #at this moment, actors will likely submit new intent to intentsheet, put them in submitted, in chronological order, in doubt, defensor should be handled first
					AR ported to world # the check pipes have informed the concerned Actors of their final behaviour
				else: usually just ported to world
				
	sort the submitted intent and deal with the next one
				
-'ported to world' means it goes through the watcher of event and then is animated to the screen
might have a stack of actions to be ported to world, and one by one ports them
!THIS IS NOT THE RESPONSABILITY OF THE INTENT SHEET, so intent sheet forwards actions to be ported somewhere, and something else deals with it thank you (no, you deal with this!)
HOWEVER
	move action should be communicated step by step to ensure event triggerring can happen before the move is over
	move.still_apply needs to check to move is still possible : case still directly reachable(you have not been moved),case non occupied, cost not to high
	
"""
signal PortThisToWorld(Action) 
		#this is sent to the event center, where triggers event signaled to concerned player
		#to the animation center where its animated and 
			#probably to theMap internDATA also?
		
	#connect to eventCenter to see if this actions trigger events listened by other characters
	#connect to animationCenter to show this action on the FightMap (animation etc)

signal IntentReadingDone

var GenericAssaultDealer : AssaultDealer #an object, purpose is to generate generic AR with an intent

var PipeLine : Pipeline#inject the pipeline dependancy here
var _Submitted_prio_is_first = []
var _SubmittedIntents = []
var _Submitted_prio_is_last = []
var _SortedStructure = {}#this is constructed and updated regularly so the func next_intent knows where to find the new intent
# dict intent.priority -> chronological list of intents, "first" is read first, "last is read last"

func submit(intent):
	_SubmittedIntents.append(intent)

var __next_intent_cursor #useful for erasing dealed intent

func next_intent():
	#REPLACE ME WITH TOP_INTENT
	"""
	returns the next intent that should be treated, null if there are none
	the suppression must be manual to able intent.poll which dosnt supress the intent but modify it a bit
	
	how? #foreach prio, check if empty, else return first elem
	"""
	
	if _Submitted_prio_is_first:
		__next_intent_cursor = _Submitted_prio_is_first
		return _Submitted_prio_is_first.front()
		
	for each_priority in _SortedStructure.keys(): #TODOcheck this goes from min to max
		if _SortedStructure[each_priority]:
			__next_intent_cursor = _Submitted_prio_is_first[each_priority]
			return _SortedStructure[each_priority].front()
	
	if _Submitted_prio_is_last:
		__next_intent_cursor = _Submitted_prio_is_last
		return _Submitted_prio_is_last.front()

func __erase_current_intent(intent):
	#TODO REPLACE ME WITH SUPPRESS TOP INTENT
	"""
	erase intent in the last list returned by next_intent
	"""
	__next_intent_cursor.erase(intent)

func sort_intent(intent):
	"""sorts the intent in SubmittedIntents to Sorted Structure"""
	
	if intent.priority == "first":
		_Submitted_prio_is_first.append(intent)
		return
	if intent.priority == "last":
		_Submitted_prio_is_last.append(intent)
		return
	if not _SortedStructure[intent.priority]: # pas encore de liste ici ou vide donc pas grave
		_SortedStructure[intent.priority] = [intent] #make a list
		return
	else:
		_SortedStructure[intent.priority].append(intent)
	
func sort_intents():
	for each_intent in _SubmittedIntents:
		sort_intent(each_intent)


func __deal_an_assault(my_next_intent):
		var AR = GenericAssaultDealer.deal(my_next_intent)#he needs assaultData (launcher+target) generic AR should be generated
		PipeLine.generate(my_next_intent)# pipeline needs context (launcher and target AssaultData)+FightSystem.AssaultCalculator where does it get it, possibly from the intent
		printerr("fix fightAction?")
#		var MyFightAction = FightAction.FightActionAttack.new(PipeLine.read(AR))
#		emit_signal("PortThisToWorld", MyFightAction) #PipeLine.conclude() return final AR



func read():
	#TODO test the intent arriving first are dealed first
	var my_next_intent = next_intent()
	while my_next_intent:
		if not my_next_intent.still_applies(): #note, intent needs context to decide that, where does the context come from?
			__erase_current_intent(my_next_intent) #intent failed, can be erased
			emit_signal("PortThisToWorld",my_next_intent.fails())
		else:
			#this should be an interface Iintent
				#such Iintent would be like Iintent.resolve(intent)
				#	assaultIntent -> it deals an assault returning an action that is ported to world
				#   moveIntent    -> polls at max while curr_intent == top_intent
					#when poll no more possible, port action to world
				#in each case, intent is supressed automatic, its just that a new one with same priority is submitted if need meaning if couldnt poll to the end
			if my_next_intent.is_assault:
				__erase_current_intent(my_next_intent) #intent done, can be erased
				__deal_an_assault(my_next_intent)
			else: #moving or castingSpell(not implemented)
				#Here, for moving, we should consider each step of the movement beeing a success and ported to world until the move is over OR an event was trigger and the move should be resumed later OR not resume and the movePoints are conserved and the gui is later given back to the FightActor its the turn
				#you should poll until something new arrive
				emit_signal("PortThisToWorld",my_next_intent.poll()) #in case of a movementFightAction, generate a small action corresponding of a step in right direction
			
		my_next_intent = next_intent()
		
	emit_signal("IntentReadingDone")
