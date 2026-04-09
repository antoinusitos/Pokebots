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
	screen_type : Screen_Type,

	current_scene : ^Scene,

	transitionning : bool,
	time_transition : f32,
	transition_done : bool,

	current_door : ^Entity,


	// COMBAT
	player_hp_slider : Slider,
	opponent_hp_slider : Slider,
	opponent : ^Entity,
	is_player_turn : bool,
	combat_flow : Combat_Flow_Type,
	selected_part : Robot_Part_Type,
	opponent_selected_part : Robot_Part_Type,
	current_button : ^Button,
	attack_button : Button,
	flee_button : Button,
	player_head_button : Button,
	player_torso_button : Button,
	player_left_arm_button : Button,
	player_right_arm_button : Button,
	player_left_leg_button : Button,
	player_right_leg_button : Button,

	opponent_head_button : Button,
	opponent_torso_button : Button,
	opponent_left_arm_button : Button,
	opponent_right_arm_button : Button,
	opponent_left_leg_button : Button,
	opponent_right_leg_button : Button,
}

Entity :: struct {
	allocated: bool,
	handle: Entity_Handle,
	kind: Entity_Kind,

	position : rl.Vector2,
	cell_x : int,
	cell_y : int,
	target_cell_x : int,
	target_cell_y : int,
	sprite_size: f32,
	collision_size: f32,
	is_trigger : bool,
	color : rl.Color,
	moved : bool,
	static : bool,
	was_ordered : bool,
	entity_draw_info : Entity_Draw_Info,

	//characters
	speed : f32,
	moving : bool,
	move_lerp : f32,
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
	robot : Robot,

	//door
	target_x : int,
	target_y : int,
	scene : ^Scene,

	update : proc(^Entity),
	on_trigger_enter : proc(self : ^Entity, entity_touching: ^Entity),
	draw: proc(^Entity),
}

Entity_Draw_Info :: struct {
	pos : rl.Vector2,
	sprite_pos : rl.Vector2,
	size : rl.Vector2,
	color : rl.Color,
	use_sprite : bool,
	sprite : rl.Texture2D,
	offset : rl.Vector2,
}

Entity_Handle :: struct {
	index: u64,
	id: u64,
}

Entity_Kind :: enum {
	nil,
	player,
	door,
	npc,
}

Robot_Part :: struct {
	name : string, 
	capacity : int,
	percent : f32,
	hp : f32,
	current_hp : f32,
	hp_consommation : f32,
	sprite : rl.Texture2D,
	attack : f32,
	defense : f32,
	speed : f32,
	abilities : []Ability
}

Robot_Part_Type :: enum {
	head,
	torso,
	left_arm,
	right_arm,
	left_leg,
	right_leg
}

Robot :: struct {
	hp : f32,
	current_hp : f32,
	battery : Robot_Part,
	head : Robot_Part,
	torso : Robot_Part,
	left_arm : Robot_Part,
	right_arm : Robot_Part,
	left_leg : Robot_Part,
	right_leg : Robot_Part,
	abilities : [4]Ability
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

Screen_Type :: enum {
	game,
	combat,
	menu,
}

Input_Type :: enum {
	game,
	dialog,
	combat
}

Cell :: struct {
	cell_x : int,
	cell_y : int,
	sprite_index : int,
	foreground_sprite_index : int,
	roof_sprite_index : int,
	blocker_index : int,
	blocked : bool,
	entity : ^Entity
}

Map_Layer :: struct {
	data : []int,
    height : int,
    id : int,
    name : string,
    opacity : int,
    type : string,
    visible : bool,
    width : int,
    x : int,
    y : int
}

Tile_Set :: struct {
    firstgid : int,
    source : string
}

Map_Info :: struct {
	compressionlevel : int,
	height : int,
    infinite : bool,
    layers : []Map_Layer,
    nextlayerid : int,
    nextobjectid : int,
    orientation : string,
    renderorder : string,
    tiledversion : string,
    tileheight : int,
    tilesets : []Tile_Set,
    tilewidth : int,
    type : string,
    version : string,
    width : int
}

Scene :: struct {
    firstgid : int,
    size_x : int,
    size_y : int,
	cells : [dynamic]Cell,
	doors : [dynamic]^Entity,
	static_entity_draw_infos : [dynamic]Entity_Draw_Info,
	roof_entity_draw_infos : [dynamic]Entity_Draw_Info
}

Combat_Flow_Type :: enum {
	action,
	sender,
	receiver,
	attack
}

Ability :: struct {
	name : string,
}

log_error :: fmt.println

game_state: Game_State

camera : rl.Camera2D

player : ^Entity

target : rl.RenderTexture2D 

floor_sprite : rl.Texture2D
door_sprite : rl.Texture2D

robot_head_sprite : rl.Texture2D
robot_torso_sprite : rl.Texture2D
robot_left_arm_sprite : rl.Texture2D
robot_right_arm_sprite : rl.Texture2D
robot_left_leg_sprite : rl.Texture2D
robot_right_leg_sprite : rl.Texture2D

atlas : rl.Texture2D

main_world : Scene
house_1 : Scene
