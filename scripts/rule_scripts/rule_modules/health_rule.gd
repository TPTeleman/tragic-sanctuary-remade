extends EffectRule
class_name HealthRule

@export_enum("Above", "Below") var rule_type: int = 0
@export_range(0, 100, 1) var percentage: float = 50



func validate_target(context: Dictionary) -> bool:
	var target: Actor = get_target(context)
	var health_percentage: int = target.get_health_percent()
	
	if rule_type == 0:
		if health_percentage < percentage:
			return false
	else:
		if health_percentage > percentage:
			return false
	
	return true
