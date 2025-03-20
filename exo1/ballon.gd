extends MeshInstance3D

@export var audio:AudioStream

var material:Material

# comme le setup en processing (une fois au lancement)
func _ready() -> void:
	# je fais un materiau unique
	material = Material.new()
	material = self.mesh.surface_get_material(0).duplicate(true)
	self.material_override = material
	
	# je change la couleur en vert au lancement avec ma fonction
	setColor(Color(0,1,0))
	
	if audio!=null:
		$sound.stream = audio

# comme le draw en processing
func _process(delta: float) -> void:
	pass

# ma fonction set color
func setColor(col:Color):
	self.material_override.set("albedo_color",col)

# mon signal d'entrée : quand un objet rentre dans la zone d'infuence
func _on_area_3d_body_entered(body: Node3D) -> void:
	# si mon objet est le "player"
	if body.name == "Player":
		$sound.play()
		var c:Color = Color(randf(),randf(),randf())
		setColor(c)
