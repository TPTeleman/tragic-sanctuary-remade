extends Node
class_name CombatQueue

var actions : Array[CombatAction] = []



func add_action(action: CombatAction) -> void:
	actions.append(action)


func process_actions() -> void:
	for action in actions:
		await action.execute()
	actions.clear()
