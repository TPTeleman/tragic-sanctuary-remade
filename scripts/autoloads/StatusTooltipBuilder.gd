extends Node



func format_stat_mods(effects: Array[StatusEffect]) -> Array[String]:
	var flat_mods := {}
	var percent_mods := {}
	var lines: Array[String] = []
	
	for effect in effects:
		for mod in effect.data.effects:
			if "amount" not in mod:
				continue
			
			var stat = effect.data.stat_type
			var amount = mod.amount
			var key = stat.capitalize()
			
			if mod is CombatStatAdd:
				if !flat_mods.has(key):
					flat_mods[key] = {
						"amount": 0,
						"duration": 0
					}
				flat_mods[key].amount += amount
				flat_mods[key].duration = min(flat_mods[key].duration, effect.duration)
			if mod is CombatStatMultiply or mod is DamageMultiStatus:
				if !percent_mods.has(key):
					percent_mods[key] = {
						"amount": 0,
						"duration": 0
					}
				percent_mods[key].amount += amount
				percent_mods[key].duration = min(percent_mods[key].duration, effect.duration)
	
	for stat in flat_mods:
		var duration := " [color=868686][font_size=14](%d turns)[/font_size][/color]" % flat_mods[stat].duration
		if flat_mods[stat].duration == -1:
			duration = ""
		lines.append("[img=20]%s[/img] %d %s" % [
			ImageCache.StatusIcons.get(stat.to_upper(), ""),
			flat_mods[stat].amount,
			stat
			] + duration)
	
	for stat in percent_mods:
		var duration := " [color=868686][font_size=14](%d turns)[/font_size][/color]" % percent_mods[stat].duration
		if percent_mods[stat].duration == -1:
			duration = ""
		lines.append("[img=20]%s[/img] %d%% %s" % [
			ImageCache.StatusIcons.get(stat.to_upper(), ""),
			percent_mods[stat].amount,
			stat
			] + duration)
	
	return lines

func aggregate_dots(status_effects: Array[StatusEffect]) -> Dictionary:
	var dots := {}
	
	#print(status_effects)
	for effect in status_effects:
		for module in effect.data.actions:
			var id = effect.data.id
			if !dots.has(id):
				dots[id] = {
					"max": 0,
					"duration": effect.duration,
					"icon": effect.data.icon,
					"name": id.capitalize(),
					"text": "DMG" if id != "regen" else "HP"
				}
			if "max_damage" in module:
				dots[id].max += module.max_damage
			if "max_heal" in module:
				dots[id].max += module.max_heal
			dots[id].duration = min(dots[id].duration, effect.duration)
	
	return dots


func format_dot_tooltip(dot_data: Dictionary) -> Array[String]:
	var lines: Array[String] = []
	
	for key in dot_data:
		#print(key)
		var dot: Dictionary = dot_data[key]
		var duration := "[color=868686][font_size=14](%d turns)[/font_size][/color]" % dot.duration
		
		var text := "[img=20]%s[/img] %d %s" % [
			ImageCache.StatusIcons.get(key.to_upper(), ""),
			dot.max,
			dot.text
		]
		lines.append(text+" "+duration)
	
	return lines
