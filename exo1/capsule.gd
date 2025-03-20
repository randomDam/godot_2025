extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		print("action!")
		
		var v:Vector3 = Vector3(randf_range(-1,1),20,randf_range(-1,1))
		self.apply_central_impulse(v)
	
	pass
