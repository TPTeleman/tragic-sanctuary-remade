extends RefCounted
class_name CombatAction

var performer
var targets : Array[Actor]
var steps : Array[CombatStep]



func execute() -> void:
	for step in steps:
		await step.execute(self)
