extends Control
class_name HealthBar

@onready var damage_off: TextureProgressBar = $Margin_Container/Damage_Offset
@onready var heal_off: TextureProgressBar = $Margin_Container/Heal_Offset
@onready var health_off: TextureProgressBar = $Margin_Container/Health_Offset


func _ready() -> void:
	set_health(100)


func set_health(amount: int) -> void:
	health_off.value = amount
	heal_off.value = amount
	damage_off.value = amount


func on_take_damage(amount: int) -> void:
	health_off.value = amount
	heal_off.value = amount
	
	var tween := create_tween()
	tween.tween_property(damage_off, "value", amount, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func on_recover_health(amount: int) -> void:
	heal_off.value = amount
	damage_off.value = amount
	
	var tween := create_tween()
	tween.tween_property(health_off, "value", amount, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
