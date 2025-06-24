extends ActionEffect
class_name DamageMaxHPEffect

@export_range(0, 100, 1) var percent : int = 0
@export_enum("Target", "Performer") var hp_percent: int = 0
@export_range(0, 100, 1) var prot_pierce : int = 0
@export var direct_damage : bool = true
@export var is_crit_valid : bool = true



func declare() -> CombatStep:
	var hp_host: Actor = context["performer"] if hp_percent == 1 else context["target"]
	var amount: float = hp_host.get_stat("Health") * (float(percent) / 100)
	
	if context.get("is_crit", false) and is_crit_valid:
		amount *= 1.35
	
	context["effect_data"][effect_id]["damage"] = roundi(amount)
	context["effect_data"][effect_id]["direct_damage"] = direct_damage
	CombatEvents.broadcast_trigger.emit(context.get("performer", null), "damage_dealt", context)
	CombatEvents.broadcast_trigger.emit(get_target(), "damage_received", context)
	var multiplier: int = context["effect_data"][effect_id].get("damage_multi", 0)
	context["effect_data"][effect_id]["damage"] += roundi(amount * multiplier)
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	var effect_data: Dictionary = context["effect_data"][effect_id]
	target.apply_damage(effect_data.get("damage", 0) + effect_data.get("damage_bonus", 0))


func get_description() -> String:
	var who: String = "target" if hp_percent == 0 else "performer"
	return "Deals %d%% of the %s's Max HP as Damage" % [who, percent] 
