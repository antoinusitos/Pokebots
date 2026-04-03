package game

import rl "vendor:raylib"
import "core:math"
import "core:slice"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:encoding/json"

Button_Type :: enum {
	once,
	filling,
}

Button :: struct {
	x : f32,
	y : f32,
	width : f32,
	height : f32,
	background_color : rl.Color,
	hover_color : rl.Color,
	clicked_color : rl.Color,
	fill_color : rl.Color,
	disabled_color : rl.Color,
	button_type : Button_Type,
	is_hover : bool,
	is_clicked : bool,
	disabled : bool,
	active : bool, // don't update or draw

	up_button : ^Button,
	down_button : ^Button,
	left_button : ^Button,
	right_button : ^Button,

	filled_done : bool,
	fill_percent : f32,
	fill_max : f32,
	fill_auto_reset : bool,

	text : string,
	text_size : i32,
	text_offset : rl.Vector2,

	update : proc(^Button),
	draw : proc(^Button),
	on_click : proc(button : ^Button),
	on_down : proc(^Button),
	on_release : proc(^Button),
	on_filled : proc(^Button),
	on_hover : proc(^Button),
	on_exit : proc(^Button),
}

setup_one_button :: proc(button : ^Button) {
	button.button_type = .once
	button.update = proc(button : ^Button) {
		if !button.active {
			return
		}

		if button.disabled {
			button.is_clicked = false
			return
		}

		mouse_pos := rl.GetMousePosition()

		if mouse_pos.x >= button.x && mouse_pos.x <= button.x + button.width &&
			mouse_pos.y >= button.y && mouse_pos.y <= button.y + button.height {
				button.is_hover = true
				button.on_hover(button)

				if rl.IsMouseButtonPressed(.LEFT) {
					button.is_clicked = true
					button.on_click(button)
				}
				else if rl.IsMouseButtonReleased(.LEFT) {
					button.is_clicked = false
					button.on_release(button)
				}
		}
		else {
			if rl.IsMouseButtonReleased(.LEFT) {
				if button.is_clicked {
					button.on_release(button)
				}
				button.is_clicked = false
			}

			if button.is_hover {
				button.on_exit(button)
			}
			button.is_hover = false
		}
	}
	button.draw = proc(button : ^Button) {
		if !button.active {
			return
		}

		if button.disabled {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.disabled_color)
			rl.DrawText(fmt.ctprint(button.text), i32(button.x + button.text_offset.x), i32(button.y + button.text_offset.y), button.text_size, rl.BLACK)
			return
		}
		if button.is_clicked {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.clicked_color)
		}
		else {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.is_hover ? button.hover_color : button.background_color)
		}
		rl.DrawText(fmt.ctprint(button.text), i32(button.x + button.text_offset.x), i32(button.y + button.text_offset.y), button.text_size, rl.BLACK)
	}

	button.on_click = proc(button : ^Button) {

	}
	button.on_down = proc(button : ^Button) {
		
	}
	button.on_release = proc(button : ^Button) {
		
	}
	button.on_filled = proc(button : ^Button) {
		
	}
	button.on_hover = proc(button : ^Button) {
		
	}

	button.on_exit = proc(button : ^Button) {
		
	}
}

setup_filling_button :: proc(button : ^Button) {
	button.button_type = .filling
	button.update = proc(button : ^Button) {
		if !button.active {
			return
		}

		if button.disabled {
			return
		}

		mouse_pos := rl.GetMousePosition()

		if mouse_pos.x >= button.x && mouse_pos.x <= button.x + button.width &&
			mouse_pos.y >= button.y && mouse_pos.y <= button.y + button.height {
				button.is_hover = true
				button.on_hover(button)
				
				if rl.IsMouseButtonDown(.LEFT) {
					button.is_clicked = true
					button.fill_percent += rl.GetFrameTime()
					if button.fill_percent >= button.fill_max {
						button.fill_percent = button.fill_max
						if !button.fill_auto_reset {
							if !button.filled_done {
								button.filled_done = true
								button.on_filled(button)
							}
						}
						else {
							button.fill_percent = 0
							button.on_filled(button)
						}
					}
				}
				else if rl.IsMouseButtonReleased(.LEFT) {
					button.is_clicked = false
					button.fill_percent = 0
					button.filled_done = false
				}
		}
		else {
			if button.is_hover {
				button.on_exit(button)
			}
			button.is_hover = false
		}
	}
	button.draw = proc(button : ^Button) {
		if !button.active {
			return
		}
		
		if button.disabled {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.disabled_color)
			rl.DrawText(fmt.ctprint(button.text), i32(button.x + button.text_offset.x), i32(button.y + button.text_offset.y), button.text_size, rl.BLACK)
			return
		}
		if button.is_clicked {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.background_color)
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, f32(button.width * (button.fill_percent / button.fill_max)) , button.height}, button.fill_color)
		}
		else {
			rl.DrawRectangleRec(rl.Rectangle{button.x, button.y, button.width, button.height}, button.is_hover ? button.hover_color : button.background_color)
		}
		rl.DrawText(fmt.ctprint(button.text), i32(button.x + button.text_offset.x), i32(button.y + button.text_offset.y), button.text_size, rl.BLACK)
	}

	button.on_click = proc(button : ^Button) {

	}
	button.on_down = proc(button : ^Button) {
		
	}
	button.on_release = proc(button : ^Button) {
		
	}
	button.on_filled = proc(button : ^Button) {
		
	}
	button.on_hover = proc(button : ^Button) {
		
	}
	button.on_exit = proc(button : ^Button) {
		
	}
}

