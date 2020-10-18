
use crate::{Entity, Object, Obstacle};
use fnv::FnvHashMap;
pub mod djikstra;
use djikstra::DjikstraMap;

pub struct Pos2D(f64,f64);
/// spatial representation of the world
///
/// holds the information of :
///     how is the world
///     what is it made of
///     who is where
pub struct Map {
    ///  position -> TerrainType
    terrain_map: DjikstraMap,
    /// position -> who or what is there
    /// used to complement djikstramap result for coherent result with entities present on the map
    interactable_map: FnvHashMap<Pos2D,TerrainType>,
    //djikstra_map? en interne?
}
/// what each case of the world is made of
#[derive(Eq,Hash,PartialEq)]
pub enum TerrainType {
    Forest,
    Ground,
    Wall,
    Void,
    Water,
    Sky,
    ByDefault,
}
/// everything interactable that can be in the world
pub enum Occupant {
    Vacant,
    Entity(Entity),
    Obstacle(Obstacle),
    Object(Object),
}
