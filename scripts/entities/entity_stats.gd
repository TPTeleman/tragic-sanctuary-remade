extends Resource
class_name EntityStats

@export var name : String
@export var icon : Texture2D

@export var skill_set: Array[CombatSkill]
@export var pass_skill: CombatSkill = load("res://resources/skills/shared/Shared_00_Move.tres")
@export var move_skill: CombatSkill = load("res://resources/skills/shared/Shared_01_Pass.tres")

@export_group("Stats")
@export var max_hp : int = 1
@export var max_mind : int = 0
@export_range(0, 100, 1) var accuracy: int = 100
@export_range(0, 100, 1) var dodge: int = 0
@export_range(0, 100, 1) var protection: int = 0
@export var speed : int = 1

@export_range(1, 4, 1) var size: int = 1
@export var forward_move: int = 1
@export var bakward_move: int = 1
@export var actions_amount: int = 1

@export_group("Resistances")
@export_range(0, 200, 1) var bleed_res: int = 40
@export_range(0, 200, 1) var blight_res: int = 40
@export_range(0, 200, 1) var burn_res: int = 40
@export_range(0, 200, 1) var stun_res: int = 20
@export_range(0, 200, 1) var move_res: int = 20
@export_range(0, 200, 1) var debuff_res: int = 20
@export_range(0, 200, 1) var death_res: int = 0

var cur_hp : int = 0
var cur_mind : int = 0



func clone() -> EntityStats:
	var new_stats := EntityStats.new()
	duplicate_variables(new_stats)
	return new_stats


func duplicate_variables(new_stats: EntityStats) -> void:
	new_stats.name = name
	new_stats.icon = icon
	new_stats.max_hp = max_hp
	new_stats.cur_hp = max_hp
	new_stats.max_mind = max_mind
	new_stats.cur_mind = max_mind
	new_stats.size = size
	for stat in ["Speed","Accuracy","Dodge","Protection"]:
		new_stats.set(stat.to_lower(), get_stat(stat))
	for res in ["Bleed","Blight","Burn","Stun","Move","Debuff","Death"]:
		new_stats.set(res.to_lower()+"_res", get_stat(res+"_res"))
	new_stats.skill_set = skill_set.duplicate()
	new_stats.move_skill = move_skill.duplicate()
	new_stats.pass_skill = pass_skill.duplicate()
	new_stats.forward_move = forward_move
	new_stats.bakward_move = bakward_move
	new_stats.actions_amount = actions_amount


func get_stat(stat: String) -> int:
	var switch: String = stat.to_lower()
	var stat_amount: int = 0
	var total_stat: int = 0
	match switch:
		"health":
			stat_amount = max_hp
		"stress":
			stat_amount = max_mind
		"acc","accuracy":
			stat_amount = accuracy
		"dodge":
			stat_amount = dodge
		"prot","protection":
			stat_amount = protection
		"speed":
			stat_amount = speed
		"bleed_res":
			stat_amount = bleed_res
		"blight_res":
			stat_amount = blight_res
		"burn_res":
			stat_amount = burn_res
		"stun_res":
			stat_amount = stun_res
		"move_res":
			stat_amount = move_res
		"debuff_res":
			stat_amount = debuff_res
		"death_res":
			stat_amount = death_res
	
	total_stat = stat_amount
	
	return total_stat


func reduce_health(value: int) -> void:
	cur_hp = max(cur_hp - value, 0)


func reduce_mind(value: int) -> void:
	cur_hp = max(cur_hp - value, 0)


func increase_health(value: int) -> void:
	cur_hp = min(cur_hp + value, max_hp)


func increase_mind(value: int) -> void:
	cur_hp = min(cur_hp + value, max_mind)


func get_skill_set() -> Array[CombatSkill]:
	return skill_set


func get_skills() -> Array[CombatSkill]:
	return skill_set


func get_entity_sprite() -> PackedScene:
	return null
