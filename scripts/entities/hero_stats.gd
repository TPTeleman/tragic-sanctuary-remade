extends EntityStats
class_name HeroStats

const MAX_ABILITES := 5

var known_skills: Array[CombatSkill]
var equipped_skills: Array[CombatSkill]



func clone() -> HeroStats:
	var new_stats := HeroStats.new()
	duplicate_variables(new_stats)
	return new_stats


func get_skills() -> Array[CombatSkill]:
	return equipped_skills


func get_known_skills() -> Array[CombatSkill]:
	return known_skills


func get_entity_sprite() -> PackedScene:
	var es: PackedScene = load("res://scenes/combat_scenes/sprite_body/heroes/"+name.to_lower()+"_sprite.tscn")
	return es
