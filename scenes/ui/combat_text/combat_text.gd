extends Control
class_name CombatText

signal finished

var float_speed := Vector2(4.5, -50.0)
var duration := 1.0
var elapsed := 0.0
var start_position := Vector2.ZERO

@onready var label: RichTextLabel = $Label



func _ready():
	start_position = position


func setup(text_value: String, color: Color):
	label.text = text_value
	label.modulate = color
	modulate.a = 1.0


func _process(delta):
	elapsed += delta
	position += float_speed * delta
	modulate.a = lerp(1.0, 0.0, elapsed / duration)

	if elapsed >= duration:
		queue_free()
