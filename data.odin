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

arm_1 := Robot_Part {
name = "arm_1",
capacity = 10,
percent = 100,
hp = 25,
current_hp = 25,
hp_consommation = 0.8,
attack = 10,
defense = 5,
speed = 5
}

arm_2 := Robot_Part {
name = "arm_2",
capacity = 14,
percent = 100,
hp = 22,
current_hp = 22,
hp_consommation = 1.0,
attack = 15,
defense = 3,
speed = 6
}

arm_3 := Robot_Part {
name = "arm_3",
capacity = 9,
percent = 100,
hp = 20,
current_hp = 20,
hp_consommation = 0.7,
attack = 8,
defense = 4,
speed = 10
}

arm_4 := Robot_Part {
name = "arm_4",
capacity = 11,
percent = 100,
hp = 30,
current_hp = 30,
hp_consommation = 0.6,
attack = 6,
defense = 10,
speed = 3
}

arm_5 := Robot_Part {
name = "arm_5",
capacity = 12,
percent = 100,
hp = 24,
current_hp = 24,
hp_consommation = 0.8,
attack = 9,
defense = 6,
speed = 6
}

leg_1 := Robot_Part {
name = "leg_1",
capacity = 10,
percent = 100,
hp = 30,
current_hp = 30,
hp_consommation = 0.6,
attack = 0,
defense = 6,
speed = 10
}

leg_2 := Robot_Part {
name = "leg_2",
capacity = 14,
percent = 100,
hp = 40,
current_hp = 40,
hp_consommation = 0.5,
attack = 0,
defense = 12,
speed = 6
}

leg_3 := Robot_Part {
name = "leg_3",
capacity = 12,
percent = 100,
hp = 25,
current_hp = 25,
hp_consommation = 0.7,
attack = 0,
defense = 4,
speed = 15
}

leg_4 := Robot_Part {
name = "leg_4",
capacity = 11,
percent = 100,
hp = 35,
current_hp = 35,
hp_consommation = 0.5,
attack = 0,
defense = 10,
speed = 8
}

leg_5 := Robot_Part {
name = "leg_5",
capacity = 10,
percent = 100,
hp = 30,
current_hp = 30,
hp_consommation = 0.6,
attack = 0,
defense = 7,
speed = 9
}

head_1 := Robot_Part {
name = "head_1",
capacity = 8,
percent = 100,
hp = 20,
current_hp = 20,
hp_consommation = 1.5,
attack = 0,
defense = 8,
speed = 0
}

head_2 := Robot_Part {
name = "head_2",
capacity = 10,
percent = 100,
hp = 18,
current_hp = 18,
hp_consommation = 1.7,
attack = 0,
defense = 6,
speed = 0
}

head_3 := Robot_Part {
name = "head_3",
capacity = 12,
percent = 100,
hp = 28,
current_hp = 28,
hp_consommation = 1.3,
attack = 0,
defense = 12,
speed = 0
}

head_4 := Robot_Part {
name = "head_4",
capacity = 9,
percent = 100,
hp = 22,
current_hp = 22,
hp_consommation = 1.4,
attack = 0,
defense = 9,
speed = 0
}

head_5 := Robot_Part {
name = "head_5",
capacity = 11,
percent = 100,
hp = 20,
current_hp = 20,
hp_consommation = 1.5,
attack = 0,
defense = 8,
speed = 0
}

torso_1 := Robot_Part {
name = "torso_1",
capacity = 15,
percent = 100,
hp = 60,
current_hp = 60,
hp_consommation = 1.0,
attack = 0,
defense = 10,
speed = 0
}

torso_2 := Robot_Part {
name = "torso_2",
capacity = 20,
percent = 100,
hp = 80,
current_hp = 80,
hp_consommation = 0.8,
attack = 0,
defense = 15,
speed = 0
}

torso_3 := Robot_Part {
name = "torso_3",
capacity = 10,
percent = 100,
hp = 45,
current_hp = 45,
hp_consommation = 1.2,
attack = 0,
defense = 6,
speed = 0
}

torso_4 := Robot_Part {
name = "torso_4",
capacity = 16,
percent = 100,
hp = 65,
current_hp = 65,
hp_consommation = 1.0,
attack = 0,
defense = 9,
speed = 0
}

torso_5 := Robot_Part {
name = "torso_5",
capacity = 14,
percent = 100,
hp = 55,
current_hp = 55,
hp_consommation = 1.1,
attack = 0,
defense = 10,
speed = 0
}