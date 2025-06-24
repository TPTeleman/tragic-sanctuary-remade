extends EffectRule
class_name AndRule

@export var rules : Array[EffectRule]
@export var wants_not : bool = false



func validate_target(context: Dictionary) -> bool:
	for rule in rules:
		if wants_not:
			if rule.validate_target(context):
				return false 
		else:
			if !rule.validate_target(context):
				return false
	return true
