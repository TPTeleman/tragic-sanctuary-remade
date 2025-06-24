extends EffectModifier
class_name CritChanceModifier

const mod : String = "crit_mod"

@export var crit_chance_add: int = 0



func modify_global(context: Dictionary) -> void:
	context[KEY][mod] = context[KEY].get(mod, 0)
	context[KEY][mod] += crit_chance_add
