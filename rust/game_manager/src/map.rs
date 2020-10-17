
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