Reactive_Image :: struct {
	x : f32,
	y : f32,
	start_x : f32,
	start_y : f32,
	width : f32,
	height : f32,
	background_color : rl.Color,
	hover_color : rl.Color,
	disabled_color : rl.Color,
	is_hover : bool,
	is_clicked : bool,
	disabled : bool,
	active : bool, // don't update or draw

	index : int,

	update : proc(^Reactive_Image),
	draw : proc(^Reactive_Image),
	on_click : proc(button : ^Reactive_Image),
	on_release : proc(^Reactive_Image),
	on_hover : proc(^Reactive_Image),
	on_exit : proc(^Reactive_Image),
}

setup_reactive_image :: proc(reactive_image : ^Reactive_Image) {
	reactive_image.update = proc(reactive_image : ^Reactive_Image) {
		if !reactive_image.active {
			return
		}

		if reactive_image.disabled {
			reactive_image.is_clicked = false
			return
		}

		mouse_pos := rl.GetMousePosition()

		if mouse_pos.x >= reactive_image.x && mouse_pos.x <= reactive_image.x + reactive_image.width &&
			mouse_pos.y >= reactive_image.y && mouse_pos.y <= reactive_image.y + reactive_image.height {
				reactive_image.is_hover = true
				reactive_image.on_hover(reactive_image)

				if rl.IsMouseButtonPressed(.LEFT) {
					reactive_image.is_clicked = true
					reactive_image.on_click(reactive_image)
				}
				else if rl.IsMouseButtonReleased(.LEFT) {
					reactive_image.is_clicked = false
					reactive_image.on_release(reactive_image)
				}
		}
		else {
			if rl.IsMouseButtonReleased(.LEFT) {
				if reactive_image.is_clicked {
					reactive_image.on_release(reactive_image)
				}
				reactive_image.is_clicked = false
			}

			if reactive_image.is_hover {
				reactive_image.on_exit(reactive_image)
			}
			reactive_image.is_hover = false
		}
	}
	reactive_image.draw = proc(reactive_image : ^Reactive_Image) {
		if !reactive_image.active {
			return
		}

		if reactive_image.disabled {
			rl.DrawRectangleRec(rl.Rectangle{reactive_image.x, reactive_image.y, reactive_image.width, reactive_image.height}, reactive_image.disabled_color)
			return
		}
		rl.DrawRectangleRec(rl.Rectangle{reactive_image.x, reactive_image.y, reactive_image.width, reactive_image.height}, reactive_image.is_hover ? reactive_image.hover_color : reactive_image.background_color)
	}

	reactive_image.on_click = proc(reactive_image : ^Reactive_Image) {

	}
	reactive_image.on_release = proc(reactive_image : ^Reactive_Image) {
		
	}
	reactive_image.on_hover = proc(reactive_image : ^Reactive_Image) {
		
	}
	reactive_image.on_exit = proc(reactive_image : ^Reactive_Image) {
		
	}
}

Slider :: struct {
	x : f32,
	y : f32,
	width : f32,
	height : f32,
	percent : f32,
	background_color : rl.Color,
	foreground_color : rl.Color,
	active : bool, // don't update or draw

	draw : proc(^Slider),
}

setup_slider :: proc(slider : ^Slider) {
	slider.draw = proc(slider : ^Slider) {
		if !slider.active {
			return
		}

		rl.DrawRectangleRec(rl.Rectangle{slider.x, slider.y, slider.width, slider.height}, slider.background_color)
		rl.DrawRectangleRec(rl.Rectangle{slider.x, slider.y, slider.width * slider.percent, slider.height}, slider.foreground_color)
	}
}

distance :: proc(v1 : rl.Vector2, v2 : rl.Vector2) -> f32{
    first :f32 = math.pow_f32(v2.x-v1.x,2)
    second :f32 = math.pow_f32(v2.y-v1.y,2)
    return (first+second)
}

read_map :: proc(map_name : string) -> [dynamic]string {
	return_lines : [dynamic]string
	if map_data, ok := os.read_entire_file(map_name, context.temp_allocator); ok {
		it := string(map_data)
		for line in strings.split_lines_iterator(&it) {
			if strings.contains(line, "//") {

			}
			else {
				append(&return_lines, line)
			}
			// process line
		}
    } else {
        log_error("Failed to read map_data")
    }

    return return_lines
}

map_from_file :: proc(filepath : string) -> Map_Info {
    map_info: Map_Info

    if json_data, ok := os.read_entire_file(filepath, context.temp_allocator); ok {
        if json.unmarshal(json_data, &map_info) == nil {
            // my_struct now contains
            // the data from my_struct_file.
        } else {
            log_error("Failed to unmarshal JSON")
        }
    } else {
        log_error("Failed to read my_struct_file")
    }

	return map_info
}

