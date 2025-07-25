extends ActionEffect
class_name DamageFlatEffect

@export var min_damage : int = 0
@export var max_damage : int = 0
@export_range(0, 100, 1) var prot_pierce : int = 0
@export var direct_damage : bool = true
@export var is_crit_valid : bool = true



func declare() -> CombatStep:
	context["effect_data"][effect_id]["damage"] = 0
	context["effect_data"][effect_id]["direct_damage"] = direct_damage
	CombatEvents.broadcast_trigger.emit(context.get("performer", null), "damage_dealt", context)
	CombatEvents.broadcast_trigger.emit(get_target(), "damage_received", context)
	var amount: float = randf_range(min_damage + context["effect_data"][effect_id].get("damage_low", 0), max_damage + context["effect_data"][effect_id].get("damage_high", 0))
	
	if context.get("is_crit", false) and is_crit_valid:
		amount = (max_damage + context.get("damage_high", 0)) * 1.35
	
	#print(roundi(amount))
	
	context["effect_data"][effect_id]["damage"] = roundi(amount)
	var multiplier: int = context["effect_data"][effect_id].get("damage_multi", 0)
	context["effect_data"][effect_id]["damage"] += roundi(amount * multiplier)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	var effect_data: Dictionary = context["effect_data"][effect_id]
	target.apply_damage(effect_data.get("damage", 0) + effect_data.get("damage_bonus", 0))


func get_description() -> String:
	if min_damage == max_damage:
		return "Deals %d Damage" % min_damage
	return "Deals %d-%d Damage" % [min_damage, max_damage] 
