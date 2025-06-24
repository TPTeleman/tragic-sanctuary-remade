extends EffectModifier
class_name ProtPierceModifier

const mod : String = "prot_mod"

@export var pierce_add: int = 0



func modify_global(context: Dictionary) -> void:
	context[KEY][mod] = context[KEY].get(mod, 0)
	context[KEY][mod] += pierce_add
