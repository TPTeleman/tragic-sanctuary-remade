@tool
extends Resource
class_name CombatSkill

const TARGET_ALLIES := 1 << 0
const TARGET_ENEMIES := 1 << 1
const TARGET_SELF := 1 << 2

const CastRank := {
	RANK_1 = 1 << 0,
	RANK_2 = 1 << 1,
	RANK_3 = 1 << 2,
	RANK_4 = 1 << 3,
}

@export var name : String
@export var icon : Texture2D
@export_enum("None", "Melee", "Ranged", "Mystical") var skill_type : String = "None"
@export_flags("HasDamage", "HasHeal", "HasStatus", "HasMovement") var skill_tags : int = 0

@export_category("Effects Configuration")
@export_range(-100, 100, 1) var accuracy_mod : int = 0
@export_range(-100, 100, 1) var crit_mod : int = 0
@export var is_crit_valid : bool = false
@export var effects : Array[ActionEffect] = []

@export_category("Casting Configuration")
@export var cast_requirements: Array[EffectRule] = []
@export var cooldown : int = 0
var remaining_cooldown : int = 0
var ignore_turn : bool = false
@export var is_aoe : bool = false
@export_group("Cast Targets")
@export_flags("Allies", "Enemies", "Self") var can_target : int = 0
@export_group("Cast Ranks")
@export_flags("Rank 1", "Rank 2", "Rank 3", "Rank 4") var cast_ranks : int = 0
@export_group("Target Ranks")
@export_flags("Rank 1", "Rank 2", "Rank 3", "Rank 4") var target_ranks : int = 0
@export var can_target_alive : bool = true
@export var can_target_corpse : bool = false



func passive_validation(context: Dictionary = {}) -> bool:
	if remaining_cooldown > 0:
		return false
	
	var performer: Actor = context["performer"]
	var targets: Array[Actor] = context["targets"]
	
	var rank_flag: int = 1 << performer.rank
	if (cast_ranks & rank_flag) == 0:
		return false
	
	var target_in_rank: bool = false
	for t in targets:
		var target_rank: int = 1 << t.rank
		if (target_ranks & target_rank) != 0:
			target_in_rank = true
			break
	
	if !target_in_rank:
		return false
	
	var someone_needs := true
	if cast_requirements.size() > 0:
		someone_needs = false
		
		context["performer"] = performer
		for t in targets:
			context["target"] = t
			if someone_needs == true:
				break
			for rule in cast_requirements:
				if rule.validate_target(context):
					someone_needs = true
					break
	
	if !someone_needs:
		return false
	
	return true


func validate(context: Dictionary = {}) -> bool:
	var performer: Actor = context["performer"]
	var target: Actor = context["target"]
	
	if target == performer:
		if (can_target & TARGET_SELF) == 0:
			#print("Tried targeting self, but skill can't.")
			return false
	else:
		if target.side == performer.side:
			if (can_target & TARGET_ALLIES) == 0:
				#print("Tried targeting ally, but skill can't.")
				return false
		else:
			if (can_target & TARGET_ENEMIES) == 0:
				#print("Targeting enemy, but skill can't.")
				return false
	
	if (!target.alive and !can_target_corpse) or (target.alive and !can_target_alive):
		#print("State condition not met.")
		return false
	
	var meets_requi := true
	for requi in cast_requirements:
		if !requi.validate_target(context):
			meets_requi = false
			break
	
	var in_range := false
	for i in target.size:
		var rank_flag: int = 1 << (target.rank + i)
		if (target_ranks & rank_flag) != 0:
			in_range = true
			break
	
	if !meets_requi:
		#print("Target does not meet requirements.")
		return false
	if !in_range:
		#print("Target is outside ability range.")
		return false
	return true


func is_self_exclusive() -> bool:
	return (can_target & TARGET_SELF) != 0 and (can_target & TARGET_ALLIES) == 0
