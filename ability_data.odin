package game

/* 
⚔️Attack
Strike → attaque simple
Light Shot → attaque à distance
Heavy Strike → gros dégâts
Charge → dégâts ↑, précision ↓
Double Strike → 2 hits
Quick Attack → priorité
Precision Shot → ignore DEF partielle

🛡️ Defense
Guard → réduit dégâts reçus
Shield → absorbe dégâts
Protect → protège une pièce
Anchor → réduit dégâts subis
Counter → renvoi une partie des degats

⚡ Mobility / Speed
Sprint → initiative ↑
Dash → priorité + vitesse
Dodge → chance d’éviter
Quick Dodge → forte esquive
Reposition → évite attaque

🧠 Support / Control
Scan → affiche stats ennemies
Targeting → précision ↑
Critical Targeting → crit ↑
Weakness Scan → dégâts ↑
Unbalance → baisse DEF
Hack → baisse DEF ennemie
Jam → baisse précision ennemie
Stabilize → réduit malus
Resistance → réduit critiques
Terrain Scan → précision ↑

🔋 System / Energy
Repair → soigne
Energy Boost → % max ↑ temporaire
Recharge → réduit coût %
Redistribution → modifie % gratuitement
Overload → boost fort + dégâts
Lighten → SPD ↑
Fortify → DEF ↑
Auto-Repair → regen
Last Stand → évite KO une fois
Taunt → attire attaques
*/


Strike := Ability {
	name = "Strike",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 1,
	base_heat = 10,
}

Light_Shot := Ability {
	name = "Light Shot",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 0.9,
	base_heat = 8,
}

Heavy_Strike := Ability {
	name = "Heavy Strike",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 1.5,
	base_heat = 15,
}

Charge := Ability {
	name = "Charge",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1.8,
	base_heat = 20,
}

Double_Strike := Ability {
	name = "Double Strike",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 0.75, // x2
	base_heat = 12,
}

Quick_Attack := Ability {
	name = "Quick Attack",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 0.8,
	base_heat = 9,
}

Precision_Shot := Ability {
	name = "Precision Shot",
	desc = "attaque simple",
	need_target = true,
	on_self = false,
	power = 1.1,
	base_heat = 11,
}

Guard := Ability {
	name = "Guard",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0.5,
	base_heat = 8,
}

Shield := Ability {
	name = "Shield",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0.7,
	base_heat = 12,
}

Protect := Ability {
	name = "Protect",
	desc = "attaque simple",
	need_target = true,
	on_self = true,
	power = 1,
	base_heat = 18,
}

Anchor := Ability {
	name = "Anchor",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0.6,
	base_heat = 10,
}

Counter := Ability {
	name = "Counter",
	desc = "attaque simple",
	need_target = false,
	on_self = false,
	power = 0.75,
	base_heat = 15,
}

Sprint := Ability {
	name = "Sprint",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	use_ability = proc(entity : ^Entity) {
		heal_entity(entity)
	},
	power = 1.2,
	base_heat = 0,
}

Dash := Ability {
	name = "Dash",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1,
	base_heat = 10,
}

Dodge := Ability {
	name = "Dodge",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0.5,
	base_heat = 10,
}

Quick_Dodge := Ability {
	name = "Quick Dodge",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0.7,
	base_heat = 14,
}

Reposition := Ability {
	name = "Reposition",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1,
	base_heat = 0,
}

Scan := Ability {
	name = "Scan",
	desc = "attaque simple",
	need_target = false,
	on_self = false,
	power = 0,
	base_heat = 0,
}

Targeting := Ability {
	name = "Targeting",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1.2,
	base_heat = 0,
}

Critical_Targeting := Ability {
	name = "Critical Targeting",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 20,
	base_heat = 5,
}

Weakness_Scan := Ability {
	name = "Weakness Scan",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1.25,
	base_heat = 5,
}

Unbalance := Ability {
	name = "Unbalance",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = -30,
	base_heat = 10,
}

Hack := Ability {
	name = "Hack",
	desc = "attaque simple",
	need_target = false,
	on_self = false,
	power = -25,
	base_heat = 0,
}

Jam := Ability {
	name = "Jam",
	desc = "attaque simple",
	need_target = false,
	on_self = false,
	power = -30,
	base_heat = 0,
}

Stabilize := Ability {
	name = "Stabilize",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0,
	base_heat = 0,
}

Resistance := Ability {
	name = "Resistance",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = -50,
	base_heat = 0,
}

Terrain_Scan := Ability {
	name = "Terrain Scan",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 15,
	base_heat = 0,
}

Repair := Ability {
	name = "Repair",
	desc = "attaque simple",
	need_target = true,
	on_self = true,
	power = 15,
	base_heat = 0,
}

Energy_Boost := Ability {
	name = "Energy Boost",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 20,
	base_heat = 0,
}

Recharge := Ability {
	name = "Recharge",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0,
	base_heat = 0,
}

Redistribution := Ability {
	name = "Redistribution",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0,
	base_heat = 0,
}

Overload := Ability {
	name = "Overload",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 30,
	base_heat = 15,
}

Lighten := Ability {
	name = "Lighten",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 20,
	base_heat = 0,
}

Fortify := Ability {
	name = "Fortify",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 25,
	base_heat = 0,
}

Auto_Repair := Ability {
	name = "Auto-Repair",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 5,
	base_heat = 0,
}

Last_Stand := Ability {
	name = "Last Stand",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 1,
	base_heat = 0,
}

Taunt := Ability {
	name = "Taunt",
	desc = "attaque simple",
	need_target = false,
	on_self = true,
	power = 0,
	base_heat = 0,
}