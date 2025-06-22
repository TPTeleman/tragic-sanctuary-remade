extends Node
class_name ActionManager

signal update_actor_marker(actor: Actor, marker: String, value: bool)
signal update_markers(actors: Array[Actor], marker: String, value: bool)
signal update_all_markers(actors: Array[Actor], value: bool)

var selected_skill : CombatSkill = null
var current_actor : Actor = null
var ally_group : Array[Actor] = []
var enemy_group : Array[Actor] = []

var valid_targets : Array[Actor] = []
var selected_target : Array[Actor] = []

var target : Actor = null
var can_act : bool = false



func _ready() -> void:
	ActorEvents.actor_mouse_clicked.connect(_on_actor_clicked)
	ActorEvents.actor_mouse_entered.connect(_on_actor_hovered)
	ActorEvents.actor_mouse_exited.connect(_on_actor_unhovered)
	
	SkillEvents.skill_selected.connect(_on_skill_selected)


func start_actor_turn(actor: Actor, allies: Array[Actor], enemies: Array[Actor]) -> void:
	current_actor = actor
	ally_group = allies
	enemy_group = enemies
	target = null
	can_act = true
	valid_targets.clear()
	
	update_actor_marker.emit(current_actor, "Active", true)


func _on_skill_selected(skill: CombatSkill) -> void:
	for marker in ["Select","Valid"]:
		update_markers.emit(ally_group, marker, false)
		update_markers.emit(enemy_group, marker, false)
	
	selected_skill = skill
	
	valid_targets = get_ability_targets()
	update_markers.emit(valid_targets, "Valid", true)


func _on_actor_clicked(actor: Actor) -> void:
	if selected_skill == null or !can_act or !is_instance_valid(actor) or !valid_targets.has(actor):
		return
	
	if !selected_skill.is_aoe:
		if valid_targets.has(actor):
			selected_target = [actor] as Array[Actor]
	else:
		if valid_targets.has(actor):
			selected_target = valid_targets.duplicate()
	
	if selected_target.is_empty():
		return
	
	SkillEvents.skill_used.emit(current_actor, selected_target, selected_skill)


func _on_actor_hovered(actor: Actor) -> void:
	if selected_skill == null or !valid_targets.has(actor):
		return
	if !selected_skill.is_aoe:
		if valid_targets.has(actor):
			update_actor_marker.emit(actor, "Select", true)
	else:
		update_markers.emit(get_ability_targets(), "Select", true)


func _on_actor_unhovered(_actor: Actor) -> void:
	update_markers.emit(valid_targets, "Select", false)


func get_target_group() -> Array[Actor]:
	if selected_skill == null:
		return [] as Array[Actor]
	var get_ally: bool = (selected_skill.can_target & selected_skill.TARGET_ENEMIES) == 0
	return ally_group if get_ally else enemy_group


func get_ability_targets() -> Array[Actor]:
	if selected_skill == null:
		return [] as Array[Actor]
	
	var group := get_target_group()
	var targets: Array[Actor] = []
	
	for t in group:
		var context := {
			"performer": current_actor,
			"target": t
		}
		if !is_instance_valid(t):
			continue
		if !selected_skill.validate(context):
			continue
		#print("This one good: " + t.name)
		targets.append(t)
	
	#print(group)
	
	return targets
