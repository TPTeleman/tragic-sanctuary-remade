extends Sprite2D
class_name ActorSprite

@export var sprites: Array[Sprite2D]



func _ready() -> void:
	if sprites.is_empty():
		sprites.append(self)
		for node: Node2D in get_children():
			if node is Sprite2D:
				sprites.append(node)
			else:
				continue
