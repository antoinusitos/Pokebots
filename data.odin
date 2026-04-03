package game

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080

DRAW_WIDTH :: 320 //20
DRAW_HEIGHT :: 180 // 11

ATLAS_WIDTH :: 64
ATLAS_HEIGHT :: 64

DOOR_SPRITE_INDEX :: 1506
MAT_LEFT_SPRITE_INDEX :: 654
MAT_RIGHT_SPRITE_INDEX :: 653

MAX_ENTITIES :: 1024

TRANSITION_TIME :: 1.0

battery_test :: Robot_Part { 
	name = "battery_test",
	capacity = 400,
	percent = 100,
}

head_test := Robot_Part { 
	name = "head_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 1.5,
	damage = 0
}

torso_test := Robot_Part { 
	name = "torso_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 1.2,
	damage = 0
}

left_arm_test := Robot_Part { 
	name = "left_arm_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 1,
	damage = 30
}

right_arm_test := Robot_Part { 
	name = "right_arm_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 1,
	damage = 30
}

left_leg_test := Robot_Part { 
	name = "left_leg_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 0.8,
	damage = 10
}

right_leg_test := Robot_Part { 
	name = "right_leg_test",
	capacity = 80,
	percent = 100,
	hp = 50,
	current_hp = 50,
	hp_consommation = 0.8,
	damage = 10
}