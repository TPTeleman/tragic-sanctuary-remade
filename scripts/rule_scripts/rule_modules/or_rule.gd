extends EffectRule
class_name OrRule

@export var rules: Array[EffectRule]
@export var wants_not: bool = false


func validate_target(context: Dictionary) -> bool:
	for rule in rules:
		var result := rule.validate_target(context)
		if wants_not:
			result = !result
		if result:
			return true
	return false
