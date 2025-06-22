extends Node
class_name RankManager

const MAX_RANK := 4

@export var hero_rank_one: Marker2D
@export var monster_rank_one: Marker2D
@export var rank_distance: int = 48

var entities: Dictionary = {
   "HERO": [],
   "MONSTER": []
}



func _ready() -> void:
	clear_ranks()


func clear_ranks() -> void:
	for side in entities.keys():
		entities[side].clear()
		for _i in MAX_RANK:
			entities[side].append(null)


func add_entity(actor: Actor, side: String, rank: int) -> void:
	var fit_rank: int = find_fit_position(actor, side, rank, actor.size)

	if fit_rank == -1:
		var success := shift_entities_to_make_room(side, rank, actor.size, 1)
		if success:
			fit_rank = find_fit_position(actor, side, rank, actor.size)

	if fit_rank == -1:
		print("No space to add actor: ", actor.name)
		return

	apply_entity_to_ranks(actor, side, fit_rank)
	update_positions(side)


func remove_entity_from_ranks(actor: Actor) -> void:
	clear_entity_from_ranks(actor, actor.side)
	slide_entities_forward(actor.side)


func move_entity(actor: Actor, side: String, desired_rank: int) -> void:
	if desired_rank < 0 or desired_rank >= MAX_RANK:
		return

	var current_rank := actor.rank
	var direction: int = sign( desired_rank - current_rank )
	if direction == 0:
		return  # Already there

	
	# Step 1: Temporarily remove actor
	clear_entity_from_ranks(actor, side)

	# Step 2: Try to displace entities in the desired direction
	var can_shift := try_shift_for_entity(actor, side, desired_rank, direction)

	if !can_shift:
		print("Move failed. Reverting.")
		apply_entity_to_ranks(actor, side, current_rank)
		return

	# Step 3: Apply actor to final position
	var new_rank: int = find_nearest_valid_rank(side, desired_rank, actor.size, direction)
	apply_entity_to_ranks(actor, side, new_rank)
	update_positions(side)


func find_fit_position(actor: Actor, side: String, desired_rank: int, size: int) -> int:
	# Goes through each rank between the desired one and the last one the actor could fit in.
	# if an empty slot is found where subsequent slots also fit their size it returns with the rank.
	for i in range(desired_rank, MAX_RANK - size + 1):
		var can_fit := true
		for j in range(i, i + size):
			if entities[side][j] != null and entities[side][j] != actor:
				can_fit = false
				break
		if can_fit:
			return i
	return -1


func try_shift_for_entity(actor: Actor, side: String, desired_rank: int, direction: int) -> bool:
	var size := actor.size

	# Calculate the range of ranks mover wants to occupy
	var mover_start := desired_rank

	# Clamp ranks inside bounds
	if mover_start < 0 or mover_start >= MAX_RANK:
		print("Out of bounds.")
		return false

	# Range between mover's current position and desired rank
	var start_range: int = min(actor.rank, desired_rank)
	var end_range: int = max(actor.rank + (actor.size - 1), desired_rank + (size - 1))

	# Collect all entities blocking the path, excluding the mover itself
	var displaced := []
	var visited := {}
	for i in range(start_range, end_range + 1):
		var e = entities[side][i]
		if e != null and e != actor and not visited.has(e):
			displaced.append(e)
			visited[e] = true

	# Shift displaced entities by opposite direction * mover size
	var push_dir := -direction

	# Gather all current occupied ranks by displaced entities so we can ignore them in collision checks
	var future_occupancy := {}  # rank -> actor

	for e in displaced:
		var new_rank: int = e.rank - direction * size
		if new_rank < 0 or new_rank + e.size - 1 >= MAX_RANK:
			print("Entity", e.name, "would go out of bounds.")
			return false

		for j in range(new_rank, new_rank + e.size):
			if future_occupancy.has(j):
				print("Rank", j, "would be occupied by both", future_occupancy[j].name, "and", e.name)
				return false
			future_occupancy[j] = e

	# All valid, move displaced entities
	for e in displaced:
		clear_entity_from_ranks(e, side)
	for e in displaced:
		var new_rank: int = e.rank + push_dir * size
		apply_entity_to_ranks(e, side, new_rank)

	return true


