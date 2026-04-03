package game

import "core:log"
import "core:fmt"
import rl "vendor:raylib"

start_combat :: proc() {
    game_state.opponent = entity_create(.npc)

    game_state.screen_type = .combat

    game_state.player_hp_slider = Slider {
        x = 0,
        y = 0,
        width = 150,
        height = 30,
        percent = 0.5,
        foreground_color = rl.YELLOW,
        background_color = rl.RED,
        active = true
    }
    setup_slider(&game_state.player_hp_slider)

    game_state.opponent_hp_slider = Slider {
        x = WINDOW_WIDTH - 150,
        y = 0,
        width = 150,
        height = 30,
        percent = 1,
        foreground_color = rl.YELLOW,
        background_color = rl.RED,
        active = true
    }
    setup_slider(&game_state.opponent_hp_slider)

    game_state.attack_button = Button {
        x = 10,
        y = WINDOW_HEIGHT - 50,
        width = 100,
        height = 40,
        text = "ATTACK",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        right_button = &game_state.flee_button
    }
    setup_one_button(&game_state.attack_button)
    game_state.attack_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .sender
        set_active_button(&game_state.player_head_button)
    }

    game_state.flee_button = Button {
        x = 120,
        y = WINDOW_HEIGHT - 50,
        width = 100,
        height = 40,
        text = "RUN AWAY",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        left_button = &game_state.attack_button
    }
    setup_one_button(&game_state.flee_button)
    game_state.flee_button.on_click = proc(button : ^Button) {
        leave_combat()
    }

    game_state.player_head_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2,
        width = 200,
        height = 40,
        text = "HEAD",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.player_torso_button
    }
    setup_one_button(&game_state.player_head_button)
    game_state.player_head_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .head
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.player_torso_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2 + 50,
        width = 200,
        height = 40,
        text = "TORSO",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.player_left_arm_button,
        up_button = &game_state.player_head_button
    }
    setup_one_button(&game_state.player_torso_button)
    game_state.player_torso_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .torso
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.player_left_arm_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2 + 100,
        width = 200,
        height = 40,
        text = "LEFT ARM",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.player_right_arm_button,
        up_button = &game_state.player_torso_button
    }
    setup_one_button(&game_state.player_left_arm_button)
    game_state.player_left_arm_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .left_arm
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.player_right_arm_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2 + 150,
        width = 200,
        height = 40,
        text = "RIGHT ARM",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.player_left_leg_button,
        up_button = &game_state.player_left_arm_button
    }
    setup_one_button(&game_state.player_right_arm_button)
    game_state.player_right_arm_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .right_arm
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.player_left_leg_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2 + 200,
        width = 200,
        height = 40,
        text = "LEFT LEG",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.player_right_leg_button,
        up_button = &game_state.player_right_arm_button
    }
    setup_one_button(&game_state.player_left_leg_button)
    game_state.player_left_leg_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .left_leg
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.player_right_leg_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2 + 250,
        width = 200,
        height = 40,
        text = "RIGHT LEG",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        up_button = &game_state.player_left_leg_button
    }
    setup_one_button(&game_state.player_right_leg_button)
    game_state.player_right_leg_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .receiver
        game_state.selected_part = .right_leg
        set_active_button(&game_state.opponent_head_button)
    }

    game_state.opponent_head_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2,
        width = 200,
        height = 40,
        text = "HEAD",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.opponent_torso_button
    }
    setup_one_button(&game_state.opponent_head_button)
    game_state.opponent_head_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.selected_part = .head
    }

    game_state.opponent_torso_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 50,
        width = 200,
        height = 40,
        text = "TORSO",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.opponent_left_arm_button,
        up_button = &game_state.opponent_head_button
    }
    setup_one_button(&game_state.opponent_torso_button)
    game_state.opponent_torso_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.opponent_selected_part = .torso
    }

    game_state.opponent_left_arm_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 100,
        width = 200,
        height = 40,
        text = "LEFT ARM",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.opponent_right_arm_button,
        up_button = &game_state.opponent_torso_button
    }
    setup_one_button(&game_state.opponent_left_arm_button)
    game_state.opponent_left_arm_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.opponent_selected_part = .left_arm
    }

    game_state.opponent_right_arm_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 150,
        width = 200,
        height = 40,
        text = "RIGHT ARM",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.opponent_left_leg_button,
        up_button = &game_state.opponent_left_arm_button
    }
    setup_one_button(&game_state.opponent_right_arm_button)
    game_state.opponent_right_arm_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.opponent_selected_part = .right_arm
    }

    game_state.opponent_left_leg_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 200,
        width = 200,
        height = 40,
        text = "LEFT LEG",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.opponent_right_leg_button,
        up_button = &game_state.opponent_right_arm_button
    }
    setup_one_button(&game_state.opponent_left_leg_button)
    game_state.opponent_left_leg_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.opponent_selected_part = .left_leg
    }

    game_state.opponent_right_leg_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 250,
        width = 200,
        height = 40,
        text = "RIGHT LEG",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        up_button = &game_state.opponent_left_leg_button
    }
    setup_one_button(&game_state.opponent_right_leg_button)
    game_state.opponent_right_leg_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .attack
        game_state.opponent_selected_part = .right_leg
    }

    set_active_button(&game_state.attack_button)

    game_state.is_player_turn = true
}

