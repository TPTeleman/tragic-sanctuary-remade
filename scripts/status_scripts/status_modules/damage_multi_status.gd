extends StatusModifier
class_name DamageMultiStatus

const KEY : String = "damage_multi"

@export var amount: int = 0



func apply(context: Dictionary) -> void:
	for effect in context["effect_data"]:
		var effect_data: Dictionary = context["effect_data"][effect]
		if effect_data.has("damage") and effect_data.get("direct_damage", false):
			effect_data[KEY] = effect_data.get(KEY, 0)
			effect_data[KEY] += float(amount) / 100
