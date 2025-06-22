extends Node

signal turn_created(turn: Dictionary)
signal turn_destroyed(turn: Dictionary)

signal turn_order_created(turn_order: Array[Dictionary])
signal turn_started
signal turn_ended(actor: Actor)

signal round_started
signal round_ended
