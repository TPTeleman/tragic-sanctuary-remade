extends ActionEffect
class_name HealCurHPEffect

@export_range(0, 100, 1) var percent : int = 0
@export_enum("Target", "Performer") var hp_percent: int = 0
@export var direct_heal : bool = true
@export var is_crit_valid : bool = true



func declare() -> CombatStep:
	var hp_host: Actor = context["performer"] if hp_percent == 1 else context["effect_data"][effect_id]["target"]
	var amount: float = hp_host.get_health() * (float(percent) / 100)
	
	if context.get("is_crit", false) and is_crit_valid:
		amount *= 1.35
	
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
	var who: String = "target" if hp_percent == 0 else "performer"
	return "Heals for %d%% of the %s's Current HP" % [who, percent] 
