extends Node
class_name Combat

enum CombatPhase {
	TURN_START,
	AFTER_START,
	ACTOR_COMMAND,
	SKILL_RESOLUTION,
	AFTER_SKILL,
	TURN_END
}

var phase := CombatPhase.TURN_START

var heroes: Array[Actor]
var enemies: Array[Actor]

var in_combat: bool = false

@export_category("Combat Components")
@export var entity_manager : EntityManager
@export var status_manager : StatusManager
@export var action_manager : ActionManager
@export var rank_manager : RankManager
@export var turn_manager : TurnManager
@export var combat_queue : CombatQueue



func _ready() -> void:
	ActorEvents.actor_defeated.connect(_on_actor_death)
	
	TurnEvents.round_ended.connect(_on_turn_manager_round_ended)
	TurnEvents.turn_ended.connect(_on_actor_turn_ended)
	
	CombatEvents.broadcast_trigger.connect(_on_trigger_broadcast)
	
	SkillEvents.skill_used.connect(_on_skill_used)
	SkillEvents.move_target.connect(skill_move_actor)
	SkillEvents.move_to_rank_target.connect(skill_move_actor_to_rank)
	SkillEvents.apply_status.connect(skill_apply_status)
	SkillEvents.remove_status.connect(skill_remove_status)
	SkillEvents.reduce_status_stack.connect(skill_reduce_status_stack)


func switch_battle_phase(new_phase: CombatPhase) -> void:
	phase = new_phase
	match new_phase:
		CombatPhase.TURN_START:
			CombatEvents.change_battle_phase.emit("Turn_Start")
			await get_tree().create_timer(0.25).timeout
			
			var actor: Actor = turn_manager.get_active_actor()
			if is_instance_valid(actor) and actor.alive:
				var context := {
					"is_crit": false,
					"is_miss": false,
					"performer": actor,
					"target": actor,
					"skill_id": "",
					"skill_type": "",
					"allies": [],
					"enemies": [],
					"applied_effects": [],
					"effect_data": {},
					"mod_data": {}
				}
				await status_manager.receive_trigger("turn_start", actor, context)
			
			switch_battle_phase(CombatPhase.AFTER_START)
		CombatPhase.AFTER_START:
			CombatEvents.change_battle_phase.emit("After_Start")
			
			var actor: Actor = turn_manager.get_active_actor()
			if is_instance_valid(actor) and actor.stats.cur_hp <= 0 and actor.alive:
					actor.alive = false
					ActorEvents.actor_defeated.emit(actor)
			
			switch_battle_phase(CombatPhase.ACTOR_COMMAND)
		CombatPhase.ACTOR_COMMAND:
			CombatEvents.change_battle_phase.emit("Actor_Command")
			give_actor_control()
		CombatPhase.SKILL_RESOLUTION:
			CombatEvents.change_battle_phase.emit("Skill_Resolution")
			Gui.get_window_by_name("Combat_Window").hide_actor_display()
			entity_manager.update_all_markers(heroes, false)
			entity_manager.update_all_markers(enemies, false)
			
			await combat_queue.process_actions()
			
			switch_battle_phase(CombatPhase.AFTER_SKILL)
		CombatPhase.AFTER_SKILL:
			CombatEvents.change_battle_phase.emit("After_Skill")
			
			for t in action_manager.selected_target:
				if t.stats.cur_hp <= 0 and t.alive:
					t.alive = false
					ActorEvents.actor_defeated.emit(t)
			
			switch_battle_phase(CombatPhase.TURN_END)
		CombatPhase.TURN_END:
			CombatEvents.change_battle_phase.emit("Turn_End")
			var actor: Actor = turn_manager.get_active_actor()
			Gui.get_window_by_name("Combat_Window").hide_actor_display()
			
			if is_instance_valid(actor) and actor.alive:
				status_manager.turn_ended(actor)
				CombatEvents.turn_ended.emit(actor)
			turn_manager.next_turn()


func start_combat() -> void:
	if heroes.is_empty() or enemies.is_empty():
		print("Aw, there are no entities in combat :(")
		return
	in_combat = true
	Gui.open_window_by_name("Combat_Window")
	
	if turn_manager.get_active_actor() != null:
		switch_battle_phase(CombatPhase.TURN_START)


func end_combat() -> void:
	in_combat = false


func create_teams(player: Array[EntityStats], enemy: Array[EntityStats]) -> void:
	for i in player.size():
		var stats := player[i].clone()
		stats.cur_hp = stats.max_hp
		stats.cur_mind = stats.max_mind
		var actor := create_actor(stats, "HERO")
		rank_manager.add_entity(actor, actor.side, i)
		heroes.append(actor)
	for i in enemy.size():
		var stats := player[i].clone()
		stats.cur_hp = stats.max_hp
		stats.cur_mind = stats.max_mind
		var actor := create_actor(stats, "MONSTER")
		rank_manager.add_entity(actor, actor.side, i)
		enemies.append(actor)
	#turn_manager.print_turn_order()
	turn_manager.initialize_turn_order(heroes + enemies)


func create_actor(stats: EntityStats, side: String) -> Actor:
	var actor := entity_manager.create_entity(stats, side)
	actor.name = side.to_pascal_case()+"_"+stats.name
	#turn_manager.add_entity_to_queue(actor)
	return actor


