extends RefCounted
class_name CombatStep

signal finished

var effect: ActionEffect
var performer: Actor
var target: Actor



func execute(_action: CombatAction) -> void:
	if effect.should_run():
		effect.apply(performer, target)
	await delay()
	finished.emit()


func delay() -> void:
	var tree = performer.get_tree()
	await tree.process_frame
