extends StatusModifier
class_name CombatStatAdd

@export_enum("health","speed","acc","crit","dodge","prot","bleed_res","blight_res",
"burn_res","stun_res","move_res","death_res") var sub_stat: String
@export var amount: int = 0
