package game

import rl "vendor:raylib"
import "core:fmt"

Game_State :: struct {
	want_to_quit : bool,
	initialized: bool,
	entities: [MAX_ENTITIES]Entity,
	entity_id_gen: u64,
	entity_top_count: u64,
	world_name: string,
	player_handle: Entity_Handle,

	transitionning : bool,
	time_transition : f32,
	transition_done : bool,

	current_door : ^Entity,
}

Entity :: struct {
	allocated: bool,
	handle: Entity_Handle,
	kind: Entity_Kind,

	position : rl.Vector2,
	cell_x : int,
	cell_y : int,
	sprite_size: f32,
	collision_size: f32,
	is_trigger : bool,
	color : rl.Color,

	//characters
	speed : f32,
	sprite : rl.Texture2D,
	sprite_idle : []Anim_Frame,
	sprite_walk : []Anim_Frame,
	sprite_walk_top : []Anim_Frame,
	sprite_walk_left : []Anim_Frame,
	sprite_walk_right : []Anim_Frame,
	sprite_walk_current : []Anim_Frame,
	anim_frame : int,
	anim_time : f32,
	is_idle : bool,
	direction : Direction,

	//door
	target_x : f32,
	target_y : f32,

	update : proc(^Entity),
	on_trigger_enter : proc(self : ^Entity, entity_touching: ^Entity),
	draw: proc(^Entity),
}

Entity_Handle :: struct {
	index: u64,
	id: u64,
}

Entity_Kind :: enum {
	nil,
	player,
	door,
}

Direction :: enum {
	top,
	down,
	left,
	right
}

Anim_Frame :: struct {
	sprite : rl.Texture2D,
	length : f32,
}

log_error :: fmt.println

game_state: Game_State

camera : rl.Camera2D

player : ^Entity
door_test : ^Entity
door_test_2 : ^Entity

target : rl.RenderTexture2D 

floor_sprite : rl.Texture2D
door_sprite : rl.Texture2D