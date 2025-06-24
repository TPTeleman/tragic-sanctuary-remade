extends EffectModifier
class_name HealGivenModifier

@export var heal: int = 0



func modify(context: Dictionary) -> void:
	if !context.get("direct_heal", true) or !context.has("heal"):
		return
	context["heal"] += heal
