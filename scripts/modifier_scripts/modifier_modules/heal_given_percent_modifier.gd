extends EffectModifier
class_name HealGivenPercentModifier

@export var percent: int = 0



func modify(context: Dictionary) -> void:
	if !context.get("direct_heal", true) or !context.has("heal"):
		return
	var percentage := float(percent) / 100
	context["heal_multi"] = context.get("heal_multi", 0)
	context["heal_multi"] += percentage
