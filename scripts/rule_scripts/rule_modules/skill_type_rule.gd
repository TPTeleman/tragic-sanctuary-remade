extends EffectRule
class_name SkillTypeRule

@export_enum("None", "Melee", "Ranged", "Mystical") var skill_type: String = "None"
@export var same: bool = true



func validate_target(context: Dictionary) -> bool:
	if (same and skill_type != context.get("skill_type", "")) or (!same and skill_type == context.get("skill_type", "")):
		return false
	return true
