package game

import "core:log"
import "core:fmt"
import rl "vendor:raylib"

start_combat :: proc() {
    game_state.opponent = entity_create(.npc)

    game_state.screen_type = .combat

    game_state.player_hp_slider = Slider {
        x = 10,
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
        x = WINDOW_WIDTH - 160,
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
        width = 150,
        height = 40,
        text = "ATTACK",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        right_button = &game_state.flee_button
    }
    setup_one_button(&game_state.attack_button)
    game_state.attack_button.on_click = proc(button : ^Button) {
        game_state.combat_flow = .ability
        set_active_button(&game_state.ability_1_button)
    }

    game_state.flee_button = Button {
        x = 170,
        y = WINDOW_HEIGHT - 50,
        width = 150,
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

    game_state.ability_1_button = Button {
        x = 10,
        y = WINDOW_HEIGHT - 100,
        width = 150,
        height = 40,
        text = "AB_1",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        right_button = &game_state.ability_2_button,
        down_button = &game_state.ability_3_button
    }
    setup_one_button(&game_state.ability_1_button)
    game_state.ability_1_button.on_click = proc(button : ^Button) {
        use_ability(player, 0)
    }

    game_state.ability_2_button = Button {
        x = 170,
        y = WINDOW_HEIGHT - 100,
        width = 150,
        height = 40,
        text = "AB_2",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        left_button = &game_state.ability_1_button,
        down_button = &game_state.ability_4_button
    }
    setup_one_button(&game_state.ability_2_button)
    game_state.ability_2_button.on_click = proc(button : ^Button) {
        use_ability(player, 1)
    }

    game_state.ability_3_button = Button {
        x = 10,
        y = WINDOW_HEIGHT - 50,
        width = 150,
        height = 40,
        text = "AB_3",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        right_button = &game_state.ability_4_button,
        up_button = &game_state.ability_1_button
    }
    setup_one_button(&game_state.ability_3_button)
    game_state.ability_3_button.on_click = proc(button : ^Button) {
        use_ability(player, 2)
    }

    game_state.ability_4_button = Button {
        x = 170,
        y = WINDOW_HEIGHT - 50,
        width = 150,
        height = 40,
        text = "AB_4",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        left_button = &game_state.ability_3_button,
        up_button = &game_state.ability_2_button
    }
    setup_one_button(&game_state.ability_4_button)
    game_state.ability_4_button.on_click = proc(button : ^Button) {
        use_ability(player, 3)
    }

    game_state.player_head_button = Button {
        x = 10,
        y = WINDOW_HEIGHT / 2,
        width = 250,
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
        width = 250,
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
        width = 250,
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
        width = 250,
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
        width = 250,
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
        width = 250,
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
        game_state.opponent_selected_part = .head
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

update_combat :: proc () {
    game_state.player_hp_slider.percent = player.robot.current_hp / player.robot.hp
    game_state.opponent_hp_slider.percent = game_state.opponent.robot.current_hp / game_state.opponent.robot.hp

    if game_state.is_player_turn {
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
        else if (rl.IsKeyPressed(rl.KeyboardKey.R)) {
            switch game_state.combat_flow {
                case .action:
                case .ability:
                    game_state.combat_flow = .action
                    set_active_button(&game_state.attack_button)
                case .sender:
                    game_state.combat_flow = .ability
                    set_active_button(&game_state.ability_1_button)
                case .receiver:
                    game_state.combat_flow = .sender
                    set_active_button(&game_state.player_head_button)
                case .attack:
            }
        }

        if game_state.combat_flow == .attack {
            apply_damage(game_state.opponent, player, game_state.opponent_selected_part, game_state.selected_part, game_state.selected_ability)
            end_turn()
        }
    }
    else {
        log_error("opponent has ", game_state.opponent.robot.abilities[0])
        log_error("opponent has ", game_state.opponent.robot.abilities[1])
        log_error("opponent has ", game_state.opponent.robot.abilities[2])
        log_error("opponent has ", game_state.opponent.robot.abilities[3])
        apply_damage(player, game_state.opponent, .torso, game_state.opponent.robot.abilities[0].part_type, game_state.opponent.robot.abilities[0])
        end_turn()
    }
}

end_turn :: proc () {
    if game_state.is_player_turn {
        game_state.is_player_turn = false
    }
    else {
        game_state.is_player_turn = true
        set_active_button(&game_state.attack_button)
        game_state.combat_flow = .action
    }
}

draw_combat :: proc () {
    // PLAYER
    game_state.player_hp_slider.draw(&game_state.player_hp_slider)
    rl.DrawText(fmt.ctprint(player.robot.current_hp, "/", player.robot.hp), 10, 40, 20, rl.WHITE)

    rl.DrawTextureV(robot_head_sprite, {300, 300}, evaluate_part_hp(player.robot.head))
    rl.DrawTextureV(robot_torso_sprite, {300, 300}, evaluate_part_hp(player.robot.torso))
    rl.DrawTextureV(robot_left_arm_sprite, {300, 300}, evaluate_part_hp(player.robot.left_arm))
    rl.DrawTextureV(robot_right_arm_sprite, {300, 300}, evaluate_part_hp(player.robot.right_arm))
    rl.DrawTextureV(robot_left_leg_sprite, {300, 300}, evaluate_part_hp(player.robot.left_leg))
    rl.DrawTextureV(robot_right_leg_sprite, {300, 300}, evaluate_part_hp(player.robot.right_leg))

    // OPPONENT
    game_state.opponent_hp_slider.draw(&game_state.opponent_hp_slider)
    rl.DrawText(fmt.ctprint(game_state.opponent.robot.current_hp, "/", game_state.opponent.robot.hp), WINDOW_WIDTH - 160, 40, 20, rl.WHITE)

    rl.DrawTextureV(robot_head_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.head))
    rl.DrawTextureV(robot_torso_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.torso))
    rl.DrawTextureV(robot_left_arm_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.left_arm))
    rl.DrawTextureV(robot_right_arm_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.right_arm))
    rl.DrawTextureV(robot_left_leg_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.left_leg))
    rl.DrawTextureV(robot_right_leg_sprite, {1200, 300}, evaluate_part_hp(game_state.opponent.robot.right_leg))

    switch game_state.combat_flow {
        case .action:
            game_state.attack_button.draw(&game_state.attack_button)
            game_state.flee_button.draw(&game_state.flee_button)
        case .ability:
            game_state.ability_1_button.text = string(fmt.ctprint(player.robot.abilities[0].name))
            game_state.ability_1_button.draw(&game_state.ability_1_button)
            game_state.ability_2_button.text = string(fmt.ctprint(player.robot.abilities[1].name))
            game_state.ability_2_button.draw(&game_state.ability_2_button)
            game_state.ability_3_button.text = string(fmt.ctprint(player.robot.abilities[2].name))
            game_state.ability_3_button.draw(&game_state.ability_3_button)
            game_state.ability_4_button.text = string(fmt.ctprint(player.robot.abilities[3].name))
            game_state.ability_4_button.draw(&game_state.ability_4_button)
        case .sender:
            rl.DrawText(fmt.ctprint("Player Parts"), 10, WINDOW_HEIGHT / 2 - 30, 20, rl.WHITE)
            game_state.player_head_button.text = string(fmt.ctprint(" HEAD (", player.robot.head.current_hp, "/", player.robot.head.hp, ")\n", player.robot.head.percent, "% ->", player.robot.head.attack))
            game_state.player_head_button.draw(&game_state.player_head_button)
            game_state.player_torso_button.text = string(fmt.ctprint(" TORSO (", player.robot.torso.current_hp, "/", player.robot.torso.hp, ")\n", player.robot.torso.percent, "% ->", player.robot.torso.attack))
            game_state.player_torso_button.draw(&game_state.player_torso_button)
            game_state.player_left_arm_button.text = string(fmt.ctprint(" LEFT ARM (", player.robot.left_arm.current_hp, "/", player.robot.left_arm.hp, ")\n", player.robot.left_arm.percent, "% ->", player.robot.left_arm.attack))
            game_state.player_left_arm_button.draw(&game_state.player_left_arm_button)
            game_state.player_right_arm_button.text = string(fmt.ctprint(" RIGHT ARM (", player.robot.right_arm.current_hp, "/", player.robot.right_arm.hp, ")\n", player.robot.right_arm.percent, "% ->", player.robot.right_arm.attack))
            game_state.player_right_arm_button.draw(&game_state.player_right_arm_button)
            game_state.player_left_leg_button.text = string(fmt.ctprint(" LEFT LEG (", player.robot.left_leg.current_hp, "/", player.robot.left_leg.hp, ")\n", player.robot.left_leg.percent, "% ->", player.robot.left_leg.attack))
            game_state.player_left_leg_button.draw(&game_state.player_left_leg_button)
            game_state.player_right_leg_button.text = string(fmt.ctprint(" RIGHT LEG (", player.robot.right_leg.current_hp, "/", player.robot.right_leg.hp, ")\n", player.robot.right_leg.percent, "% ->", player.robot.right_leg.attack))
            game_state.player_right_leg_button.draw(&game_state.player_right_leg_button)
        case .receiver:
            rl.DrawText(fmt.ctprint("Opponent Parts"), WINDOW_WIDTH - 210, WINDOW_HEIGHT / 2 - 30, 20, rl.WHITE)
            game_state.opponent_head_button.draw(&game_state.opponent_head_button)
            game_state.opponent_torso_button.draw(&game_state.opponent_torso_button)
            game_state.opponent_left_arm_button.draw(&game_state.opponent_left_arm_button)
            game_state.opponent_right_arm_button.draw(&game_state.opponent_right_arm_button)
            game_state.opponent_left_leg_button.draw(&game_state.opponent_left_leg_button)
            game_state.opponent_right_leg_button.draw(&game_state.opponent_right_leg_button)
        case .attack:
    }
    
}

