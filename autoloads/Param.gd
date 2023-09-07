# Physics Paramaters
extends Node


const FRICTION : float = 0.3
const GRAVITY : float = 350.0
const GRAVITY_ON_FALL : float = 450.0

const WATER_FRICTION : float = 0.1
const WATER_GRAVITY : float = 300.0
const WATER_GRAVITY_ON_FALL : float = 400.0


const LEVEL_MAP: Dictionary = {
	"res://levels_and_level_objects/level_scenes/world_1_levels/1-1.tscn": "res://levels_and_level_objects/map/map_world_1.tscn",
	"res://levels_and_level_objects/level_scenes/world_1_levels/1-2.tscn": "res://levels_and_level_objects/map/map_world_1.tscn",
	"res://levels_and_level_objects/level_scenes/world_1_levels/1-3.tscn": "res://levels_and_level_objects/map/map_world_1.tscn",
	"res://levels_and_level_objects/level_scenes/world_1_levels/1-4.tscn": "res://levels_and_level_objects/map/map_world_1.tscn",
	"res://levels_and_level_objects/level_scenes/world_2_levels/2-1.tscn": "res://levels_and_level_objects/map/map_world_2.tscn",
	"res://levels_and_level_objects/level_scenes/world_2_levels/2-2.tscn": "res://levels_and_level_objects/map/map_world_2.tscn",
	"res://levels_and_level_objects/level_scenes/world_2_levels/2-3.tscn": "res://levels_and_level_objects/map/map_world_2.tscn",
	"res://levels_and_level_objects/level_scenes/world_2_levels/2-4.tscn": "res://levels_and_level_objects/map/map_world_2.tscn",
	"res://levels_and_level_objects/level_scenes/world_3_levels/3-1.tscn": "res://levels_and_level_objects/map/map_world_3.tscn",
	"res://levels_and_level_objects/level_scenes/world_3_levels/3-2.tscn": "res://levels_and_level_objects/map/map_world_3.tscn",
	"res://levels_and_level_objects/level_scenes/world_3_levels/3-3.tscn": "res://levels_and_level_objects/map/map_world_3.tscn",
	"res://levels_and_level_objects/level_scenes/world_3_levels/3-4.tscn": "res://levels_and_level_objects/map/map_world_3.tscn",
	"res://levels_and_level_objects/level_scenes/world_4_levels/4-1.tscn": "res://levels_and_level_objects/map/map_world_4.tscn",
	"res://levels_and_level_objects/level_scenes/world_4_levels/4-2.tscn": "res://levels_and_level_objects/map/map_world_4.tscn",
	"res://levels_and_level_objects/level_scenes/world_4_levels/4-3.tscn": "res://levels_and_level_objects/map/map_world_4.tscn",
	"res://levels_and_level_objects/level_scenes/world_4_levels/4-4.tscn": "res://levels_and_level_objects/map/map_world_4.tscn",
	"res://levels_and_level_objects/level_scenes/world_5_levels/5-1.tscn": "res://levels_and_level_objects/map/map_world_5.tscn",
	"res://levels_and_level_objects/level_scenes/world_5_levels/5-2.tscn": "res://levels_and_level_objects/map/map_world_5.tscn",
	"res://levels_and_level_objects/level_scenes/world_5_levels/5-3.tscn": "res://levels_and_level_objects/map/map_world_5.tscn",
	"res://levels_and_level_objects/level_scenes/world_5_levels/5-4.tscn": "res://levels_and_level_objects/map/map_world_5.tscn",
	"res://levels_and_level_objects/level_scenes/world_6_levels/6-1.tscn": "res://levels_and_level_objects/map/map_world_6.tscn",
	"res://levels_and_level_objects/level_scenes/world_6_levels/6-2.tscn": "res://levels_and_level_objects/map/map_world_6.tscn",
	"res://levels_and_level_objects/level_scenes/world_6_levels/6-3.tscn": "res://levels_and_level_objects/map/map_world_6.tscn",
	"res://levels_and_level_objects/level_scenes/world_6_levels/6-4.tscn": "res://levels_and_level_objects/map/map_world_6.tscn",
	"res://levels_and_level_objects/level_scenes/world_7_levels/7-1.tscn": "res://levels_and_level_objects/map/map_world_7.tscn",
	"res://levels_and_level_objects/level_scenes/world_7_levels/7-2.tscn": "res://levels_and_level_objects/map/map_world_7.tscn",
	"res://levels_and_level_objects/level_scenes/world_7_levels/7-3.tscn": "res://levels_and_level_objects/map/map_world_7.tscn",
	"res://levels_and_level_objects/level_scenes/world_7_levels/7-4.tscn": "res://levels_and_level_objects/map/map_world_7.tscn",
	"res://levels_and_level_objects/level_scenes/world_8_levels/8-1.tscn": "res://levels_and_level_objects/map/map_world_8.tscn",
	"res://levels_and_level_objects/level_scenes/world_8_levels/8-2.tscn": "res://levels_and_level_objects/map/map_world_8.tscn",
	"res://levels_and_level_objects/level_scenes/world_8_levels/8-3.tscn": "res://levels_and_level_objects/map/map_world_8.tscn",
	"res://levels_and_level_objects/level_scenes/world_8_levels/8-4.tscn": "res://levels_and_level_objects/map/map_world_8.tscn",
}
