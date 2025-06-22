extends ActionEffect
class_name HealFlatEffect

@export var min_heal : int = 0
@export var max_heal : int = 0
@export var direct_heal : bool = true
@export var is_crit_valid : bool = true



func declare() -> CombatStep:
	var amount: float = randf_range(min_heal, max_heal)
	
	if context.get("is_crit", false) and is_crit_valid:
		amount = max_heal * 1.35
	
	context["effect_data"][effect_id]["heal"] = roundi(amount)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	target.apply_heal(context["effect_data"][effect_id].get("heal", 0))
