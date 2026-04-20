package game

import rl "vendor:raylib"
import "core:math"

entity_create :: proc(kind: Entity_Kind) -> ^Entity {
	new_index : int = -1
	new_entity: ^Entity = nil
	for &entity, index in game_state.entities {
		if !entity.allocated {
			new_entity = &entity
			new_index = int(index)
			break
		}
	}
	if new_index == -1 {
		log_error("out of entities, probably just double the MAX_ENTITIES")
		return nil
	}

	game_state.entity_top_count += 1
	
	// then set it up
	new_entity.allocated = true

	game_state.entity_id_gen += 1
	new_entity.handle.id = game_state.entity_id_gen
	new_entity.handle.index = u64(new_index)

	switch kind {
		case .nil: break
		case .player: setup_player(new_entity)
		case .door: setup_door(new_entity)
		case .npc: setup_npc(new_entity)
	}

	return new_entity
}

entity_destroy :: proc(entity: ^Entity) {
	entity^ = {} // it's really that simple
}

default_draw_based_on_entity_data :: proc(entity: ^Entity) {
	drawPos := snap({entity.position.x, entity.position.y})

	rl.DrawTextureV(entity.sprite, drawPos, entity.color)
	//rl.DrawRectangle(i32(drawPos.x), i32(drawPos.y), i32(entity.sprite_size), i32(entity.sprite_size), entity.color)
}
 
setup_player :: proc(entity: ^Entity) {
	entity.kind = .player
	entity.sprite_size = 16
	entity.collision_size = 14
	entity.color = rl.WHITE
	entity.speed = 3
	entity.is_idle = true
	entity.static = false
	entity.was_ordered = false

	entity.sprite_idle = { 
        { sprite = rl.LoadTexture("Assets/player_idle.png"), length = 1}
    }
    entity.sprite_walk = { 
        { sprite = rl.LoadTexture("Assets/player_walk1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk2.png"), length = 0.15}
    }
    entity.sprite_walk_top = { 
        { sprite = rl.LoadTexture("Assets/player_walk_top1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_top2.png"), length = 0.15}
    }
    entity.sprite_walk_left = { 
        { sprite = rl.LoadTexture("Assets/player_walk_left1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_left2.png"), length = 0.15}
    }
    entity.sprite_walk_right = { 
        { sprite = rl.LoadTexture("Assets/player_walk_right1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_right2.png"), length = 0.15}
    }

	entity.robot = starter_balanced
	entity.robot.hp = 
		f32(entity.robot.head.hp) + 
		f32(entity.robot.torso.hp) + 
		f32(entity.robot.left_arm.hp) + 
		f32(entity.robot.right_arm.hp) + 
		f32(entity.robot.left_leg.hp) + 
		f32(entity.robot.right_leg.hp)
	entity.robot.current_hp = entity.robot.hp
	entity.robot.abilities[0] = entity.robot.left_arm.abilities[0]
	entity.robot.abilities[0].part_type = .left_arm
	entity.robot.abilities[1] = entity.robot.left_arm.abilities[1]
	entity.robot.abilities[1].part_type = .left_arm
	entity.robot.abilities[2] = entity.robot.left_leg.abilities[0]
	entity.robot.abilities[2].part_type = .left_leg
	entity.robot.abilities[3] = entity.robot.left_leg.abilities[1]
	entity.robot.abilities[3].part_type = .left_leg

	entity.robot.current_hp = entity.robot.hp

	entity.entity_draw_info = Entity_Draw_Info {
		use_sprite = true,
		pos = entity.position,
		size = {16, 16},
		color = rl.WHITE,
		offset = {0, -6}
	}

	entity.update = proc(entity: ^Entity) {
		if game_state.transitionning {
			entity.entity_draw_info.sprite = entity.sprite
			entity.entity_draw_info.pos = entity.position
			return
		}

		if game_state.input_type == .side_menu {
			return
		}

		movement : rl.Vector2

		if (!entity.moving)
		{
			entity.moved = false
			entity.move_lerp = 0
			entity.target_cell_x = entity.cell_x
			entity.target_cell_y = entity.cell_y

			if (rl.IsKeyDown(rl.KeyboardKey.S)) {
				entity.target_cell_y = entity.cell_y + 1
				entity.moving = true
			}
			else if (rl.IsKeyDown(rl.KeyboardKey.W)) {
				entity.target_cell_y = entity.cell_y - 1
				entity.moving = true
			}
			else if (rl.IsKeyDown(rl.KeyboardKey.D)) {
				entity.target_cell_x = entity.cell_x + 1
				entity.moving = true
			}
			else if (rl.IsKeyDown(rl.KeyboardKey.A)) {
				entity.target_cell_x = entity.cell_x - 1
				entity.moving = true
			}

			if game_state.current_scene.cells[entity.target_cell_y * game_state.current_scene.size_x + entity.target_cell_x].blocked {
				entity.target_cell_x = entity.cell_x
				entity.target_cell_y = entity.cell_y
				entity.moving = false
			}
		}
		else
		{
			entity.moved = true
			entity.move_lerp += rl.GetFrameTime() * entity.speed
			if (entity.move_lerp > 1) {
				entity.move_lerp = 1
				entity.moving = false
				entity.cell_x = entity.target_cell_x
				entity.cell_y = entity.target_cell_y
			}
			entity.position.x = math.lerp(f32(entity.cell_x * 16), f32(entity.target_cell_x * 16), entity.move_lerp)
			entity.position.y = math.lerp(f32(entity.cell_y * 16), f32(entity.target_cell_y * 16), entity.move_lerp)
		}

		movement.y = f32(entity.target_cell_y - entity.cell_y)		
		movement.x = f32(entity.target_cell_x - entity.cell_x)	
		
		if movement.x == 0 && movement.y == 0 {
			if !entity.is_idle {
				entity.is_idle = true
				entity.anim_frame = 0
			}
			entity.anim_time += rl.GetFrameTime()
			if entity.anim_time >= entity.sprite_idle[entity.anim_frame].length {
				entity.anim_time = 0
				entity.anim_frame += 1
				if entity.anim_frame >= len(entity.sprite_idle) {
					entity.anim_frame = 0
				}
			}
			switch (entity.direction) {
				case .top :
				entity.sprite = entity.sprite_walk_top[0].sprite
				break
				case .down :
				entity.sprite = entity.sprite_idle[entity.anim_frame].sprite
				break
				case .left :
				entity.sprite = entity.sprite_walk_left[0].sprite
				break
				case .right :
				entity.sprite = entity.sprite_walk_right[0].sprite
				break
			}

			entity.entity_draw_info.sprite = entity.sprite
			entity.entity_draw_info.pos = entity.position
		}
		else {
			if entity.is_idle {
				entity.is_idle = false
				entity.anim_frame = 0
			}
			entity.anim_time += rl.GetFrameTime()
			if (movement.y < 0)
			{
				entity.direction = .top
				entity.sprite_walk_current = entity.sprite_walk_top
			}
			else if (movement.y > 0)
			{
				entity.direction = .down
				entity.sprite_walk_current = entity.sprite_walk
			}
			else if (movement.x < 0)
			{
				entity.direction = .left
				entity.sprite_walk_current = entity.sprite_walk_left
			}
			else {
				entity.direction = .right
				entity.sprite_walk_current = entity.sprite_walk_right
			}
			if entity.anim_time >= entity.sprite_walk_current[entity.anim_frame].length {
				entity.anim_time = 0
				entity.anim_frame += 1
				if entity.anim_frame >= len(entity.sprite_walk_current) {
					entity.anim_frame = 0
				}
			}
			entity.sprite = entity.sprite_walk_current[entity.anim_frame].sprite
			entity.entity_draw_info.sprite = entity.sprite
			entity.entity_draw_info.pos = entity.position
		}

	}
	entity.on_trigger_enter = proc(self : ^Entity, entity_touching: ^Entity) {
	}
	entity.draw = proc(entity: ^Entity) {
		default_draw_based_on_entity_data(entity)
	}
}