collide :: proc(entity_a : ^Entity, entity_b : ^Entity) -> int {
	//is_colliding := entity_a.position.x < entity_b.position.x + entity_b.collision_size &&
	//		entity_a.position.x + entity_a.collision_size > entity_b.position.x &&
	//		entity_a.position.y < entity_b.position.y + entity_b.collision_size &&
	//		entity_a.position.y + entity_a.collision_size > entity_b.position.y

	is_colliding := entity_a.cell_x == entity_b.cell_x && entity_a.cell_y == entity_b.cell_y

	if is_colliding && entity_a.is_trigger {
		entity_a.on_trigger_enter(entity_a, entity_b)
	}
	if is_colliding && entity_b.is_trigger {
		entity_b.on_trigger_enter(entity_b, entity_a)
	}

	if is_colliding {
		if entity_a.is_trigger || entity_b.is_trigger {
			return 1
		}
		else {
			return 2
		}
	}
	return 0
}

snap :: proc(v: rl.Vector2) -> rl.Vector2 {
    return rl.Vector2{
        f32(int(v.x)),
        f32(int(v.y)),
    }
}

transition :: proc() {
    game_state.time_transition += rl.GetFrameTime()
    color := rl.BLACK
    if game_state.time_transition < TRANSITION_TIME / 2 {
        color.a = u8(game_state.time_transition / (TRANSITION_TIME / 2) * 255)
        rl.DrawRectangleRec({0, 0, WINDOW_WIDTH, WINDOW_HEIGHT}, color)
    }
    else {
        if !game_state.transition_done {
            game_state.transition_done = true
            game_state.current_scene = game_state.current_door.scene
            player.cell_x = game_state.current_door.target_x
		    player.cell_y = game_state.current_door.target_y
		    player.moving = false
		    player.position = {f32(player.cell_x)  * 16, f32(player.cell_y) * 16}
		    player.direction = .down
            game_state.current_door = nil
        }
        color.a = u8( (1 - game_state.time_transition / (TRANSITION_TIME / 2)) * 255)
        rl.DrawRectangleRec({0, 0, WINDOW_WIDTH, WINDOW_HEIGHT}, color)

        if game_state.time_transition >= TRANSITION_TIME {
            game_state.time_transition = 0
            game_state.transitionning = false
            game_state.transition_done = false
        }
    }
}

load_level :: proc(level_name : string, scene : ^Scene) {
    map_info := map_from_file(level_name)

    scene.size_x = map_info.width
    scene.size_y = map_info.height

    for y := 0; y < scene.size_y; y += 1 {
        for x := 0; x < scene.size_x ; x += 1 {
            cell := Cell{
                cell_x = x, 
                cell_y = y, 
                sprite_index = map_info.layers[0].data[y *  scene.size_x + x] - 1, 
                foreground_sprite_index = map_info.layers[1].data[y *  scene.size_x + x] - 1,
                blocker_index = map_info.layers[2].data[y *  scene.size_x + x]}
            if cell.sprite_index != -1 {
                index_x := cell.sprite_index % ATLAS_WIDTH
                cell.sprite_pos_x = f32(index_x * 16)
                index_y := (cell.sprite_index - index_x) / ATLAS_HEIGHT
                cell.sprite_pos_y = f32(index_y * 16)
            }
            if cell.foreground_sprite_index != -1 {
                index_x := cell.foreground_sprite_index % ATLAS_WIDTH
                cell.foreground_sprite_pos_x = f32(index_x * 16)
                index_y := (cell.foreground_sprite_index - index_x) / ATLAS_HEIGHT
                cell.foreground_sprite_pos_y = f32(index_y * 16)
                if cell.foreground_sprite_index == DOOR_SPRITE_INDEX {
                    door := entity_create(.door)
                    door.position = {f32(x) * door.sprite_size, f32(y) * door.sprite_size}
                    door.cell_x = x
                    door.cell_y = y
                    door.target_x = 4
                    door.target_y = 5
                    door.scene = &house_1
                    append(&scene.doors, door)
                }
                else if cell.foreground_sprite_index == MAT_LEFT_SPRITE_INDEX {
                    door := entity_create(.door)
                    door.position = {f32(x) * door.sprite_size, f32(y) * door.sprite_size}
                    door.cell_x = x
                    door.cell_y = y
                    door.target_x = 5
                    door.target_y = 7
                    door.scene = &main_world
                    append(&scene.doors, door)
                }
                else if cell.foreground_sprite_index == MAT_RIGHT_SPRITE_INDEX {
                    door := entity_create(.door)
                    door.position = {f32(x) * door.sprite_size, f32(y) * door.sprite_size}
                    door.cell_x = x
                    door.cell_y = y
                    door.target_x = 5
                    door.target_y = 7
                    door.scene = &main_world
                    append(&scene.doors, door)
                }
            }
            if cell.blocker_index != 0 {
                cell.blocked = true
            }
            append(&scene.cells, cell)
            
        }
    }
}