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
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	target.apply_damage(context["effect_data"][effect_id].get("damage", 0))
