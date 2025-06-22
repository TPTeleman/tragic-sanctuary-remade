extends Node

@export var team : Array[EntityStats]

@onready var combat : Combat = $Combat_Node



func _ready() -> void:
	start_game()


func start_game() -> void:
	combat.create_teams(team.duplicate(), team.duplicate())
	combat.start_combat()
