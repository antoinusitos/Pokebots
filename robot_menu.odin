package game

import rl "vendor:raylib"
import "core:fmt"

init_robot_menu :: proc() {
    index := 0

    ability_x : f32 = 10
    ability_space_y := 10

    game_state.index_selected_ability = -1
    game_state.index_selected_current_ability = -1

    for a in player.robot.head.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for a in player.robot.torso.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for a in player.robot.left_arm.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for a in player.robot.right_arm.abilities {
       button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for a in player.robot.left_leg.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for a in player.robot.right_leg.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            disabled_color = rl.GRAY,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            set_active_button(&game_state.robot_current_abilities_buttons[0])
            button.background_color = rl.RED
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_ability_to_change = button.button_ability
            game_state.index_selected_ability = button.button_index
        }
    
        append(&game_state.robot_abilities_buttons, button)
        index += 1
    }

    for b in 0..<len(game_state.robot_abilities_buttons) - 1 {
        game_state.robot_abilities_buttons[b].down_button = &game_state.robot_abilities_buttons[b + 1]
    }

    for b in 1..<len(game_state.robot_abilities_buttons) {
        game_state.robot_abilities_buttons[b].up_button = &game_state.robot_abilities_buttons[b - 1]
    }

    ability_x = 500
    index = 0

    for a in player.robot.abilities {
        button := Button {
            x = ability_x,
            y = f32(index * 40 + index * 10 + ability_space_y),
            width = 200,
            height = 40,
            text = a.name,
            text_size = 20,
            background_color = rl.WHITE,
            active = true,
            button_index = index,
            button_ability = a,
        }
        setup_one_button(&button)
        button.on_click = proc(button : ^Button) {
            if button.disabled {
                return
            }
            switch_ability()
        }
        button.on_hover = proc(button : ^Button) {
            game_state.selected_current_ability_to_change = button.button_ability
            game_state.index_selected_current_ability = button.button_index
        }
    
        append(&game_state.robot_current_abilities_buttons, button)
        index += 1
    }

    for b in 0..<len(game_state.robot_current_abilities_buttons) - 1 {
        game_state.robot_current_abilities_buttons[b].down_button = &game_state.robot_current_abilities_buttons[b + 1]
    }

    for b in 1..<len(game_state.robot_current_abilities_buttons) {
        game_state.robot_current_abilities_buttons[b].up_button = &game_state.robot_current_abilities_buttons[b - 1]
    }

    set_active_button(&game_state.robot_abilities_buttons[0])

    desactivate_buttons()
}

draw_robot_menu :: proc() {

    for &b in game_state.robot_abilities_buttons {
        b.draw(&b)
    }

    for &b in game_state.robot_current_abilities_buttons {
        b.draw(&b)
    }

    if game_state.index_selected_ability != -1 {
        rl.DrawText(fmt.ctprint(game_state.selected_ability_to_change.name), i32(800), i32(10), 20, rl.GREEN)
        rl.DrawText(fmt.ctprint(game_state.selected_ability_to_change.desc), i32(800), i32(40), 20, rl.GREEN)
    }

    if game_state.index_selected_current_ability != -1 {
        rl.DrawText(fmt.ctprint(game_state.selected_current_ability_to_change.name), i32(1100), i32(10), 20, rl.GREEN)
        rl.DrawText(fmt.ctprint(game_state.selected_current_ability_to_change.desc), i32(1100), i32(40), 20, rl.GREEN)
    }
}

switch_ability :: proc() {
    game_state.robot_current_abilities_buttons[game_state.index_selected_current_ability].text = game_state.robot_abilities_buttons[game_state.index_selected_ability].text
    set_active_button(&game_state.robot_abilities_buttons[0])
    game_state.robot_abilities_buttons[game_state.index_selected_ability].background_color = rl.WHITE
    player.robot.abilities[game_state.index_selected_current_ability] = game_state.selected_ability_to_change
    game_state.index_selected_ability = -1
    game_state.index_selected_current_ability = -1

    index := 0
    for a in player.robot.abilities {
        game_state.robot_current_abilities_buttons[index].button_ability = a
        index += 1
    }



    desactivate_buttons()


}

desactivate_buttons :: proc() {
    for &b in game_state.robot_abilities_buttons {
        b.disabled = false
        for &b_bis in game_state.robot_current_abilities_buttons {
            if (b_bis.text == b.text) {
                b.disabled = true
                break
            }
        }
    }
}

update_robot_menu :: proc() {
    if (rl.IsKeyPressed(rl.KeyboardKey.A)) {
        if game_state.current_button.left_button != nil {
            set_active_button(game_state.current_button.left_button)
        }
    }
    else if (rl.IsKeyPressed(rl.KeyboardKey.D)) {
        if game_state.current_button.right_button != nil {
            set_active_button(game_state.current_button.right_button)
        }
    }
    else if (rl.IsKeyPressed(rl.KeyboardKey.W)) {
        if game_state.current_button.up_button != nil {
            set_active_button(game_state.current_button.up_button)
        }
    }
    else if (rl.IsKeyPressed(rl.KeyboardKey.S)) {
        if game_state.current_button.down_button != nil {
            set_active_button(game_state.current_button.down_button)
        }
    }
    else if (rl.IsKeyPressed(rl.KeyboardKey.E)) {
        if game_state.current_button != nil {
            game_state.current_button.on_click(game_state.current_button)   
        }
    }
}