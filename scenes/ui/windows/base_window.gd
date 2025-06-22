extends Control
class_name BaseWindow

signal on_open(window: BaseWindow)
signal on_close(window: BaseWindow)

@export var layer: int = 0


func open() -> void:
	visible = true
	on_open.emit(self)


func close() -> void:
	visible = false
	on_close.emit(self)
