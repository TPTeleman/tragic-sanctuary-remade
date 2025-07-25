extends Resource
class_name StatusEffect

var data: StatusData
var source: Actor
var duration: int = -1
var amount: int = 1
var ignore_turn: bool = false



@warning_ignore("shadowed_variable")
func _init(data: StatusData, duration, source: Actor = null):
	self.data = data
	self.source = source
	self.duration = data.max_duration


func execute(target: Actor, context: Dictionary) -> void:
	if !is_instance_valid(target):
		return
	if !is_instance_valid(source):
		source = null
	
	if context.get("skill_id", "") == "":
		context["skill_id"] = data.id
		context["skill_type"] = data.status_type
	
	for status in data.effects:
		if status.should_run(context):
			status.apply(context)
	
	var new_context := {
		"is_crit": false,
		"is_miss": false,
		"performer": source,
		"target": target,
		"skill_id": data.id,
		"skill_type": data.status_type,
		"allies": [],
		"enemies": [],
		"applied_effects": [],
		"effect_data": {},
		"mod_data": {}
	}
	
	for i in len(data.actions):
		var action: ActionEffect = data.actions[i]
		var effect_id := "effect_%d" % i
		action.effect_id = effect_id
		new_context["effect_data"][effect_id] = {}
		action.context = new_context
		action.declare()
	
	for action in data.actions:
		if action.should_run():
			action.apply(new_context["performer"], new_context["target"])


func get_tooltip_description() -> Dictionary:
	return {
		"title": data.id,
		"icon": data.icon,
		"text": "",
		"duration": duration,
		"stacks": amount,
	}
