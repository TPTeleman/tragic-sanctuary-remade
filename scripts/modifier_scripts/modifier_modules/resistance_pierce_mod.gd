extends EffectModifier
class_name ResistancePierceMod

@export_enum("Debuff","Bleed","Blight","Burn","Move","Stun") var res_type: String
@export_range(-100, 100, 1) var amount: int = 0



func modify(context: Dictionary) -> void:
	var mod := res_type.to_lower() + "_pierce"
	context[KEY][mod] = context[KEY].get(mod, 0)
	context[KEY][mod] += amount
