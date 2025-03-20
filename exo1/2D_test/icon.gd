extends Sprite2D

@export var vit:float=1
@export var time:float=1

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	self.rotate(vit*time*delta)
	
	pass
