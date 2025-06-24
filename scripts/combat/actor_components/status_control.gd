extends Control
class_name StatusControl

const STATUS_ICON := preload("res://scenes/ui/status_icon/status_icon.tscn")

@export var actor: Actor

@onready var unique_box: Control = %Unique_Grid
@onready var buffs_rect: TextureRect = %Buffs_Rect
@onready var debuffs_rect: TextureRect = %Debuffs_Rect



func update_statuses() -> void:
	for child in unique_box.get_children():
		child.queue_free()
	
	var has_buff := false
	var has_debuff := false
	var added_ids := {}
	
	for status in actor.get_status_effects():
		if !status.data.visible or added_ids.has(status.data.id):
			continue
	
		added_ids[status.data.id] = true  # Avoid duplicate icons
		if status.data.is_unique:
			var icon := STATUS_ICON.instantiate() as TextureRect
			icon.status = status
			icon.texture = status.data.icon
			icon.actor = actor
			unique_box.add_child(icon)
	
		match status.data.status_type:
			"Buff":
				has_buff = true
			"Debuff":
				has_debuff = true
	
	buffs_rect.visible = has_buff
	debuffs_rect.visible = has_debuff


func _on_buffs_rect_mouse_entered() -> void:
	Gui.open_window_by_name("Tooltip_Window")
	Gui.get_window_by_name("Tooltip_Window").set_statuses(actor.get_status_effects(), "Buff")


func _on_debuffs_rect_mouse_entered() -> void:
	Gui.open_window_by_name("Tooltip_Window")
	Gui.get_window_by_name("Tooltip_Window").set_statuses(actor.get_status_effects(), "Debuff")


func stop_hovering_status() -> void:
	Gui.close_window_by_name("Tooltip_Window")
