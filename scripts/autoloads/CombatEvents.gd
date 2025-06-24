extends Node

signal combat_started
signal combat_ended(victory: bool)
signal change_battle_phase(phase: String)
signal turn_started(actor: Actor)
signal turn_ended(actor: Actor)
signal round_ended(cur_round: int)
signal skip_entity_turn(actor: Actor, context: Dictionary)

signal broadcast_trigger(target: Actor, trigger: String, context: Dictionary)
