extends Node
class_name StatusManager



func _ready() -> void:
	pass
	#CombatEvents.broadcast_trigger.connect(_on_trigger_received)


func turn_ended(actor: Actor) -> void:
	reduce_effects_duration(actor)


func turn_started(actor: Actor) -> void:
	remove_ignore_turns(actor)


func apply_status(performer: Actor, target: Actor, context: Dictionary) -> void:
	var status_data: StatusData = context.get("status", null)
	
	if status_data == null or !is_instance_valid(target):
		return
	
	var found: StatusEffect = null
	
	for effect in target.get_status_effects():
		if effect.data.id == status_data.id:
			found = effect
			break
	
	if found == null or !status_data.stacks:
		var instance := StatusEffect.new(status_data, context.get("duration", status_data.max_duration), performer)
		instance.ignore_turn = context.get("ignore", false)
		target.get_status_effects().append(instance)
	else:
		found.amount += 1
		found.amount = clampi(found.amount, -1, found.data.max_stacks)
		if found.data.stack_duration:
			found.duration += context.get("duration", 1)
			found.duration = clampi(found.duration, -1, found.data.max_duration)
	
	target.update_statuses()


func reduce_effects_duration(actor: Actor) -> void:
	var status_effects := actor.get_status_effects()
	var to_remove: Array[StatusEffect] = []
	
	for status in status_effects:
		if status.data.max_duration == -1:
			continue
		if status.ignore_turn:
			status.ignore_turn = false
			continue
		
		status.duration -= 1
		if status.duration <= 0:
			to_remove.append(status)
	
	for status in to_remove:
		status_effects.erase(status)
	
	actor.update_statuses()


func remove_ignore_turns(actor: Actor) -> void:
	var status_effects := actor.get_status_effects()
	
	for status in status_effects:
		if status.ignore_turn == true:
			status.ignore_turn = false


func remove_status(target: Actor, status_id: String) -> void:
	var status_effects := target.get_status_effects()
	var to_remove: Array[StatusEffect] = []
	
	for status in status_effects:
		if status.data.id == status_id:
			to_remove.append(status)
	
	for status in to_remove:
		status_effects.erase(status)
	
	target.update_statuses()


func reduce_status_stack(context: Dictionary) -> void:
	var target: Actor = context.get("target", null)
	var status_id = context.get("status", "")
	var amount_to_remove = context.get("amount", 0)
	var status_effects := target.get_status_effects()
	
	if status_id == "" or !is_instance_valid(target):
		return
	
	for status in status_effects:
		if status.data.id == status_id:
			status.amount -= amount_to_remove
			if status.amount <= 0:
				status_effects.erase(status)
			break
	
	target.update_statuses()


func receive_trigger(trigger: String, target: Actor, context: Dictionary) -> void:
	if trigger != "" and is_instance_valid(target):
		for status in target.get_status_effects():
			if status.data.trigger == trigger:
				status.execute(target, context)
	await get_tree().process_frame
