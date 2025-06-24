extends ActionEffect
class_name ReduceStackEffect

@export var status : StatusData
@export var amount : int = 0



func declare() -> CombatStep:
	context["effect_data"][effect_id]["status"] = status.id
	context["effect_data"][effect_id]["amount"] = amount
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	SkillEvents.reduce_status_stack.emit(performer, target, context["effect_data"][effect_id])