use_ability :: proc(entity : ^Entity, index : int) {
    log_error("use ability ", entity.robot.abilities[index])
    if entity.robot.abilities[index].on_self {
        entity.robot.abilities[index].use_ability(entity)
        end_turn()
    }
    else {
        if entity.robot.abilities[index].need_target {
            game_state.combat_flow = .receiver
            game_state.selected_part = entity.robot.abilities[index].part_type
            game_state.selected_ability = entity.robot.abilities[index]
            set_active_button(&game_state.opponent_head_button)
        }
        else {

        }
    }
}

heal_entity :: proc(entity : ^Entity) {
    log_error("heal")
}

apply_boost_damage :: proc(entity : ^Entity, sender_part : Robot_Part_Type, ability : Ability) {
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

    if sender_part_retrieved.percent <= 100 {
        return
    }

    sender_part_retrieved.over_heat += ability.base_heat * (sender_part_retrieved.percent / 100)

    damage := (sender_part_retrieved.percent - 100) * SELF_DAMAGE_RATIO * ability.power

    switch (sender_part) {
        case .head:
            entity.robot.head.current_hp -= damage
            entity.robot.current_hp -= entity.robot.head.hp_consommation * damage
            if entity.robot.head.current_hp < 0 {
                entity.robot.head.current_hp = 0
                leave_combat()
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
        leave_combat()
    }
}

apply_damage :: proc(entity : ^Entity, sender : ^Entity, part : Robot_Part_Type, sender_part : Robot_Part_Type, ability : Ability) {
    damage : f32 = 0

    sender_part_retrieved : Robot_Part

    switch sender_part {
        case .head:
            sender_part_retrieved = sender.robot.head
        case .torso:
            sender_part_retrieved = sender.robot.torso
        case .left_arm:
            sender_part_retrieved = sender.robot.left_arm
        case .right_arm:
            sender_part_retrieved = sender.robot.right_arm
        case .left_leg:
            sender_part_retrieved = sender.robot.left_leg
        case .right_leg:
            sender_part_retrieved = sender.robot.right_leg
    }

    receiver_part_retrieved : Robot_Part

    switch part {
        case .head:
            receiver_part_retrieved = entity.robot.head
        case .torso:
            receiver_part_retrieved = entity.robot.torso
        case .left_arm:
            receiver_part_retrieved = entity.robot.left_arm
        case .right_arm:
            receiver_part_retrieved = entity.robot.right_arm
        case .left_leg:
            receiver_part_retrieved = entity.robot.left_leg
        case .right_leg:
            receiver_part_retrieved = entity.robot.right_leg
    }

    damage = (sender_part_retrieved.attack * (sender_part_retrieved.percent / 100) - receiver_part_retrieved.defense * (receiver_part_retrieved.percent / 100)) * ability.power

    switch (part) {
        case .head:
            entity.robot.head.current_hp -= damage
            entity.robot.current_hp -= entity.robot.head.hp_consommation * damage
            if entity.robot.head.current_hp < 0 {
                entity.robot.head.current_hp = 0
                leave_combat()
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
        leave_combat()
    }

    apply_boost_damage(sender, sender_part, ability)
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