setup_player_anim :: proc(entity : ^Entity) {
	entity.sprite_idle = { 
        { sprite = rl.LoadTexture("Assets/player_idle.png"), length = 1}
    }
    entity.sprite_walk = { 
        { sprite = rl.LoadTexture("Assets/player_walk1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk2.png"), length = 0.15}
    }
    entity.sprite_walk_top = { 
        { sprite = rl.LoadTexture("Assets/player_walk_top1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_top2.png"), length = 0.15}
    }
    entity.sprite_walk_left = { 
        { sprite = rl.LoadTexture("Assets/player_walk_left1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_left2.png"), length = 0.15}
    }
    entity.sprite_walk_right = { 
        { sprite = rl.LoadTexture("Assets/player_walk_right1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_right2.png"), length = 0.15}
    }
}

setup_door :: proc(entity: ^Entity) {
	entity.sprite = rl.LoadTexture("Assets/door.png")
	entity.kind = .door
	entity.sprite_size = 16
	entity.collision_size = 10
	entity.color = rl.WHITE
	entity.is_trigger = true
	entity.static = true
	entity.was_ordered = false

	entity.update = proc(entity: ^Entity) {
	}
	entity.on_trigger_enter = proc(self : ^Entity, entity_touching: ^Entity) {
		game_state.transitionning = true
		game_state.current_door = self
	}
	entity.draw = proc(entity: ^Entity) {
		//default_draw_based_on_entity_data(entity)
	}
}

setup_npc :: proc(entity: ^Entity) {
	entity.kind = .npc
	entity.sprite_size = 16
	entity.collision_size = 14
	entity.color = rl.WHITE
	entity.speed = 3
	entity.is_idle = true
	entity.static = false
	entity.moved = false
	entity.was_ordered = false
	entity.robot = starter_balanced
	entity.robot.hp = 
		f32(entity.robot.head.hp) + 
		f32(entity.robot.torso.hp) + 
		f32(entity.robot.left_arm.hp) + 
		f32(entity.robot.right_arm.hp) + 
		f32(entity.robot.left_leg.hp) + 
		f32(entity.robot.right_leg.hp)
	entity.robot.current_hp = entity.robot.hp
	entity.robot.abilities[0] = entity.robot.left_arm.abilities[0]
	entity.robot.abilities[0].part_type = .left_arm
	entity.robot.abilities[1] = entity.robot.left_arm.abilities[1]
	entity.robot.abilities[1].part_type = .left_arm
	entity.robot.abilities[2] = entity.robot.left_leg.abilities[0]
	entity.robot.abilities[2].part_type = .left_leg
	entity.robot.abilities[3] = entity.robot.left_leg.abilities[1]
	entity.robot.abilities[3].part_type = .left_leg

	entity.robot.current_hp = entity.robot.hp

	entity.entity_draw_info = Entity_Draw_Info {
		use_sprite = true,
		pos = entity.position,
		size = {16, 16},
		color = rl.WHITE,
		offset = {0, 0}
	}

	entity.update = proc(entity: ^Entity) {
	}
	entity.on_trigger_enter = proc(self : ^Entity, entity_touching: ^Entity) {
	}
	entity.draw = proc(entity: ^Entity) {
		default_draw_based_on_entity_data(entity)
	}
}