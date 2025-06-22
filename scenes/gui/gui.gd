extends CanvasLayer

var windows: Array[BaseWindow] = []



func _ready() -> void:
	for child in get_children():
		if child is BaseWindow:
			var window := child as BaseWindow
			windows.append(window)
			window.on_open.connect(_on_window_opened)
			window.on_close.connect(_on_window_closed)
	
	close_all_windows()


func _on_window_opened(opened_window: BaseWindow) -> void:
	for win in windows:
		if win != opened_window and win.layer == opened_window.layer and win.visible:
			win.close()


func _on_window_closed(_closed_window: BaseWindow) -> void:
	pass


func open_window_by_name(window_name: String) -> void:
	for win in windows:
		if win.name == window_name:
			win.open()
			break


func close_window_by_name(window_name: String) -> void:
	for win in windows:
		if win.name == window_name:
			win.close()
			break


func get_window_by_name(window_name: String) -> BaseWindow:
	for win in windows:
		if win.name == window_name:
			return win
	return null


func close_all_in_layer(target_layer: int) -> void:
	for win in windows:
		if win.layer == target_layer and win.visible:
			win.close()


func close_all_windows() -> void:
	for win in windows:
		if win.visible:
			win.close()
