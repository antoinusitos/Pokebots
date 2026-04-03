package game

import "core:fmt"
import rl "vendor:raylib"

start_combat :: proc() {
    game_state.opponent = entity_create(.npc)

    game_state.screen_type = .combat
    game_state.input_type = .combat

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

    game_state.player_hp_slider.percent = player.robot.current_hp / player.robot.hp

    game_state.opponent.robot.left_arm.current_hp -= 30
    game_state.opponent.robot.current_hp -= game_state.opponent.robot.left_arm.hp_consommation * 30
    game_state.opponent_hp_slider.percent = game_state.opponent.robot.current_hp / game_state.opponent.robot.hp
}

update_combat :: proc () {
    
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