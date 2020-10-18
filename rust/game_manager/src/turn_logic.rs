/// Represents the options an entity can chose from for deciding what to do in the game
///
/// generated at with
///     entity intern state
///     external context

/// contains exhaustive info about a movement
#[derive(Clone)]
pub struct MoveInfo {}
/// contains exhaustive info about an attack  
#[derive(Clone)]
pub struct AttackInfo {}
/// contains exhaustive info about an object use
#[derive(Clone)]
pub struct ObjectInfo {}
/// contains exhaustive info about a spell use
#[derive(Clone)]
pub struct SpellInfo {}

impl MoveInfo {
    fn next_step(&self) {
        todo!()
    }
}

pub enum PlayOptions {
    Pass,
    Move(Vec<MoveInfo>),
    Attack(Vec<AttackInfo>),
    Object(Vec<ObjectInfo>),
    Spell(Vec<SpellInfo>),
}

/// representation of what an entity will achieve

#[derive(Clone)]
pub enum Action {
    Move(MoveInfo),
    Attack(AttackInfo),
    Object(ObjectInfo),
    Spell(SpellInfo),
}
impl Action {
    fn minimal_action(&self) -> Self {
        use Action::*;
        match self {
            Move(MoveInfo) => {
                // one step on map
                todo!()
            }
            // Action if feature combo implemented
            x => x.clone(),
        }
    }
}

/// representation of what an entity wants to do
pub struct Intent {
    priority: f64,
    action: Action,
}

impl Intent {
    fn minimal_intent(&self) -> Self {
        Intent {
            priority: self.priority,
            action: self.action.minimal_action(),
        }
    }
}

impl Intent {
    /// splits the intent into the more little Action and the rest of the intented action as an intent remainder
    pub fn poll_minimal_action(&self) -> (Intent, Action) {
        let minimal_action: Action = self.action.minimal_action();
        let intent_remainder: Intent = todo!();
        (intent_remainder, minimal_action)
    }
}

/// you submit an intent
///
/// it is being sorted by priority (if equality,, first arrived first served)
///
/// then the intent is "resolved" : transformed into a real action with consequences in the world
///
/// between theses steps, entities (and maybe elements of nature) watch your intents and submit their own intent as a reaction
pub struct IntentSubmitter {
    queue: Vec<Intent>,
}
#[allow(unreachable_code)]
impl IntentSubmitter {
    /// puts a new intent in the Queue, sorting it beforehand
    pub fn submit(&self, intent: Intent) {
        // sort this new intent in the queue
        todo!()
    }

    /// declares your intent bit by bit transforming it into an action
    /// until the intent is epuised
    /// or a higher priority takes its place
    /// when that happens,
    ///     puts back the rest of intent in the queue
    ///     return the contigeous action
    fn try_resolve_top_intent(&self) -> Result<Action, ()> {
        let top_intent: Intent = todo!(); //pop the head of the queue
                                          // is top intent still faisable?

        // declare to IntentWatcher top intent

        // still is top intent?
        let top_intent_unchanged: bool = todo!();

        if top_intent_unchanged {
            let (intent, minimal_action) = top_intent.poll_minimal_action();
            // submit new intent at TOP of queue
            todo!();
            Ok(minimal_action)
        } else {
            Err(())
        }
    }
}
