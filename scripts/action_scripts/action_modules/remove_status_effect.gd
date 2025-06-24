extends ActionEffect
class_name RemoveStatusEffect

@export var status: StatusData



func declare() -> CombatStep:
	context["effect_data"][effect_id]["status"] = status.id
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	SkillEvents.remove_status.emit(performer, target, context["effect_data"][effect_id])
