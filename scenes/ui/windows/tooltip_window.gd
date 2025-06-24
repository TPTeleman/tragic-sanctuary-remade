extends BaseWindow
class_name TooltipWindow

const STATUS_CONTROL: PackedScene = preload("res://scenes/ui/status_container/status_container.tscn")

@onready var status_box: Control = %Status_Box
@onready var desc_lbl: RichTextLabel = %Desc_Lbl



func open() -> void:
	super.open()
	set_process(true)


func close() -> void:
	super.close()
	set_process(false)
	clear_statuses()


func _process(_delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	mouse_position += Vector2(8, 8)
	position = mouse_position


func show_status_descriptions(effects: Array[StatusEffect]) -> void:
	clear_statuses()

	for effect in effects:
		var desc = effect.get_tooltip_description()

		var container = STATUS_CONTROL.instantiate()
		container.get_child(0).texture = desc.icon
		container.get_child(1).text = desc.text
		container.get_child(2).text = "(%d turns)" % desc.duration
		container.get_child(2).visible = desc.duration > 0

		status_box.add_child(container)


func set_statuses(statuses: Array[StatusEffect], type: String) -> void:
	clear_statuses()
	desc_lbl.show()
	size.x = 218
	
	var filtered: Array[StatusEffect] = statuses.filter(func(s): return s.data.status_type == type)
	var lines: Array[String] = []
	
	lines += StatusTooltipBuilder.format_stat_mods(filtered)
	
	desc_lbl.text = "\n".join(lines)


func set_unique_status(statuses: Array[StatusEffect]) -> void:
	clear_statuses()
	desc_lbl.show()
	size.x = 192
	
	var status := statuses[0]
	desc_lbl.text = status.data.get_description()


func set_dots(statuses: Array[StatusEffect]) -> void:
	clear_statuses()
	desc_lbl.show()
	size.x = 164
	
	var filtered: Array[StatusEffect] = statuses.filter(func(s): return s.data.stat_type == "over_time")
	var dot_info := StatusTooltipBuilder.aggregate_dots(filtered)
	var lines := StatusTooltipBuilder.format_dot_tooltip(dot_info)

	desc_lbl.text = "\n".join(lines)


func describe_skill(skill: CombatSkill) -> void:
	clear_statuses()
	desc_lbl.custom_minimum_size.x = 320.0
	desc_lbl.show()
	
	desc_lbl.set_text(Descriptor.Ability[skill.get_ability_name()])


func clear_statuses() -> void:
	for control in status_box.get_children():
		control.queue_free()
	desc_lbl.text = ""
	size = Vector2(32, 0)
	desc_lbl.hide()
