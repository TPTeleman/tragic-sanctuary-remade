extends EffectRule
class_name SkillMatchRule

@export var skill_id: String
@export var same: bool = true



func validate_target(context: Dictionary) -> bool:
	var context_skill_id = context.get("skill_id", "")
	#print("same: ", same, " | ", skill_id, " | ", context_skill_id," = ",skill_id == context_skill_id and same)
	
	if same:
		if skill_id != context_skill_id:
			return false
	else:
		if skill_id == context_skill_id:
			return false
	
	return true
