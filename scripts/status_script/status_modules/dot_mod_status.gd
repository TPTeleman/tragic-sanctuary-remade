extends StatusModifier
class_name DotModStatus

@export_enum("Bleed","Blight","Burn","Regen") var dot_type: String
@export_range(-100, 100, 1) var amount: int = 0



func apply(context: Dictionary) -> void:
	if context.has("status"):
		var data: StatusData = context["status"]
		var multiplier: float = (1 + float(amount) / 100)
		#print("Modifying: ",data.id)
		
		for comp in data.actions:
			if dot_type.to_lower() == data.id:
				if comp is HealFlatEffect:
					comp.min_heal = roundi(comp.min_heal * multiplier)
					comp.max_heal = roundi(comp.max_heal * multiplier)
					comp.heal_percent = roundi(comp.heal_percent * multiplier)
				if comp is DamageFlatEffect:
					comp.min_damage = roundi(comp.min_damage * multiplier)
					comp.max_damage = roundi(comp.max_damage * multiplier)
					comp.damage_percent = roundi(comp.damage_percent * multiplier)
