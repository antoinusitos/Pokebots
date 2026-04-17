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

    log_error("init_ressources")
    init_ressources()

    log_error("init_game")
    init_game()

    log_error("init done.")

    post_init_game()

    player.sprite_idle = { 
        { sprite = player_idle_sprite, length = 1}
    }
    player.sprite_walk = { 
        { sprite = player_walk1_sprite, length = 0.15},
        { sprite = player_walk2_sprite, length = 0.15}
    }
    player.sprite_walk_top = { 
        { sprite = player_walk_top1_sprite, length = 0.15},
        { sprite = player_walk_top2_sprite, length = 0.15}
    }
    player.sprite_walk_left = { 
        { sprite = rl.LoadTexture("Assets/player_walk_left1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_left2.png"), length = 0.15}
    }
    player.sprite_walk_right = { 
        { sprite = rl.LoadTexture("Assets/player_walk_right1.png"), length = 0.15},
        { sprite = rl.LoadTexture("Assets/player_walk_right2.png"), length = 0.15}
    }

    //start_combat()

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
        case .robot_menu :
            update_robot_menu()
    }
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
        case .robot_menu :
            draw_robot_menu()
    }
}

draw_Menu :: proc () {
    
}

 init_ressources :: proc() {
    floor_sprite = rl.LoadTexture("Assets/test_floor.png")
    door_sprite = rl.LoadTexture("Assets/door.png")
    atlas = rl.LoadTexture("Assets/atlas.png")

    player_idle_sprite = rl.LoadTexture("Assets/player_idle.png")
    player_walk1_sprite = rl.LoadTexture("Assets/player_walk1.png")
    player_walk2_sprite = rl.LoadTexture("Assets/player_walk2.png")
    player_walk_top1_sprite = rl.LoadTexture("Assets/player_walk_top1.png")
    player_walk_top2_sprite = rl.LoadTexture("Assets/player_walk_top2.png")


    robot_head_sprite = rl.LoadTexture("Assets/Robot_Head.png")
    robot_torso_sprite = rl.LoadTexture("Assets/Robot_Torso.png")
    robot_left_arm_sprite = rl.LoadTexture("Assets/Robot_Left_Arm.png")
    robot_right_arm_sprite = rl.LoadTexture("Assets/Robot_Right_Arm.png")
    robot_left_leg_sprite = rl.LoadTexture("Assets/Robot_Left_Leg.png")
    robot_right_leg_sprite = rl.LoadTexture("Assets/Robot_Right_Leg.png")
   
    load_level("Assets/lvl_intro.tmj", &main_world)
    load_level("Assets/house1.tmj", &house_1)
 }