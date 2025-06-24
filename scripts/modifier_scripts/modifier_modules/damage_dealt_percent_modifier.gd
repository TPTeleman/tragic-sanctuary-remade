extends EffectModifier
class_name DamageDealtPercentModifier

@export var percent: int = 0



func modify(context: Dictionary) -> void:
	if !context.get("direct_damage", true) or !context.has("damage"):
		return
	var percentage := float(percent) / 100
	context["damage_multi"] = context.get("damage_multi", 0)
	context["damage_multi"] += percentage
