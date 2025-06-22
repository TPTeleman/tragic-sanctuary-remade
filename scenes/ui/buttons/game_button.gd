extends Control
class_name GameButton

signal on_hover(btn: GameButton)
signal on_unhover(btn: GameButton)
signal on_pressed(btn: GameButton)
signal on_right_pressed(btn: GameButton)

@export_group("Configuration")
@export var normal_size: Vector2 = Vector2(1, 1)
@export var hover_size: Vector2 = Vector2(1.2, 1.2)

var is_hovered: bool = false
var is_selected: bool = false
var is_disabled: bool = false

@onready var panel: Panel = $Background
@onready var highlight: ColorRect = $Background/Highlight_Rect
@onready var darklight: ColorRect = $Background/Disabled_Rect



func _ready() -> void:
	pass


func set_disabled(value: bool) -> void:
	is_disabled = value
	highlight.visible = !value
	darklight.visible = value
	
	if !value:
		set_selected(false)
		is_disabled = false


func set_selected(value: bool) -> void:
	is_selected = value
	highlight.visible = value


func set_hovered(value: bool) -> void:
	is_hovered = value
	
	if value == true:
		var tween := create_tween()
		tween.tween_property(panel, "scale", hover_size, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		var tween := create_tween()
		tween.tween_property(panel, "scale", normal_size, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_mouse_entered() -> void:
	set_hovered(!is_disabled)
	on_hover.emit(self)


func _on_mouse_exited() -> void:
	set_hovered(false)
	on_unhover.emit(self)


func _on_gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			click()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			right_click()


func click() -> void:
	if !is_disabled:
		on_pressed.emit(self)


func right_click() -> void:
	if !is_disabled:
		on_right_pressed.emit(self)
