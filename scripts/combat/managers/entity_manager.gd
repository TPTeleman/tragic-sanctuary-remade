extends Node
class_name EntityManager

const ACTOR_BODY := preload("res://scenes/combat_scenes/actor_node/actor_node.tscn")

@export var entity_parent: Node2D



func create_entity(stats: EntityStats, side: String) -> Actor:
	var new_entity: Actor = ACTOR_BODY.instantiate()
	new_entity.stats = stats.clone()
	new_entity.size = stats.size
	new_entity.side = side
	entity_parent.add_child(new_entity)
	new_entity.set_body()
	return new_entity


func color_marks(allies: Array[Actor], foes: Array[Actor]) -> void:
	for a in allies:
		if is_instance_valid(a):
			a.valid_rect.modulate = Color.GREEN_YELLOW
			a.select_rect.modulate = Color.GREEN_YELLOW
	for a in foes:
		if is_instance_valid(a):
			a.valid_rect.modulate = Color.ORANGE_RED
			a.select_rect.modulate = Color.ORANGE_RED


func update_actor_marker(actor: Actor, marker: String, visible: bool) -> void:
	actor.set_marker(marker, visible)


func update_markers(actors: Array[Actor], marker: String, visible: bool) -> void:
	for a in actors:
		if is_instance_valid(a):
			update_actor_marker(a, marker, visible)


func update_all_markers(actors: Array[Actor], visible: bool) -> void:
	for a in actors:
		if is_instance_valid(a):
			for marker in a.markers.keys():
				update_actor_marker(a, marker, visible)