func find_nearest_valid_rank(side: String, from_rank: int, size: int, direction: int) -> int:
	var step := direction
	var rank := from_rank

	while rank >= 0 and rank <= MAX_RANK - size:
		var can_fit := true
		for j in range(rank, rank + size):
			if entities[side][j] != null:
				can_fit = false
				break
		if can_fit:
			return rank
		rank += step
	return -1


func shift_entities_to_make_room(side: String, start_rank: int, size: int, direction: int) -> bool:
	var end_rank := start_rank + size - 1
	if start_rank < 0 or end_rank >= MAX_RANK:
		return false

	var blockers := {}
	for i in range(start_rank, end_rank + 1):
		var blocker: Actor = entities[side][i]
		if blocker != null:
			blockers[blocker] = true

	for blocker in blockers.keys():
		var proposed_new_rank: int = blocker.rank + direction
		if proposed_new_rank < 0 or proposed_new_rank + blocker.size > MAX_RANK:
			return false

		# Recursively clear room
		if not shift_entities_to_make_room(side, proposed_new_rank, blocker.size, direction):
			return false

		var safe := find_fit_position(blocker, side, proposed_new_rank, blocker.size)
		if safe == -1:
			return false

		apply_entity_to_ranks(blocker, side, safe)

	return true


func apply_entity_to_ranks(actor: Actor, side: String, rank: int) -> void:
	clear_entity_from_ranks(actor, side)
	actor.set_rank(rank)
	for i in range(rank, rank + actor.size):
		entities[side][i] = actor


func clear_entity_from_ranks(actor: Actor, side: String) -> void:
	for i in range(MAX_RANK):
		if entities[side][i] == actor:
			entities[side][i] = null


func slide_entities_forward(side: String) -> void:
	var i := 0
	while i < MAX_RANK:
		# If this rank is empty
		if entities[side][i] == null:
			# Look for the next actor that can be moved here
			var j := i + 1
			while j < MAX_RANK:
				var candidate: Actor = entities[side][j]
				if candidate != null:
					# Check if the entire range [i, i + candidate.size) is empty
					var can_slide := true
					for k in range(i, i + candidate.size):
						if k >= MAX_RANK or (entities[side][k] != null and entities[side][k] != candidate):
							can_slide = false
							break

					if can_slide:
						#print("Sliding ", candidate.name, " forward to fill gap at rank ", i)
						apply_entity_to_ranks(candidate, side, i)
						i = i + candidate.size - 1  # Skip ahead to avoid rechecking parts of this actor
					break  # Whether it slid or not, we stop scanning forward for this i
				j += 1
		i += 1

	update_positions(side)


func get_entity_in_rank(side: String, rank: int) -> Actor:
	if rank >= MAX_RANK or rank < 0:
		return null
	return entities[side][rank]


func get_direction(side: String) -> int:
	return -1 if side == "HERO" else 1


func get_rank_position(side: String, rank: int) -> Vector2:
	var direction: int = get_direction(side)
	var base_pos: Vector2 = hero_rank_one.position if side == "HERO" else monster_rank_one.position
	return base_pos + Vector2(rank * rank_distance * direction, 0)


func update_positions(side: String) -> void:
	for actor in entities[side]:
		if actor != null:
			actor.global_position = get_rank_position(side, actor.rank)


func move_entity_forward(actor: Actor, side: String, ranks: int = 1) -> void:
	var dir := -1
	var wanted_rank: int = clamp(actor.rank + dir * ranks, 0, MAX_RANK - actor.size)
	#print(wanted_rank)
	move_entity(actor, side, wanted_rank)


func move_entity_backward(actor: Actor, side: String, ranks: int = 1) -> void:
	var dir := 1
	var wanted_rank: int = clamp(actor.rank + dir * ranks, 0, MAX_RANK - actor.size)
	#print(wanted_rank)
	move_entity(actor, side, wanted_rank)
