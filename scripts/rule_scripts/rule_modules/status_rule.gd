extends EffectRule
class_name StatusRule

@export var status: StatusData
@export var desired_value: bool = true



func validate_target(context: Dictionary) -> bool:
	var target: Actor = get_target(context)
	
	if !is_instance_valid(target) or target.has_status(status.id) != desired_value:
		return false
	return true
