extends ActionEffect
class_name DamageFlatEffect

@export var min_damage : int = 0
@export var max_damage : int = 0
@export_range(0, 100, 1) var prot_pierce : int = 0
@export var direct_damage : bool = true
@export var is_crit_valid : bool = true



func declare() -> CombatStep:
	var amount: float = randf_range(min_damage, max_damage)
	
	if context.get("is_crit", false) and is_crit_valid:
		amount = max_damage * 1.35
	
	context["effect_data"][effect_id]["damage"] = roundi(amount)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	target.apply_damage(context["effect_data"][effect_id].get("damage", 0))