func _on_actor_death(actor: Actor) -> void:
	#print(actor.name + ", Yoo bro has died.")
	if actor.side == "HERO":
		heroes.erase(actor)
	else:
		enemies.erase(actor)
	turn_manager.remove_entity_from_queue(actor)
	rank_manager.remove_entity_from_ranks(actor)
	
	actor.call_deferred("queue_free")


func give_actor_control():
	var actor: Actor = turn_manager.get_active_actor()
	if is_instance_valid(actor):
		var ally := heroes.duplicate() if actor.side == "HERO" else enemies.duplicate()
		var foe := enemies.duplicate() if actor.side == "HERO" else heroes.duplicate()
		
		entity_manager.color_marks(ally, foe)
		action_manager.start_actor_turn(actor, ally, foe)
		CombatEvents.turn_started.emit(actor)
		
		var skills := actor.stats.get_skill_set().duplicate()
		if actor.stats.move_skill: skills.append(actor.stats.move_skill)
		if actor.stats.pass_skill: skills.append(actor.stats.pass_skill)
		
		for skill in skills:
			var context := {
				"performer": actor,
				"targets": ally + foe
			}
			var valid: bool = skill.passive_validation(context)
			Gui.get_window_by_name("Combat_Window").disable_skill_button(skill.name, valid)


func _on_trigger_broadcast(actor: Actor, trigger: String, context: Dictionary) -> void:
	#print("Received trigger: %s!" % trigger)
	status_manager.receive_trigger(trigger, actor, context)


func _on_skill_used(performer: Actor, targets: Array[Actor], skill: CombatSkill) -> void:
	var action := CombatAction.new()
	action.performer = performer
	action.targets = targets
	
	var allies: Array[Actor] = heroes.duplicate() if performer.side == "HERO" else enemies.duplicate() 
	allies.erase(performer)
	var foes: Array[Actor] = enemies.duplicate() if performer.side == "HERO" else heroes.duplicate() 
	
	var context := {
		"is_crit": false,
		"is_miss": false,
		"performer": performer,
		"target": null,
		"skill_id": skill.name,
		"skill_type": skill.skill_type,
		"allies": allies,
		"enemies": foes,
		"applied_effects": [],
		"effect_data": {},
		"mod_data": {}
	}
	
	for t in targets:
		context["target"] = t
		#print(t.name)
		
		var new_effects: Array[ActionEffect]
		for i in len(skill.effects):
			var effect: ActionEffect = skill.effects[i].duplicate(true)
			var effect_id := "effect_%d" % i
			effect.effect_id = effect_id
			context["effect_data"][effect_id] = {
				"effect_id": effect_id,
				"skill_id": context["skill_id"],
				"skill_type": context["skill_type"],
				"target": t
			}
			effect.context = context
			new_effects.append(effect)
		
		for effect in new_effects:
			var step := effect.declare()
			action.steps.append(step)
		
		for mod in skill.modifiers:
			if mod.should_run(context) and mod.is_global:
				mod.modify_global(context)
		
		if t.side != performer.side:
			var miss_chance : int = 100 - performer.get_stat("Acc") + t.get_stat("Dodge") - skill.accuracy_mod
			#print("Chance to miss: %d%%" % miss_chance)
			var roll: float = randf_range(0, 100)
			context["is_miss"] = roll <= miss_chance
			if context["is_miss"]:
				print("Yeah, it's a miss, bozo!")
		
		if skill.is_crit_valid:
			var crit_chance: int = skill.crit_mod + performer.get_stat("Crit")
			#print("Chance to crit: %d%%" % crit_chance)
			var roll: float = randf_range(0, 100)
			context["is_crit"] = roll <= crit_chance
			if context["is_crit"]:
				print("Yeah, it's a crit.")
		
		for mod in skill.modifiers:
			if mod.should_run(context) and !mod.is_global:
				for effect in new_effects:
					mod.modify(context["effect_data"].get(effect.effect_id, {}))
	
	combat_queue.add_action(action)
	
	switch_battle_phase(CombatPhase.SKILL_RESOLUTION)


func _on_actor_turn_ended(_actor: Actor) -> void:
	if turn_manager.get_active_actor() != null:
		switch_battle_phase(CombatPhase.TURN_START)


func _on_turn_manager_round_ended() -> void:
	turn_manager.initialize_turn_order(heroes + enemies)
	
	if turn_manager.get_active_actor() != null:
		switch_battle_phase(CombatPhase.TURN_START)


func skill_move_actor(_performer: Actor, target: Actor, context: Dictionary) -> void:
	if context["direction"] == -1:
		rank_manager.move_entity_forward(target, target.side, context.get("move_step", 1))
	else:
		rank_manager.move_entity_backward(target, target.side, context.get("move_step", 1))


func skill_move_actor_to_rank(_performer: Actor, target: Actor, context: Dictionary) -> void:
	rank_manager.move_entity(target, target.side, context.get("rank", target.rank))
	rank_manager.slide_entities_forward(target.side)


func skill_apply_status(performer: Actor, target: Actor, context: Dictionary) -> void:
	status_manager.apply_status(performer, target, context)


func skill_remove_status(_performer: Actor, target: Actor, context: Dictionary) -> void:
	status_manager.remove_status(target, context.get("status", ""))


func skill_reduce_status_stack(_performer: Actor, _target: Actor, context: Dictionary) -> void:
	status_manager.reduce_status_stack(context)
