package game

import rl "vendor:raylib"

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
	}

	return new_entity
}

entity_destroy :: proc(entity: ^Entity) {
	entity^ = {} // it's really that simple
}

default_draw_based_on_entity_data :: proc(entity: ^Entity) {
	drawPos := snap({entity.position.x, -entity.position.y})

	rl.DrawTextureV(entity.sprite, drawPos, entity.color)
	//rl.DrawRectangle(i32(drawPos.x), i32(drawPos.y), i32(entity.sprite_size), i32(entity.sprite_size), entity.color)
}
 
setup_player :: proc(entity: ^Entity) {
	entity.kind = .player
	entity.sprite_size = 16
	entity.collision_size = 14
	entity.color = rl.WHITE
	entity.speed = 50
	entity.is_idle = true

	entity.update = proc(entity: ^Entity) {
		if game_state.transitionning {
			return
		}

		movement : rl.Vector2

		if (rl.IsKeyDown(rl.KeyboardKey.S)) {
			movement.y -= entity.speed * rl.GetFrameTime()
		}
		else if (rl.IsKeyDown(rl.KeyboardKey.Z)) {
			movement.y += entity.speed * rl.GetFrameTime()
		}
		else if (rl.IsKeyDown(rl.KeyboardKey.D)) {
			movement.x += entity.speed * rl.GetFrameTime()
		}
		else if (rl.IsKeyDown(rl.KeyboardKey.Q)) {
			movement.x -= entity.speed * rl.GetFrameTime()
		}

		entity.position += movement
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

			//entity.sprite = entity.sprite_idle[entity.anim_frame].sprite
		}
		else {
			if entity.is_idle {
				entity.is_idle = false
				entity.anim_frame = 0
			}
			entity.anim_time += rl.GetFrameTime()
			if (movement.y > 0)
			{
				entity.direction = .top
				entity.sprite_walk_current = entity.sprite_walk_top
			}
			else if (movement.y < 0)
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

	entity.update = proc(entity: ^Entity) {
	}
	entity.on_trigger_enter = proc(self : ^Entity, entity_touching: ^Entity) {
		game_state.transitionning = true
		game_state.current_door = self
	}
	entity.draw = proc(entity: ^Entity) {
		default_draw_based_on_entity_data(entity)
	}
}