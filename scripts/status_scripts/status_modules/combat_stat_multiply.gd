extends StatusModifier
class_name CombatStatMultiply

@export_enum("health","death","speed","acc","crit","dmg_l","dmg_h","dodge",
"prot","bleed_res","blight_res","burn_res","stun_res","move_res") var sub_stat: String
@export var amount: int = 0