leave_combat :: proc() {
    game_state.screen_type = .game
}

set_active_button :: proc(button : ^Button) {
    if game_state.current_button != nil {
        game_state.current_button.background_color = rl.WHITE
    }

    button.background_color = rl.RED
    game_state.current_button = button
}

update_combat :: proc () {
    game_state.player_hp_slider.percent = player.robot.current_hp / player.robot.hp
    game_state.opponent_hp_slider.percent = game_state.opponent.robot.current_hp / game_state.opponent.robot.hp

    if game_state.is_player_turn {
        if (rl.IsKeyPressed(rl.KeyboardKey.Q)) {
            if game_state.current_button.left_button != nil {
                set_active_button(game_state.current_button.left_button)
            }
        }
        else if (rl.IsKeyPressed(rl.KeyboardKey.D)) {
            if game_state.current_button.right_button != nil {
                set_active_button(game_state.current_button.right_button)
            }
        }
        else if (rl.IsKeyPressed(rl.KeyboardKey.Z)) {
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
        else if (rl.IsKeyPressed(rl.KeyboardKey.R)) {
            switch game_state.combat_flow {
                case .action:
                case .sender:
                    game_state.combat_flow = .action
                    set_active_button(&game_state.attack_button)
                case .receiver:
                    game_state.combat_flow = .sender
                    set_active_button(&game_state.player_head_button)
                case .attack:
            }
        }

        if game_state.combat_flow == .attack {
            game_state.combat_flow = .action
            game_state.is_player_turn = false
            apply_damage(game_state.opponent, game_state.opponent_selected_part, game_state.selected_part)
        }
    }
    else {
        apply_damage(player, .left_arm, .right_arm)
        game_state.is_player_turn = true
        set_active_button(&game_state.attack_button)
    }
}

draw_combat :: proc () {
    // PLAYER
    game_state.player_hp_slider.draw(&game_state.player_hp_slider)
    rl.DrawText(fmt.ctprint(player.robot.current_hp, "/", player.robot.hp), 0, 40, 20, rl.WHITE)

    rl.DrawTextureV(player.robot.head.sprite, {300, 300}, evaluate_part_hp(player.robot.head))
    rl.DrawTextureV(player.robot.torso.sprite, {300, 300}, evaluate_part_hp(player.robot.torso))
    rl.DrawTextureV(player.robot.left_arm.sprite, {300, 300}, evaluate_part_hp(player.robot.left_arm))
    rl.DrawTextureV(player.robot.right_arm.sprite, {300, 300}, evaluate_part_hp(player.robot.right_arm))
    rl.DrawTextureV(player.robot.left_leg.sprite, {300, 300}, evaluate_part_hp(player.robot.left_leg))
    rl.DrawTextureV(player.robot.right_leg.sprite, {300, 300}, evaluate_part_hp(player.robot.right_leg))

    // OPPONENT
    game_state.opponent_hp_slider.draw(&game_state.opponent_hp_slider)
    rl.DrawText(fmt.ctprint(game_state.opponent.robot.current_hp, "/", game_state.opponent.robot.hp), WINDOW_WIDTH - 150, 40, 20, rl.WHITE)

    rl.DrawTextureV(game_state.opponent.robot.head.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.head))
    rl.DrawTextureV(game_state.opponent.robot.torso.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.torso))
    rl.DrawTextureV(game_state.opponent.robot.left_arm.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.left_arm))
    rl.DrawTextureV(game_state.opponent.robot.right_arm.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.right_arm))
    rl.DrawTextureV(game_state.opponent.robot.left_leg.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.left_leg))
    rl.DrawTextureV(game_state.opponent.robot.right_leg.sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.right_leg))

    switch game_state.combat_flow {
        case .action:
            game_state.attack_button.draw(&game_state.attack_button)
            game_state.flee_button.draw(&game_state.flee_button)
        case .sender:
            game_state.player_head_button.draw(&game_state.player_head_button)
            game_state.player_torso_button.draw(&game_state.player_torso_button)
            game_state.player_left_arm_button.draw(&game_state.player_left_arm_button)
            game_state.player_right_arm_button.draw(&game_state.player_right_arm_button)
            game_state.player_left_leg_button.draw(&game_state.player_left_leg_button)
            game_state.player_right_leg_button.draw(&game_state.player_right_leg_button)
        case .receiver:
            game_state.opponent_head_button.draw(&game_state.opponent_head_button)
            game_state.opponent_torso_button.draw(&game_state.opponent_torso_button)
            game_state.opponent_left_arm_button.draw(&game_state.opponent_left_arm_button)
            game_state.opponent_right_arm_button.draw(&game_state.opponent_right_arm_button)
            game_state.opponent_left_leg_button.draw(&game_state.opponent_left_leg_button)
            game_state.opponent_right_leg_button.draw(&game_state.opponent_right_leg_button)
        case .attack:
    }
    
}

