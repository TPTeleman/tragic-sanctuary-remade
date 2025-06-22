extends BaseWindow
class_name CombatWindow

@export var round_lbl: Label
@export var FT_Control: Control

@export_category("Components")
@export_group("Caster Box")
@export var caster_lbl: Label

@onready var ability_info: RichTextLabel = %Ability_Info

@export_group("Ability Box")
@export var ability_name_lbl: Label
@export var ability_type_lbl: Label
@export var ability_cast_lbl: Label
@export var ability_target_lbl: Label

@onready var action_bar: Control = %Action_Bar
@onready var ability_container: Control = %Ability_Container
@onready var info_box: Control = %Info_Box
@onready var hover_box: Control = %Hover_Box
@onready var ability_box: Control = %Ability_Box

@export_group("Target Box")
@export var target_lbl: Label
@export var species_lbl: Label
@export var speed_lbl: Label
@export var health_lbl: Label

@export_group("Turn Order")
@onready var turn_control: Control = %Turn_Control
@onready var turn_box: Control = %Turn_Box

@onready var health_bar: HealthBar = %Target_Bar
@onready var target_box: Control = %Target_Box
@onready var stat_box: Control = %Stat_Box



func _ready() -> void:
	action_bar.hide()
	#set_skill_info(null)
	
	ActorEvents.actor_mouse_entered.connect(set_target_info)
	
	CombatEvents.turn_started.connect(set_actor_display)
	
	SkillEvents.skill_selected.connect(set_skill_info)
	#CombatEvents.turn_ended.connect(hide_actor_display)
	
	for control: SkillButton in ability_box.get_children():
		control.on_hover.connect(_on_skill_hovered)
		control.on_unhover.connect(_on_skill_unhovered)
		control.on_pressed.connect(_on_skill_pressed)


func set_actor_display(actor: Actor) -> void:
	if is_instance_valid(actor):
		action_bar.show()
		ability_container.show()
		set_skill_info(null)
		
		var stats: EntityStats = actor.stats
		var skills: Array[CombatSkill] = stats.get_skill_set()
		
		for i in ability_box.get_child_count():
			var control: SkillButton = ability_box.get_child(i)
			
			if i < len(skills):
				control.visible = true
				control.set_button_skill(skills[i])
			elif i < 5:
				control.visible = false
				control.skill = null
			if i == 5:
				control.visible = true
				control.set_button_skill(stats.move_skill)
			if i == 6:
				control.visible = true
				control.set_button_skill(stats.pass_skill)
		
		caster_lbl.text = stats.name


func hide_actor_display() -> void:
	ability_container.hide()
	
	for btn: SkillButton in ability_box.get_children():
		btn.visible = false
		btn.skill = null
	caster_lbl.text = ""


func set_target_info(target: Actor) -> void:
	if is_instance_valid(target):
		target_box.show()
		var stats: EntityStats = target.stats
		target_lbl.text = stats.name
		speed_lbl.text = str(stats.speed)
		health_lbl.text = "%s/%s" % [stats.cur_hp, stats.max_hp]
		health_bar.set_health(target.get_health_percent())


func set_skill_info(skill: CombatSkill) -> void:
	if skill == null:
		ability_name_lbl.text = ""
		ability_type_lbl.text = ""
		ability_cast_lbl.text = ""
		ability_target_lbl.text = ""
		ability_info.clear()
		return

	ability_name_lbl.text = skill.name
	ability_type_lbl.text = skill.skill_type
	#ability_cast_lbl.text = "Ranks: " + str(skill.get_valid_cast_ranks())
	#ability_target_lbl.text = "Targets: " + str(skill.get_valid_target_ranks())
	#var desc := skill.get_rich_description()
	#ability_info.bbcode_text = desc if desc != "" else " "

#region Ability Button

func _on_skill_hovered(control: SkillButton) -> void:
	if control.skill == null:
		return
	#SkillEvents.ability_hovered.emit(control.skill)


func _on_skill_unhovered(control: SkillButton) -> void:
	if control.skill == null:
		return
	#SkillEvents.ability_unhovered.emit(control.skill)


func _on_skill_pressed(control: SkillButton) -> void:
	if control.skill == null:
		return
	SkillEvents.skill_selected.emit(control.skill)
	#set_ability_info(control.skill)
	#set_ability_hover(null)

#endregion
