@tool
extends Node3D

@export_range(0, 100, 1) var nbre: int = 50
@export var object_to_copy:Node = null
@export var object_cible:Node = null
@export var object_scale:float = 0.3
@export var coef_scale:float = 0.01
@export var invert:bool = false
@export var object_decalage:float = 0.3
@export var coef_rot:float = 0.01
@export var is_snap_to_ground:bool = false

@export_tool_button(&"populate") var populate_action = populate
func populate():
	comput()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#delete all objects in items
	get_tree().create_timer(2).timeout
	if object_cible!=null and object_to_copy!=null:
		comput()
	else:
		push_error("merci de remplir les objets")
	pass

func comput():
	clear_children(object_cible)
	if object_to_copy:
		for i in range(-nbre/2,nbre/2):
			for j in range(-nbre/2,nbre/2):
				var new_object = object_to_copy.duplicate()
				object_cible.add_child(new_object)
				new_object.position = Vector3(i*object_decalage, 0, j*object_decalage)
				var distance = object_cible.global_transform.origin.distance_to(new_object.global_transform.origin)
				
				var s
				if invert:
					s = object_scale-randf_range(0,coef_scale)*distance
				else :
					s = randf_range(object_scale,distance*coef_scale)
				new_object.scale = Vector3(s,s,s)
				
				var rx=distance*randf_range(0, coef_rot)
				var ry=distance*randf_range(0, coef_rot)
				var rz=distance*randf_range(0, coef_rot)
				new_object.rotation = Vector3(rx,ry,rz)
				#new_object.owner = self.get_parent() # works
				if is_snap_to_ground:
					snap_to_ground(new_object)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if object_cible!=null and object_to_copy!=null:
		for ob in object_cible.get_children():
			ob.rotate_y(0.01)
	pass


#clear all objects
func clear_children(ob:Node):
	for child in ob.get_children():
		child.queue_free()  # Marks for deletion at the end of the frame

func snap_to_ground(ob):
	var space_state = get_world_3d().direct_space_state
	var origin = ob.global_transform.origin
	var ray_start = origin + Vector3(0, 10, 0)  # Lancer le rayon 1 unité au-dessus
	var ray_end = origin + Vector3(0, -20, 0)  # Et 10 unités en dessous
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	var result = space_state.intersect_ray(query)
	
	if result.has("position"):
		ob.global_transform.origin.y = result["position"].y  # Place l'objet sur le sol
