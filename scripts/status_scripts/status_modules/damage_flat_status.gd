extends StatusModifier
class_name DamageFlatStatus

const KEY_L : String = "damage_low"
const KEY_H : String = "damage_high"

@export var amount_l: int = 0
@export var amount_h: int = 0



func apply(context: Dictionary) -> void:
	for effect in context["effect_data"]:
		var effect_data: Dictionary = context["effect_data"][effect]
		if effect_data.has("damage") and effect_data.get("direct_damage", false):
			effect_data[KEY_L] = effect_data.get(KEY_L, 0)
			effect_data[KEY_L] += amount_l
			effect_data[KEY_H] = effect_data.get(KEY_H, 0)
			effect_data[KEY_H] += amount_h
	#print(context["effect_data"])
