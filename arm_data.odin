package game

arm_1 := Robot_Part {
name = "arm_1",
capacity = 10,
percent = 100,
hp = 25,
current_hp = 25,
hp_consommation = 0.8,
attack = 10,
defense = 5,
speed = 5,
abilities = {Strike, Light_Shot}
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
speed = 6,
abilities = {Heavy_Strike, Charge}
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
speed = 10,
abilities = {Double_Strike, Quick_Attack}
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
speed = 3,
abilities = {Guard, Counter}
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
speed = 6,
abilities = {Precision_Shot, Unbalance}
}