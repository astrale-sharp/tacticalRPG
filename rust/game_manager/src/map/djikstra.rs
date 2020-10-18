use super::TerrainType;
use fnv::FnvHashMap;
use fnv::FnvHashSet;
use std::ops::{Add, Mul};

pub mod getters;
pub mod setters;

#[derive(PartialOrd, Copy, Clone, PartialEq)]
pub struct Weight(f32);

pub mod ops {
    use super::*;
    impl Mul<Weight> for Weight {
        type Output = Weight;
        fn mul(self, rhs: Self) -> Self::Output {
            let (Weight(x), Weight(y)) = (self, rhs);
            Weight(x * y)
        }
    }

    impl Mul<Cost> for Weight {
        type Output = Cost;
        fn mul(self, rhs: Self::Output) -> Self::Output {
            let (Cost(x), Weight(y)) = (rhs, self);
            Cost(x * y)
        }
    }

    impl Mul<Cost> for Cost {
        type Output = Cost;
        fn mul(self, rhs: Self::Output) -> Self::Output {
            let (Cost(x), Cost(y)) = (rhs, self);
            Cost(x * y)
        }
    }

    impl Mul<Weight> for Cost {
        type Output = Cost;
        fn mul(self, rhs: Weight) -> Self::Output {
            let (Cost(x), Weight(y)) = (self, rhs);
            Cost(x * y)
        }
    }

    impl Add<Cost> for Weight {
        type Output = Cost;
        fn add(self, rhs: Self::Output) -> Self::Output {
            let (Cost(x), Weight(y)) = (rhs, self);
            Cost(x + y)
        }
    }
    impl Add<Weight> for Weight {
        type Output = Weight;
        fn add(self, rhs: Self::Output) -> Self::Output {
            let (Weight(x), Weight(y)) = (rhs, self);
            Weight(x + y)
        }
    }
    impl Add<Cost> for Cost {
        type Output = Cost;
        fn add(self, rhs: Self::Output) -> Self::Output {
            let (Cost(x), Cost(y)) = (rhs, self);
            Cost(x + y)
        }
    }
    impl Add<Weight> for Cost {
        type Output = Cost;
        fn add(self, rhs: Weight) -> Self::Output {
            let (Cost(x), Weight(y)) = (self,rhs);
            Cost(x + y)
        }
    }
}
#[derive(PartialEq, PartialOrd,Ord, Copy, Clone, Eq, Hash)]
pub struct PointID(i32);

#[derive(PartialOrd, Copy, Clone, PartialEq)]
pub struct Cost(f32);

impl Default for Cost {
    fn default() -> Self {
        Cost(1.0f32)
    }
}

enum GridType {
    SQUARE,
    HEX,
}

pub struct DjikstraMap {
    connections: FnvHashMap<PointID, FnvHashMap<PointID, Weight>>, //for point1 stores weights of connections going from point1 to point2
    reverse_connections: FnvHashMap<PointID, FnvHashMap<PointID, Weight>>, //for point1 stores weights of connections going from point2 to point1
    cost_map: FnvHashMap<PointID, Cost>,
    direction_map: FnvHashMap<PointID, Option<PointID>>,
    sorted_points: Vec<PointID>,
    disabled_points: FnvHashSet<PointID>,
    terrain_map: FnvHashMap<PointID, TerrainType>,
}

impl DjikstraMap {
    ///Recalculates cost map and direction map information fo each point, overriding previous results.  
    ///First argument is ID of the origin point or array of IDs (preferably `PoolIntArray`).
    ///Second argument is a `Dictionary`, specifying optional arguments.Possibilities:
    /// * `"input is destination"`->`bool`:
    /// if true treats the origin as the destination (matters only if connections are not bidirectionally symmetric). Default value: `false`
    /// * `"maximum cost"`->`float`:
    /// Specifies maximum cost. Once all shortest paths no longer than maximum cost are found, algorithm terminates.
    /// All points with cost bigger than this are treated as inaccessible. Default value: `INFINITY`
    /// * `"initial costs"`->`PoolRealArray` or `Array`:
    /// Specifies initial costs for given origins. Values are paired with corresponding indices in the origin argument.
    /// Can be used to weigh the origins with a preference. By default, initial cost is `0.0`.
    /// * `"terrain weights"`->`Dictionary`:
    /// Specifies weights for terrain types. Keys are terrain type IDs  and values weights as floats.
    /// Unspecified values are assumed to be `1.0` by default.
    pub fn recalculate(
        &mut self,
        origins: Vec<PointID>,
        reverse: Option<bool>,
        max_cost: Option<Cost>,
        initial_costs: Option<Vec<Cost>>,
        terrain_weights: Option<FnvHashMap<TerrainType, Weight>>,
        termination_points: Option<FnvHashSet<PointID>>,
    ) {
        let reverse: bool = reverse.unwrap_or(false);
        let max_cost = max_cost.unwrap_or(Cost(std::f32::INFINITY));
        let initial_costs: Vec<Cost> = initial_costs.unwrap_or(Vec::<Cost>::new());
        let mut terrain_weights =
            terrain_weights.unwrap_or(FnvHashMap::<TerrainType, Weight>::default());
        let mut termination_points = termination_points.unwrap_or(FnvHashSet::<PointID>::default());
        self.recalculate_map_intern2(
            &origins,
            Some(&initial_costs),
            max_cost,
            reverse,
            &terrain_weights,
            Some(&termination_points),
        );
    }
    //functions for acccessing results

