extends EffectRule
class_name StatusRule

@export var status_id: String
@export var desired_value: bool = true



func validate_target(context: Dictionary) -> bool:
	var target: Actor = get_target(context)
	print(target.name)
	
	if !is_instance_valid(target) or target.has_status(status_id) != desired_value:
		return false
	return true
