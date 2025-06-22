extends Resource
class_name ActionEffect

var effect_id: String
@export_enum("Target", "Performer", "Adjacent_Ally","Adjacent_Enemy") var target_type: int = 0
@export var effect_rule: EffectRule
@export var on_hit: bool = true
@export var on_miss: bool = false
@export var apply_once: bool = false

var context: Dictionary



func should_run() -> bool:
	if !context.get("is_miss", false) and !on_hit:
		return false
	elif context.get("is_miss", false) and !on_miss:
		return false
	if apply_once and context["applied_effects"].has(effect_id):
		return false
	if effect_rule != null and !effect_rule.validate_target(context):
		return false
	return true


func declare() -> CombatStep:
	return create_step()


func create_step() -> CombatStep:
	var step := CombatStep.new()
	step.effect = self
	step.performer = context["performer"]
	step.target = get_target()
	return step


func apply(performer: Actor, target: Actor) -> void:
	if !context["applied_effects"].has(effect_id):
		context["applied_effects"].append(effect_id)


func get_target() -> Actor:
	var performer: Actor = context["performer"]
	var target: Actor = context["target"]
	var true_target: Actor
	
	if target_type == 0:
		true_target = context["target"]
	elif target_type == 1:
		true_target = context["performer"]
	elif target_type == 2:
		var possible_allies: Array[Actor]
		for t in context["allies"]:
			if t != performer and (t.rank + 1 + (t.size - 1) == performer.rank or t.rank - performer.size == performer.rank):
				possible_allies.append(t)
		true_target = possible_allies.pick_random()
	elif target_type == 3:
		var possible_foes: Array[Actor]
		for t in context["enemies"]:
			if t != target and (t.rank + 1 + (t.size - 1) == target.rank or t.rank - target.size == target.rank):
				possible_foes.append(t)
		true_target = possible_foes.pick_random()
	
	return true_target


func get_description() -> String:
	return "[Effect]"
