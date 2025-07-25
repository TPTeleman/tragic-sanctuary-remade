extends ActionEffect
class_name MoveToRankEffect

@export_enum("Given","Target") var rank_type: int = 0
@export_enum("Rank 1","Rank 2","Rank 3","Rank 4",) var target_rank: int = 0
@export var pierce_mod : int = 0
@export var resist_valid : bool = true



func declare() -> CombatStep:
	var _performer: Actor = context.get("performer")
	var target: Actor = get_target()
	
	context["effect_data"][effect_id]["resisted"] = false
	context["effect_data"][effect_id]["move_pierce"] = 0
	context["effect_data"][effect_id]["rank"] = target_rank if rank_type == 0 else context["effect_data"][effect_id]["target"].rank
	
	if resist_valid:
		var resist: int = randi() % 100
		var move_res: int = target.get_stat("Move_Res") - context["effect_data"][effect_id]["move_pierce"] - pierce_mod
		if context.get("is_crit", false):
			move_res -= 20
		if resist <= move_res:
			print("Target resisted movement attempt, rolled %d%% with %d%% resistance." % [resist, move_res])
			context["effect_data"][effect_id]["resisted"] = true
	
	if !context["effect_data"][effect_id]["resisted"]:
		CombatEvents.broadcast_trigger.emit(get_target(), "moved", context)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	
	if context["effect_data"][effect_id]["resisted"]:
		return
	
	SkillEvents.move_to_rank_target.emit(performer, target, context["effect_data"][effect_id])
