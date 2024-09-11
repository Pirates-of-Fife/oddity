extends OddRigidBody

class_name Player

@export
var id : int

@export
var move_speed = 1

@export
var torque_speed = 1

@export
var parent : Node3D

@export
var is_in_control : bool = false

var players : Array = []

@onready
var player_status = self.get_node("Status")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	physics_parent = parent
	
	var tree_children = get_parent_node_3d().get_children()

	for c in tree_children:
		if c is Player:
			players.append(c)

func set_active():
	player_status.show()
	is_in_control = true
	print(str(id) + " is active")
	
func set_inactive():
	is_in_control = false
	player_status.hide()
	print(str(id) + " is inactive")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_in_control):
		if (Input.is_action_just_pressed("ui_accept")):			
			for c in players:
				if c.id != id:
					print(c)
					set_inactive()
					await get_tree().create_timer(0.5).timeout # waits for 1 second
					c.set_active()
	
func _physics_process(delta: float) -> void:
	if (is_in_control):
		var input_vector = Vector3.ZERO
		input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		input_vector = input_vector.normalized()
		var movement_force = transform.basis * input_vector * move_speed
		
		applied_force = movement_force

		var rotation_torque = 0.0
		if Input.is_action_pressed("rotate_right"):
			rotation_torque -= torque_speed
		elif Input.is_action_pressed("rotate_left"):
			rotation_torque += torque_speed
		
		applied_torque = Vector3(0, 0, rotation_torque)
