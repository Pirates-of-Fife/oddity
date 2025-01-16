extends Node3D

@export
var camera : Camera3D


var orbit_distance : float = 35.0   # Distance from the target
var orbit_speed : float = 0.1    # Speed of orbit in radians per second

var ship_loaded : bool = false
var orbit_angle : float = 25.0       # Keeps track of the orbit angle


func _on_main_menu_ui_animation_started() -> void:
	load_last_possessed_starship()

func load_last_possessed_starship() -> void:
	if ship_loaded:
		return

	# Open the file in read mode to retrieve saved data
	var save_file : FileAccess = FileAccess.open("user://last_possessed_starship.save", FileAccess.READ)  # FileAccess
	if save_file:
		var save_data : Dictionary = save_file.get_var()  # Dictionary (retrieved from file)
		save_file.close()

		# Check if the dictionary has the saved "scene_path" key
		if save_data.has("scene_path"):
			var starship_scene : PackedScene = load(save_data["scene_path"])  # PackedScene
			if starship_scene:
				var ship : Node3D = starship_scene.instantiate()
				add_child(ship)
				ship.global_position = Vector3(7, -1, -1)

				ship_loaded = true

func _process(delta: float) -> void:
	if ship_loaded:
		_orbit_camera(delta)

func _orbit_camera(delta: float) -> void:
	var target_position : Vector3 = Vector3.ZERO  # Point to orbit around

	# Increment the angle based on orbit speed and delta time
	orbit_angle += orbit_speed * delta

	# Calculate the new camera position using the orbit angle
	var target_x : float = orbit_distance * cos(orbit_angle)
	var target_z : float = orbit_distance * sin(orbit_angle)
	var target_position_camera : Vector3 = Vector3(target_x, 7, target_z) + target_position


	# Update the camera’s position
	camera.global_transform.origin = camera.global_transform.origin.lerp(target_position_camera, 0.1)  # Adjust 0.1 for smoothing speed

	# Make the camera look at the target position for a continuous focus
	camera.look_at(target_position, Vector3.UP)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://test-scenes/star-system-test-scene/StarSystemTestScene.tscn")

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
