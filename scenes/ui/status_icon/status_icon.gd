extends TextureRect

var actor : Actor
var status : StatusEffect



func _ready():
	texture = status.data.icon
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	custom_minimum_size = Vector2(24, 24)
	mouse_filter = MOUSE_FILTER_PASS


func _on_mouse_entered():
	Gui.open_window_by_name("Tooltip_Window")
	if status.data.status_type == "Unique":
		Gui.get_window_by_name("Tooltip_Window").set_unique_status([status] as Array[StatusEffect])
	elif status.data.status_type == "DoT":
		Gui.get_window_by_name("Tooltip_Window").set_dots(actor.get_status_effects() as Array[StatusEffect])


func _on_mouse_exited():
	Gui.close_window_by_name("Tooltip_Window")
