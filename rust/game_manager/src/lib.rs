#![allow(dead_code,unused_imports)]
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

/// responsible for representing the world on a 2D grid
pub mod map;

/// holds method for turn_logic
pub mod turn_logic;

/// responsible for tracking time related events, every temporary states / spells/ effect etc
pub mod scheduler;

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
