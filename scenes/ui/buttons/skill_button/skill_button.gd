extends GameButton
class_name SkillButton

var skill: CombatSkill

@onready var icon: TextureRect = %Icon_Rect


func set_button_skill(new_skill: CombatSkill) -> void:
	skill = new_skill
	icon.texture = skill.icon
