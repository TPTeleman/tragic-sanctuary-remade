extends EffectModifier
class_name DamageDealtModifier

@export var damage: int = 0



func modify(context: Dictionary) -> void:
	if !context.get("direct_damage", true) or !context.has("damage"):
		return
	context["damage_low"] += damage
