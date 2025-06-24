extends StatusModifier
class_name HealModStatus

const KEY : String = "heal_bonus"

@export var amount: int = 0



func apply(context: Dictionary) -> void:
	for effect in context["effect_data"]:
		var effect_data: Dictionary = context["effect_data"][effect]
		if effect_data.has("heal") and effect_data.get("direct_heal", false):
			effect_data[KEY] = effect_data.get(KEY, 0)
			effect_data[KEY] += amount
