extends Node2D
class_name Actor

var stats : EntityStats
var sprite : ActorSprite = null
var markers := {
	"Select": false,
	"Valid": false,
	"Active": false,
}
const MARKER_PRIORITY := ["Select", "Valid","Active"]

var size : int = 0
var side : String
var rank : int = -1
var alive := true

@onready var sprite_body : Node2D = %Sprite_Body

@onready var health_bar : HealthBar = %Health_Bar
@onready var active_rect : Control = %Active_Marker
@onready var valid_rect : Control = %Valid_Marker
@onready var select_rect : Control = %Select_Marker


func _ready() -> void:
	set_marker("Select")
	set_marker("Valid")
	set_marker("Active")


func set_body() -> void:
	if stats == null:
		return
	for child in sprite_body.get_children():
		child.queue_free()
	
	sprite = stats.get_entity_sprite().instantiate()
	sprite_body.add_child(sprite)


func set_rank(new_rank: int) -> void:
	rank = new_rank


func get_stat(stat: String) -> int:
	return stats.get_stat(stat)


func get_health() -> int:
	return stats.cur_hp


func get_health_percent() -> int:
	return floor(float(stats.cur_hp) / float(stats.max_hp) * 100)


func set_marker(anc: String, value: bool = false) -> void:
	if !markers.has(anc):
		return
	
	markers[anc] = value
	_update_markers_visibility()


func _update_markers_visibility() -> void:
	var shown := false
	for key in MARKER_PRIORITY:
		var rect: Control = get(key.to_lower() + "_rect")
		if is_instance_valid(rect):
			if !shown and markers[key]:
				rect.visible = true
				shown = true
			else:
				rect.visible = false


func apply_damage(amount: int) -> void:
	stats.reduce_health(amount)
	health_bar.on_take_damage(get_health_percent())


func apply_heal(amount: int) -> void:
	stats.increase_health(amount)
	health_bar.on_recover_health(get_health_percent())
