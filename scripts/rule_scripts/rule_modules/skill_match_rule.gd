extends EffectRule
class_name SkillMatchRule

@export var skill_id: String
@export var same: bool = true



func validate_target(context: Dictionary) -> bool:
	if (same and skill_id != context.get("skill_id", "")) or (!same and skill_id == context.get("skill_id", "")):
		return false
	return true
