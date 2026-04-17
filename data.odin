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

SELF_DAMAGE_RATIO :: 0.2
// SelfDamage = ( % − 100 ) × SELF_DAMAGE_RATIO × puissance capacité
// Speed robot = sum (speed × % × hp restant / hp max)

battery_1 := Robot_Part { 
	name = "battery_1",
	capacity = 100,
	percent = 100,
}

battery_2 := Robot_Part { 
	name = "battery_2",
	capacity = 100,
	percent = 100,
}

battery_3 := Robot_Part { 
	name = "battery_3",
	capacity = 100,
	percent = 100,
}