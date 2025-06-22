extends Panel
class_name TurnPanel

@onready var icon: TextureRect = %Icon
@onready var selected: TextureRect = %Selected
@onready var side: TextureRect = %Side


func _ready() -> void:
	icon.texture = null
	selected.hide()
	#side.hide()
