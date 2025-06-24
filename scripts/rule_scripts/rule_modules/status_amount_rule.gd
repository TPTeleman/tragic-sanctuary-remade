extends EffectRule
class_name StatusAmountRule

@export var status: StatusData
@export_enum("Above","Below","Equal") var desired_value: int
@export var desired_amount: int


\
func validate_target(context: Dictionary) -> bool:
	var target: Actor = get_target(context)

	if !is_instance_valid(target):
		return false
	else:
		if !target.has_status(status.id):
			return false
		
		var status_effect: StatusEffect = target.get_status(status.data.id)
		
		if status_effect != null:
			if desired_value == 0 and status_effect.amount < desired_amount:
				#print("Above not met: ",status_effect.data.id)
				return false
			if desired_value == 1 and status_effect.amount > desired_amount:
				#print("Below not met: ",status_effect.data.id)
				return false
			if desired_value == 2 and status_effect.amount != desired_amount:
				#print("Equal not met: ",status_effect.data.id)
				return false
		else:
			return false
	return true
