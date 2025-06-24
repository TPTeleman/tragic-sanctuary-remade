extends Resource
class_name EffectModifier

const KEY = "mod_data"

@export_category("General Settings")
@export var effect_rule: EffectRule
@export var apply_once: bool = false
@export var is_global: bool = false



func should_run(context: Dictionary) -> bool:
	if apply_once and context.get("applied_effects", []).has(self):
		return false
	if effect_rule != null and !effect_rule.validate_target(context):
		return false
	return true


func modify_global(context: Dictionary) -> void:
	if !context.keys().has("applied_effects"):
		context["applied_effects"] = [self]
	elif !context["applied_effects"].has(self):
		context["applied_effects"].append(self)


func modify(context: Dictionary) -> void:
	if !context.keys().has("applied_effects"):
		context["applied_effects"] = [self]
	elif !context["applied_effects"].has(self):
		context["applied_effects"].append(self)