apply_damage :: proc(entity : ^Entity, part : Robot_Part_Type, sender_part : Robot_Part_Type) {
    damage : f32 = 0

    sender_part_retrieved : Robot_Part

    switch sender_part {
        case .head:
            sender_part_retrieved = entity.robot.head
        case .torso:
            sender_part_retrieved = entity.robot.torso
        case .left_arm:
            sender_part_retrieved = entity.robot.left_arm
        case .right_arm:
            sender_part_retrieved = entity.robot.right_arm
        case .left_leg:
            sender_part_retrieved = entity.robot.left_leg
        case .right_leg:
            sender_part_retrieved = entity.robot.right_leg
    }
    damage = sender_part_retrieved.damage * (sender_part_retrieved.current_hp / sender_part_retrieved.hp) * (sender_part_retrieved.percent / 100)
    log_error(sender_part_retrieved.damage)
    log_error(sender_part_retrieved.current_hp / sender_part_retrieved.hp)
    log_error(sender_part_retrieved.percent / 100)

    switch (part) {
        case .head:
            entity.robot.head.current_hp -= damage
            entity.robot.current_hp -= entity.robot.head.hp_consommation * damage
            if entity.robot.head.current_hp < 0 {
                entity.robot.head.current_hp = 0
            }
        case .torso:
            entity.robot.torso.current_hp -= damage
            entity.robot.current_hp -= entity.robot.torso.hp_consommation * damage
            if entity.robot.torso.current_hp < 0 {
                entity.robot.torso.current_hp = 0
            }
        case .left_arm:
            entity.robot.left_arm.current_hp -= damage
            entity.robot.current_hp -= entity.robot.left_arm.hp_consommation * damage
            if entity.robot.left_arm.current_hp < 0 {
                entity.robot.left_arm.current_hp = 0
            }
        case .right_arm:
            entity.robot.right_arm.current_hp -= damage
            entity.robot.current_hp -= entity.robot.right_arm.hp_consommation * damage
            if entity.robot.right_arm.current_hp < 0 {
                entity.robot.right_arm.current_hp = 0
            }
        case .left_leg:
            entity.robot.left_leg.current_hp -= damage
            entity.robot.current_hp -= entity.robot.left_leg.hp_consommation * damage
            if entity.robot.left_leg.current_hp < 0 {
                entity.robot.left_leg.current_hp = 0
            }
        case .right_leg:
            entity.robot.right_leg.current_hp -= damage
            entity.robot.current_hp -= entity.robot.right_leg.hp_consommation * damage
            if entity.robot.right_leg.current_hp < 0 {
                entity.robot.right_leg.current_hp = 0
            }
    }

    if entity.robot.current_hp <= 0 {
        entity.robot.current_hp = 0
        game_state.screen_type = .game
    }
}

evaluate_part_hp :: proc(part : Robot_Part) -> rl.Color {
    percent := part.current_hp / part.hp
    if (percent < 0.25)
    {
        return rl.RED
    }
    else if (percent < 0.5)
    {
        return rl.ORANGE
    }
    else if (percent < 0.75)
    {
        return rl.YELLOW
    }

    return rl.WHITE
}