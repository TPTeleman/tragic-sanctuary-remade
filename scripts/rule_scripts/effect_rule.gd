extends Resource
class_name EffectRule

@export_enum("Target", "Performer") var target_type: int = 0



func get_target(context: Dictionary) -> Actor:
	var performer: Actor = context.get("performer")
	var target: Actor = context.get("target")
	return target if target_type == 0 else performer


func validate_target(_context: Dictionary) -> bool:
	return true


func get_description() -> String:
	return "[Rule]"
