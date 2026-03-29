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

    door_test = entity_create(.door)
    door_test.position = {3 * door_test.sprite_size, -3 * door_test.sprite_size}
    door_test.target_x = 5
    door_test.target_y = -33

    door_test_2 = entity_create(.door)
    door_test_2.position = {5 * door_test_2.sprite_size, -34 * door_test_2.sprite_size}
    door_test_2.target_x = 3
    door_test_2.target_y = -4

    floor_sprite = rl.LoadTexture("Assets/test_floor.png")
    door_sprite = rl.LoadTexture("Assets/door.png")

	lines := read_map("Assets/LVL0.txt")

    log_error("init done.")

    player = entity_create(.player)
    player.position.x = 0
    player.position.y = 0
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

    game_state.world_width = 20
    game_state.world_height = 10

    for x := 0; x < game_state.world_width; x += 1 {
        for y := 0; y < game_state.world_height; y += 1 {
            append(&game_state.cells, Cell{cell_x = x, cell_y = y})
        }
    }

    game_state.screen_type = .game
    game_state.input_type = .game

	for !game_state.want_to_quit && !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		update()

        draw()
	}

	rl.CloseWindow()
}

update :: proc() {
	//log_error("update")

	prev_pos := player.position

    player.update(player)

    if collide(player, door_test) == 2 {
        player.position = prev_pos
    }
    if collide(player, door_test_2) == 2 {
        player.position = prev_pos
    } 

	camera.target = snap({player.position.x, -player.position.y})
}

draw :: proc() {
	//log_error("draw")

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

    // floor
    for x := 0; x < game_state.world_width; x += 1 {
    	for y := 0; y < game_state.world_height; y += 1 {
    		rl.DrawTextureV(floor_sprite, {f32(x * 16), f32(y * 16)}, rl.WHITE)
    	}
    }

    // house interior
    red := true
    for x := 0; x < 10; x += 1 {
        for y := 25; y < 35; y += 1 {
            rl.DrawRectangle(i32(x * 16), i32(y * 16), 16, 16, red ? rl.RED : rl.GREEN)
            red = !red
        }
        red = !red
    }

    door_test.draw(door_test)
    door_test_2.draw(door_test_2)
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

    rl.EndDrawing()
}