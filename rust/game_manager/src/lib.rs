use gdnative::prelude::*;

/*
/// everything that is on the map has this trait
///
/// means you can generate PlayOptions by interacting with this
pub trait Interactable {}*/

/// "live" thing interacting in the world
pub struct Entity {}
/// interactive object present on the map (interruptor, usable etc)
pub struct Object {}
/// movable or destructable (or interactable?) obstacle on the map
pub struct Obstacle {}

pub mod map {

    use crate::{Entity, Object, Obstacle};

    /// spatial representation of the world
    ///
    /// holds the information of :
    ///     how is the world
    ///     what is it made of
    ///     who is where
    pub struct Map {
        ///  position -> TerrainType
        terrain_map: todo!(),
        /// position -> who or what is there
        interactable_map: todo!(),
        //djikstra_map? en interne?
    }
    /// what each case of the world is made of
    pub enum TerrainType {
        Forest,
        Ground,
        Wall,
        Void,
        Water,
        Sky,
    }
    /// everything interactable that can be in the world
    pub enum Occupant {
        Vacant,
        Entity(Entity),
        Obstacle(Obstacle),
        Object(Object),
    }
}

pub mod GameLogic {
    /// Represents the options an entity can chose from for deciding what to do in the game
    ///
    /// generated at with
    ///     entity intern state
    ///     external context
    pub enum PlayOptions {
        Pass,
        Move(Vec<MoveInfo>),
        Attack(Vec<AttackInfo>),
        Object(Vec<ObjectInfo>),
        Spell(Vec<SpellInfo>),
    }

    /// representation of what an entity will achieve
    pub enum Action {
        Move(MoveInfo),
        Attack(AttackInfo),
        Object(ObjectInfo),
        Spell(SpellInfo),
    }

    /// representation of what an entity wants to do
    pub struct Intent {
        priority: f64,
        action: Action,
    }
    impl Intent {
        /// splits the intent into the more little Action and the rest of the intented action as an intent remainder
        pub fn poll_minimal_action(&self) -> (Intent, Action) {
            let minimal_action: Action = todo!();
            let intent_remainder: Intent = todo!();
            (intent_remainder, minimal_action)
        }
    }

    /// contains exhaustiv info about a movement
    pub struct MoveInfo {}
    /// contains exhaustiv info about an attack  
    pub struct AttackInfo {}
    /// contains exhaustiv info about an object use
    pub struct ObjectInfo {}
    /// contains exhaustiv info about a spell use
    pub struct SpellInfo {}

    /// you submit an intent
    ///
    /// it is being sorted by priority (if equality,, first arrived first served)
    ///
    /// then the intent is "resolved" : transformed into a real action with consequences in the world
    ///
    /// between theses steps, entities (and maybe elements of nature) watch your intents and submit their own intent as a reaction
    pub struct IntentSubmitter {
        queue: todo!(),
    }
    #[allow(unreachable_code)]
    impl IntentSubmitter {
        /// puts a new intent in the Queue, sorting it beforehand
        fn submit(&self, intent: Intent) {
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
}

pub mod Scheduler {}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
