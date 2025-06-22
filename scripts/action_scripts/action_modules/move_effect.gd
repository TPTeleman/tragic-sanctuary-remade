extends ActionEffect
class_name MoveEffect

@export_enum("Forward: -1", "Backward: 1") var direction : int = -1
@export_range(1, 3, 1) var step : int = 1
@export var pierce_mod : int = 0
@export var resist_valid : bool = true



func declare() -> CombatStep:
	var performer: Actor = context.get("performer")
	var target: Actor = context.get("target")
	
	context["effect_data"][effect_id]["resisted"] = false
	context["effect_data"][effect_id]["move_pierce"] = 0
	context["effect_data"][effect_id]["direction"] = direction
	context["effect_data"][effect_id]["move_step"] = step
	
	if resist_valid:
		var resist: int = randi() % 100
		var move_res: int = target.get_stat("Move_Res") - context["effect_data"][effect_id]["move_pierce"] - pierce_mod
		if context.get("is_crit", false):
			move_res -= 20
		if resist <= move_res:
			print("Target resisted movement attempt, rolled %d%% with %d%% resistance." % [resist, move_res])
			context["effect_data"][effect_id]["resisted"] = true
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	
	if context["effect_data"][effect_id]["resisted"]:
		return
	
	SkillEvents.move_target.emit(performer, target, context["effect_data"][effect_id])
