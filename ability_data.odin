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
	need_target = true,
	on_self = false,
	power = 1,
}

Light_Shot := Ability {
	name = "Light Shot",
	need_target = true,
	on_self = false,
	power = 0.9,
}

Heavy_Strike := Ability {
	name = "Heavy Strike",
	need_target = true,
	on_self = false,
	power = 1.5,
}

Charge := Ability {
	name = "Charge",
	need_target = false,
	on_self = true,
	power = 1.8,
}

Double_Strike := Ability {
	name = "Double Strike",
	need_target = true,
	on_self = false,
	power = 0.75, // x2
}

Quick_Attack := Ability {
	name = "Quick Attack",
	need_target = true,
	on_self = false,
	power = 0.8,
}

Precision_Shot := Ability {
	name = "Precision Shot",
	need_target = true,
	on_self = false,
	power = 1.1,
}

Guard := Ability {
	name = "Guard",
	need_target = false,
	on_self = true,
	power = 0.5,
}

Shield := Ability {
	name = "Shield",
	need_target = false,
	on_self = true,
	power = 0.7,
}

Protect := Ability {
	name = "Protect",
	need_target = true,
	on_self = true,
	power = 1,
}

Anchor := Ability {
	name = "Anchor",
	need_target = false,
	on_self = true,
	power = 0.6,
}

Counter := Ability {
	name = "Counter",
	need_target = false,
	on_self = false,
	power = 0.75,
}

Sprint := Ability {
	name = "Sprint",
	need_target = false,
	on_self = true,
	use_ability = proc(entity : ^Entity) {
		heal_entity(entity)
	},
	power = 1.2,
}

Dash := Ability {
	name = "Dash",
	need_target = false,
	on_self = true,
	power = 1,
}

Dodge := Ability {
	name = "Dodge",
	need_target = false,
	on_self = true,
	power = 0.5,
}

Quick_Dodge := Ability {
	name = "Quick Dodge",
	need_target = false,
	on_self = true,
	power = 0.7,
}

Reposition := Ability {
	name = "Reposition",
	need_target = false,
	on_self = true,
	power = 1,
}

Scan := Ability {
	name = "Scan",
	need_target = false,
	on_self = false,
	power = 0,
}

Targeting := Ability {
	name = "Targeting",
	need_target = false,
	on_self = true,
	power = 1.2,
}

Critical_Targeting := Ability {
	name = "Critical Targeting",
	need_target = false,
	on_self = true,
	power = 20,
}

Weakness_Scan := Ability {
	name = "Weakness Scan",
	need_target = false,
	on_self = true,
	power = 1.25,
}

Unbalance := Ability {
	name = "Unbalance",
	need_target = false,
	on_self = true,
	power = -30,
}

Hack := Ability {
	name = "Hack",
	need_target = false,
	on_self = false,
	power = -25,
}

Jam := Ability {
	name = "Jam",
	need_target = false,
	on_self = false,
	power = -30,
}

Stabilize := Ability {
	name = "Stabilize",
	need_target = false,
	on_self = true,
	power = 0,
}

Resistance := Ability {
	name = "Resistance",
	need_target = false,
	on_self = true,
	power = -50,
}

Terrain_Scan := Ability {
	name = "Terrain Scan",
	need_target = false,
	on_self = true,
	power = 15,
}

Repair := Ability {
	name = "Repair",
	need_target = true,
	on_self = true,
	power = 15,
}

Energy_Boost := Ability {
	name = "Energy Boost",
	need_target = false,
	on_self = true,
	power = 20,
}

Recharge := Ability {
	name = "Recharge",
	need_target = false,
	on_self = true,
	power = 0,
}

Redistribution := Ability {
	name = "Redistribution",
	need_target = false,
	on_self = true,
	power = 0,
}

Overload := Ability {
	name = "Overload",
	need_target = false,
	on_self = true,
	power = 30,
}

Lighten := Ability {
	name = "Lighten",
	need_target = false,
	on_self = true,
	power = 20,
}

Fortify := Ability {
	name = "Fortify",
	need_target = false,
	on_self = true,
	power = 25,
}

Auto_Repair := Ability {
	name = "Auto-Repair",
	need_target = false,
	on_self = true,
	power = 5,
}

Last_Stand := Ability {
	name = "Last Stand",
	need_target = false,
	on_self = true,
	power = 1,
}

Taunt := Ability {
	name = "Taunt",
	need_target = false,
	on_self = true,
	power = 0,
}