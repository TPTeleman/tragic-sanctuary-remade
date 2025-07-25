extends ActionEffect
class_name ApplyStatusEffect

@export var status: StatusData
@export var duration: int = -1
@export var is_resist_valid: bool = false



func declare() -> CombatStep:
	var performer: Actor = context.get("performer")
	var target: Actor = get_target()
	#print(target.name)
	
	var data: StatusData = status.duplicate(true)
	for i in len(data.effects):
		var effect := data.effects[i]
		data.effects[i] = effect.duplicate(true)
	for i in len(data.actions):
		var comp := data.actions[i]
		data.actions[i] = comp.duplicate(true)
	
	context["effect_data"][effect_id]["duration"] = duration
	
	if duration != -1:
		if context.get("is_crit", false):
			var big_duration: float = float(duration)/2
			context["effect_data"][effect_id]["duration"] += roundi(big_duration)
	
	context["effect_data"][effect_id]["status"] = data
	context["effect_data"][effect_id]["ignore"] = performer == target
	
	return create_step()


func apply(performer: Actor, target: Actor) -> void:
	super.apply(performer, target)
	SkillEvents.apply_status.emit(performer, target, context["effect_data"][effect_id])


func get_description() -> String:
	return "[Status]"
