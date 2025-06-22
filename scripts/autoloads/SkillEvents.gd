extends Node

signal skill_used(performer: Actor, targets: Array[Actor], skill: CombatSkill)
signal skill_selected(skill: CombatSkill)
signal skill_target_selected(targets: Array[Actor])
signal broadcast_trigger(performer: Actor, target: Actor, trigger: String, context: Dictionary)

signal move_target(performer: Actor, target: Actor, context: Dictionary)
signal move_to_rank_target(performer: Actor, target: Actor, context: Dictionary)
