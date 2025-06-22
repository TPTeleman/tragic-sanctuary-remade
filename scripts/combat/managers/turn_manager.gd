extends Node
class_name TurnManager

const SPEED_MOD := 3

class Turn:
	var actor: Actor
	var initiative: int
	var extra_action := false

var current_round: int = 0
var turn_order: Array[Turn]
var last_turn: Turn = null



func initialize_turn_order(entities: Array[Actor]):
	turn_order.clear()
	
	for actor in entities:
		if actor.alive:
			add_entity_to_queue(actor)
	#update_turn_queue()
	
	print_turn_order()
	TurnEvents.round_started.emit()


func add_entity_to_queue(actor: Actor) -> void:
	for i in actor.stats.actions_amount:
		create_turn(actor)


func remove_entity_from_queue(actor: Actor) -> void:
	#print("removing actor")
	turn_order = turn_order.filter(func(t): return t.actor != actor)
	#print_turn_order()


func create_turn(actor: Actor) -> void:
	var speed: int = actor.stats.speed + randi_range(-SPEED_MOD, SPEED_MOD)
	var turn := Turn.new()
	turn.actor = actor
	turn.initiative = speed
	
	var inserted := false
	for i in turn_order.size():
		var current = turn_order[i]
		
		if turn.initiative > current.initiative:
			turn_order.insert(i, turn)
			inserted = true
			break
		elif turn.initiative == current.initiative:
			var a_speed = actor.get_stat("Speed")
			var b_speed = current.actor.get_stat("Speed")
			if a_speed > b_speed:
				turn_order.insert(i, turn)
				inserted = true
				break
	
	if !inserted:
		turn_order.append(turn)


func update_turn_queue() -> void:
	turn_order.sort_custom(_compare_initiative)


func _compare_initiative(a: Turn, b: Turn) -> int:
	return a.initiative > b.initiative


func next_turn() -> void:
	last_turn = turn_order.pop_front()
	TurnEvents.turn_ended.emit(last_turn.actor)
	
	if len(turn_order) <= 0:
		print("Round ended.")
		advance_round()


func advance_round() -> void:
	current_round += 1
	TurnEvents.round_ended.emit()


func get_active_actor() -> Actor:
	if turn_order.size() > 0:
		return turn_order[0].actor
	return null


func print_turn_order():
	print("Turn Order:")
	for i in turn_order.size():
		print("%d: %s (initiative %d)" % [i, turn_order[i].actor.name, turn_order[i].initiative])
