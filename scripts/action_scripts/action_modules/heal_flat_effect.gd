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
	context["effect_data"][effect_id]["direct_heal"] = direct_heal
	CombatEvents.broadcast_trigger.emit(context.get("performer", null), "heal_given", context)
	CombatEvents.broadcast_trigger.emit(get_target(), "heal_received", context)
	var multiplier: int = context["effect_data"][effect_id].get("heal_multi", 0)
	context["effect_data"][effect_id]["heal"] += roundi(amount * multiplier)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	var effect_data: Dictionary = context["effect_data"][effect_id]
	target.apply_heal(effect_data.get("heal", 0) + effect_data.get("heal_bonus", 0))


func get_description() -> String:
	if min_heal == max_heal:
		return "Heals %d HP" % min_heal
	return "Heals %d HP" % [min_heal, max_heal] 
