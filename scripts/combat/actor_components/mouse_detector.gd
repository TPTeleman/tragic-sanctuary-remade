extends Area2D
class_name MouseDetector


func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		ActorEvents.actor_mouse_clicked.emit(get_parent())


func _on_mouse_entered() -> void:
	ActorEvents.actor_mouse_entered.emit(get_parent())


func _on_mouse_exited() -> void:
	ActorEvents.actor_mouse_exited.emit(get_parent())
