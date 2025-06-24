extends EffectModifier
class_name AccuracyModifier

const mod : String = "acc_mod"

@export var acc_add: int = 0



func modify_global(context: Dictionary) -> void:
	context[KEY][mod] = context[KEY].get(mod, 0)
	context[KEY][mod] += acc_add
