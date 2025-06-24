extends Resource
class_name StatusModifier

@export var effect_rule: EffectRule



func should_run(context: Dictionary) -> bool:
	if effect_rule != null and !effect_rule.validate_target(context):
		return false
	return true


func apply(_context: Dictionary) -> void:
	pass
