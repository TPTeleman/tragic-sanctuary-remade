@tool
extends CombatSkill
class_name MoveSkill



func validate(context: Dictionary = {}) -> bool:
	var performer: Actor = context["performer"]
	var target: Actor = context["target"]
	
	if target == performer:
		if (can_target & TARGET_SELF) == 0:
			#print("Tried targeting self, but skill can't.")
			return false
	else:
		if target.side == performer.side:
			if (can_target & TARGET_ALLIES) == 0:
				#print("Tried targeting ally, but skill can't.")
				return false
		else:
			if (can_target & TARGET_ENEMIES) == 0:
				#print("Targeting enemy, but skill can't.")
				return false
	
	if (!target.alive and !can_target_corpse) or (target.alive and !can_target_alive):
		#print("State condition not met.")
		return false
	
	var directions : Array[int] = [performer.stats.forward_move, performer.stats.bakward_move]
	if target.rank > performer.rank + (performer.size - 1) + directions[1]:
		#print("Target is outside of move range. Too far back.")
		return false
	if target.rank + (performer.size - 1) >= 4:
		#print("User is too big to move to target's rank.")
		return false
	if target.rank + (target.size - 1) < performer.rank - (performer.size - 1) - directions[0]:
		#print("Target is outside of move range. Too far forward.")
		return false
	
	var meets_requi := true
	for requi in cast_requirements:
		if !requi.validate_target(context):
			meets_requi = false
			break
	
	var in_range := false
	for i in target.size:
		var rank_flag: int = 1 << (target.rank + i)
		if (target_ranks & rank_flag) != 0:
			in_range = true
			break
	
	if !meets_requi:
		#print("Target does not meet requirements.")
		return false
	if !in_range:
		#print("Target is outside ability range.")
		return false
	return true
