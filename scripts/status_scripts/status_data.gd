extends Resource
class_name StatusData

@export var id : String
@export_multiline var description: String = ""
@export_enum("Buff","Debuff","Unique","DoT") var status_type : String
@export_enum("Debuff","Bleed","Blight","Burn","Move","Stun") var res_type : String
@export_enum("turn_start","turn_end","round_start","round_end","damage_received","damage_dealt","heal_given",
"heal_received","moved","target","dot_applied","on_resist_effect") var trigger : String

@export var stat_type : String
@export var icon : Texture2D
@export var effects : Array[StatusModifier]
@export var actions : Array[ActionEffect]

@export var visible : bool = true
@export var is_unique : bool = false
@export var only_one : bool = false

@export_category("Duration & Stacking")
@export var max_duration : int = -1
@export var stacks : bool = false
@export var max_stacks : int = -1
@export var stack_duration : bool = false



func get_description() -> String:
	return description
