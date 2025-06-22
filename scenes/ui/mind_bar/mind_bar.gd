extends Control
class_name MindBar

@onready var texture: TextureProgressBar = $Texture


func _ready() -> void:
	set_mind(100)


func set_mind(amount: int) -> void:
	texture.value = amount


func on_change_mind(amount: int) -> void:
	var tween := create_tween()
	tween.tween_property(texture, "value", amount, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
