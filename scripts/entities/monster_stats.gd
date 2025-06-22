extends EntityStats
class_name MonsterStats



func clone() -> MonsterStats:
	var new_stats := MonsterStats.new()
	duplicate_variables(new_stats)
	return new_stats


func get_entity_sprite() -> PackedScene:
	var es: PackedScene = load("res://scenes/combat_scenes/sprite_body/monsters/"+name.to_lower()+"_sprite.tscn")
	return es