    ///returns `PoolIntArray` of point IDs corresponding to a shortest path from given point (note: given point isn't included).
    ///If point is a target or is inaccessible, returns empty array.
    pub fn get_shortest_path_from_point(&mut self, point: PointID) -> Vec<PointID> {
        let mut current_point = point;
        let mut path: Vec<PointID> = Vec::new();
        let mut next_point: Option<PointID> = self.get_direction_at_point(point);
        while Some(current_point) != next_point && next_point.is_some() {
            current_point = next_point.unwrap();
            path.push(current_point);
            next_point = self.get_direction_at_point(current_point);
        }
        path
    }

    fn cost_of(&self, point: PointID) -> Cost {
        *self
            .cost_map
            .get(&point)
            .unwrap_or(&Cost(std::f32::INFINITY))
    }
    //actually recalculates the DijkstraMap
    fn recalculate_map_intern2(
        &mut self,
        open_set: &Vec<PointID>,
        initial_costs: Option<&Vec<Cost>>,
        max_cost: Cost,
        reversed: bool,
        terrain_costs: &FnvHashMap<TerrainType, Weight>,
        termination_points: Option<&FnvHashSet<PointID>>,
    ) {
        //switches direction of connections
        let connections = if reversed {
            &self.reverse_connections
        } else {
            &self.connections
        };
        #[derive(Copy, Clone, PartialEq)]
        struct QueuePriority {
            id: PointID,
            cost: Cost,
        }
        impl Ord for QueuePriority {
            fn cmp(&self, other: &QueuePriority) -> std::cmp::Ordering {
                other
                    .cost
                    .partial_cmp(&self.cost)
                    .unwrap_or(std::cmp::Ordering::Equal)
                    .then_with(|| other.id.cmp(&self.id))
            }
        }
        impl PartialOrd for QueuePriority {
            fn partial_cmp(&self, other: &QueuePriority) -> Option<std::cmp::Ordering> {
                Some(self.cmp(other))
            }
        }
        impl Eq for QueuePriority {}

        //initialize containers
        self.cost_map.clear();
        self.direction_map.clear();
        self.sorted_points.clear();
        let capacity = std::cmp::max(
            (f32::sqrt(self.connections.len() as f32) as usize) * 6,
            open_set.len(),
        );
        let mut open_queue =
            priority_queue::PriorityQueue::<PointID, QueuePriority>::with_capacity(capacity);
        //add targets to open_queue
        for (src, i) in open_set.iter().zip(0..) {
            if connections.get(src).is_some() {
                self.direction_map.insert(*src, Some(*src));
                self.cost_map.insert(
                    *src,
                    match initial_costs {
                        None => Cost(0.0),
                        Some(t) => *t.get(i).unwrap_or(&Cost(0.0)),
                    },
                );
                open_queue.push(
                    *src,
                    QueuePriority {
                        id: *src,
                        cost: self.cost_of(*src),
                    },
                );
            }
        }
        let mut c = connections.len() as i32;
        //iterrate over open_set
        while !open_queue.is_empty() && c >= 0 {
            c -= 1;
            let (point1, _) = open_queue.pop().unwrap();
            self.sorted_points.push(point1);
            if termination_points.is_some() && termination_points.unwrap().contains(&point1) {
                break;
            }
            let point1_cost = self.cost_of(point1);
            let weight_of_point1 = terrain_costs
                .get(
                    &self
                        .terrain_map
                        .get(&point1)
                        .unwrap_or(&TerrainType::ByDefault),
                )
                .unwrap_or(&Weight(1.0));
            //iterrate over it's neighbours
            for (&point2, &dir_cost) in connections.get(&point1).unwrap().iter() {
                let cost: Cost = point1_cost
                    + dir_cost
                        * Weight(0.5)
                        * (*weight_of_point1
                            + *terrain_costs
                                .get(
                                    &self
                                        .terrain_map
                                        .get(&point2)
                                        .unwrap_or(&TerrainType::ByDefault),
                                )
                                .unwrap_or(&Weight(1.0)));
                //add to the open set (or update values if already present)
                //if point is enabled and new cost is better than old one, but not bigger than maximum cost
                if cost < self.cost_of(point2)
                    && cost <= max_cost
                    && !self.disabled_points.contains(&point2)
                {
                    open_queue.push_increase(
                        point2,
                        QueuePriority {
                            id: point2,
                            cost,
                        },
                    );
                    self.direction_map.insert(point2, Some(point1));
                    self.cost_map.insert(point2, cost);
                }
            }
        }
    }}
