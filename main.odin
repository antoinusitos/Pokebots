package game

import "."
import "core:log"
import "core:slice"
import "core:math"
import "core:math/rand"
import "core:fmt"
import rl "vendor:raylib"
import "core:strings"
import "core:strconv"

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Pokebots")
	//rl.ToggleBorderlessWindowed()

	target = rl.LoadRenderTexture(DRAW_WIDTH, DRAW_HEIGHT)
    defer rl.UnloadRenderTexture(target)

    // IMPORTANT : pixel perfect
    rl.SetTextureFilter(target.texture, rl.TextureFilter.POINT)

	camera = rl.Camera2D {
	    offset = {DRAW_WIDTH / 2, DRAW_HEIGHT / 2},
	    target = {0, 0},
	    rotation = 0,
	    zoom = 1
	}

    floor_sprite = rl.LoadTexture("Assets/test_floor.png")
    door_sprite = rl.LoadTexture("Assets/door.png")
    atlas = rl.LoadTexture("Assets/atlas.png")

    robot_head_sprite = rl.LoadTexture("Assets/Robot_Head.png")
    robot_torso_sprite = rl.LoadTexture("Assets/Robot_Torso.png")
    robot_left_arm_sprite = rl.LoadTexture("Assets/Robot_Left_Arm.png")
    robot_right_arm_sprite = rl.LoadTexture("Assets/Robot_Right_Arm.png")
    robot_left_leg_sprite = rl.LoadTexture("Assets/Robot_Left_Leg.png")
    robot_right_leg_sprite = rl.LoadTexture("Assets/Robot_Right_Leg.png")

    head_test.sprite = robot_head_sprite
    torso_test.sprite = robot_torso_sprite
    left_arm_test.sprite = robot_left_arm_sprite
    right_arm_test.sprite = robot_right_arm_sprite
    left_leg_test.sprite = robot_left_leg_sprite
    right_leg_test.sprite = robot_right_leg_sprite
   
    load_level("Assets/lvl_intro.tmj", &main_world)
    load_level("Assets/house1.tmj", &house_1)

    game_state.current_scene = &main_world

    log_error("init done.")

    player = entity_create(.player)
    player.cell_x = 1
    player.cell_y = 1
    player.position = {f32(player.cell_x)  * 16, f32(player.cell_y) * 16}
    player.direction = .down

    player.sprite_idle = { 
        { sprite = rl.LoadTexture("Assets/player_idle.png"), length = 1}
    }
    player.sprite_walk = { 
        { sprite = rl.LoadTexture("Assets/player_walk1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk2.png"), length = 0.15}
    }
    player.sprite_walk_top = { 
        { sprite = rl.LoadTexture("Assets/player_walk_top1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_top2.png"), length = 0.15}
    }
    player.sprite_walk_left = { 
        { sprite = rl.LoadTexture("Assets/player_walk_left1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_left2.png"), length = 0.15}
    }
    player.sprite_walk_right = { 
        { sprite = rl.LoadTexture("Assets/player_walk_right1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_right2.png"), length = 0.15}
    }

    game_state.screen_type = .game

    start_combat()

	for !game_state.want_to_quit && !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		update()

        draw()

        rl.EndDrawing()
	}

	rl.CloseWindow()
}

update :: proc() {
	//log_error("update")

    switch(game_state.screen_type) {
        case .game :
            update_game()
        case .combat :
            update_combat()
        case .menu :
            update_Menu()
    }
}

update_game :: proc () {
    prev_pos := player.position

    player.update(player)

    for d := 0; d < len(game_state.current_scene.doors); d += 1 {
        if collide(player, game_state.current_scene.doors[d]) == 2 {
            player.position = prev_pos
        }
    }

    camera.target = snap({player.position.x, player.position.y})
}

update_Menu :: proc () {
    
}

draw :: proc() {
	//log_error("draw")
    switch(game_state.screen_type) {
        case .game :
            draw_game()
        case .combat :
            draw_combat()
        case .menu :
            draw_Menu()
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

    index_cell := 0
    for y := 0; y < game_state.current_scene.size_y; y += 1 {
        for x := 0; x < game_state.current_scene.size_x; x += 1 {
            rl.DrawTextureRec(atlas, {game_state.current_scene.cells[index_cell].sprite_pos_x, game_state.current_scene.cells[index_cell].sprite_pos_y, 16, 16}, {f32(game_state.current_scene.cells[index_cell].cell_x * 16), f32(game_state.current_scene.cells[index_cell].cell_y * 16)}, rl.WHITE)
            
            if game_state.current_scene.cells[index_cell].foreground_sprite_index != -1 {
                rl.DrawTextureRec(atlas, {game_state.current_scene.cells[index_cell].foreground_sprite_pos_x, game_state.current_scene.cells[index_cell].foreground_sprite_pos_y, 16, 16}, {f32(game_state.current_scene.cells[index_cell].cell_x * 16), f32(game_state.current_scene.cells[index_cell].cell_y * 16)}, rl.WHITE)
            }

            index_cell += 1
        }
    }

    for d := 0; d < len(game_state.current_scene.doors); d += 1 {
        game_state.current_scene.doors[d].draw(game_state.current_scene.doors[d])
    }

    player.draw(player)

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

    if game_state.transitionning {
        transition()
    }

}

draw_Menu :: proc () {
    
}