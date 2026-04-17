package game

import rl "vendor:raylib"

init_game :: proc () {
    player = entity_create(.player)
    player.cell_x = 1
    player.cell_y = 1
    player.position = {f32(player.cell_x)  * 16, f32(player.cell_y) * 16}
    player.direction = .down

    game_state.screen_type = .game
    game_state.input_type = .game

    game_state.resume_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 150,
        width = 200,
        height = 40,
        text = "RESUME",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        down_button = &game_state.robot_info_button,
    }
    setup_one_button(&game_state.resume_button)
    game_state.resume_button.on_click = proc(button : ^Button) {
        game_state.input_type = .game
    }

    game_state.robot_info_button = Button {
        x = WINDOW_WIDTH - 210,
        y = WINDOW_HEIGHT / 2 + 210,
        width = 200,
        height = 40,
        text = "ROBOT",
        text_size = 20,
        background_color = rl.WHITE,
        active = true,
        up_button = &game_state.resume_button
    }
    setup_one_button(&game_state.robot_info_button)
    game_state.robot_info_button.on_click = proc(button : ^Button) {
        game_state.screen_type = .robot_menu
        init_robot_menu()
    }

    game_state.current_scene = &main_world

}

 post_init_game :: proc () {
    
 }

update_game :: proc () {
    prev_pos := player.position

    player.update(player)

    for d := 0; d < len(game_state.current_scene.doors); d += 1 {
        if collide(player, game_state.current_scene.doors[d]) == 2 {
            player.position = prev_pos
        }
    }

    camera.target = {player.position.x, player.position.y}

    if rl.IsKeyPressed(rl.KeyboardKey.TAB) {
        game_state.input_type = .side_menu
        set_active_button(&game_state.resume_button)
    }

    if game_state.input_type == .side_menu {
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
}

draw_game :: proc () {
    // --- Calcul du scale entier ---
    scaleX := WINDOW_WIDTH / DRAW_WIDTH
    scaleY := WINDOW_HEIGHT / DRAW_HEIGHT

    scale := scaleX
    if scaleY < scale {
        scale = scaleY
    }
    if scale < 1 {
        scale = 1
    }

    // Taille finale affichée
    destWidth  := DRAW_WIDTH * scale
    destHeight := DRAW_HEIGHT * scale

    // Centrage (bandes noires)
    offsetX := (WINDOW_WIDTH  - destWidth)  / 2
    offsetY := (WINDOW_HEIGHT - destHeight) / 2

     // --- Rendu interne ---
    rl.BeginTextureMode(target)
    rl.ClearBackground(rl.BLACK)

    rl.BeginMode2D(camera)

    to_draw : [dynamic]Entity_Draw_Info

    for d in game_state.current_scene.static_entity_draw_infos {
        append(&to_draw, d)
    }

    index := 0
    injected := false
    for d in to_draw {
        if (d.pos.y - 1) * 16 > player.entity_draw_info.pos.y {
            inject_at(&to_draw, index, player.entity_draw_info)
            injected = true
            break
        }
        index += 1
    }

    if !injected {
        append(&to_draw, player.entity_draw_info)
    }

    if len(game_state.current_scene.roof_entity_draw_infos) > 0 {
        for d in game_state.current_scene.roof_entity_draw_infos {
            append(&to_draw, d)
        }    
    }

    for d in to_draw {
        if d.use_sprite {
            rl.DrawTextureV(d.sprite, d.pos + d.offset, d.color)
        }
        else {
            rl.DrawTextureRec(atlas, {d.sprite_pos.x + d.offset.x, d.sprite_pos.y + d.offset.y, d.size.x, d.size.y}, {d.pos.x * 16, d.pos.y * 16}, d.color)
        }
    }

    for d := 0; d < len(game_state.current_scene.doors); d += 1 {
        game_state.current_scene.doors[d].draw(game_state.current_scene.doors[d])
    }

    rl.EndMode2D()

    rl.EndTextureMode()

    // --- Rendu écran ---
    rl.BeginDrawing()
    rl.ClearBackground(rl.DARKGRAY)

    rl.DrawTexturePro(
        target.texture,
        rl.Rectangle{0, 0, DRAW_WIDTH, -DRAW_HEIGHT}, // flip Y
        rl.Rectangle{
            f32(offsetX),
            f32(offsetY),
            f32(destWidth),
            f32(destHeight),
        },
        rl.Vector2{0, 0},
        0,
        rl.WHITE,
    )

    if game_state.input_type == .side_menu {
        game_state.resume_button.draw(&game_state.resume_button)
        game_state.robot_info_button.draw(&game_state.robot_info_button)
    }


    if game_state.transitionning {
        transition()
    }

}