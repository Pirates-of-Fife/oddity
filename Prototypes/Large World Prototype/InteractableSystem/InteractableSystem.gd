extends Node3D

@export
var camera : Camera3D

@export
var interaction_distance : float

@export
var disabled : bool = false

#@onready
#var interaction_prompt = interaction_prompt_instance.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (disabled):
		return
	
	var space_state = get_world_3d().direct_space_state
		
	var from = camera.global_position
	var to = camera.global_position + -camera.get_global_transform().basis.z * interaction_distance
	
	var raycast = PhysicsRayQueryParameters3D.create(from, to, 16384)
	
	var result = space_state.intersect_ray(raycast)

	var interactable_object : Interactable

	if (result):
		if (result.collider is Interactable):
			interactable_object = result.collider
	else:
		return
	
	interactable_object.on_look(camera)
			
	if (Input.is_action_just_released("interact")):
		if (result.collider is Interactable):
			result.collider.on_interact()



	

	
