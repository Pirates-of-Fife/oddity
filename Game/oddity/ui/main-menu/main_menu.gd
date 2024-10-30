extends Node3D

@export
var camera : Camera3D

var tween : Tween
var orbit_distance : float = 30.0  # Distance from the target
var orbit_speed : float = 1.0      # Speed of the orbit in radians per second

var ship_loaded : bool = false

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
				add_child(starship_scene.instantiate())
				ship_loaded = true
				
	start_camera_orbit()


func _ready() -> void:
	# Initialize the tween for smooth camera movement
	tween = Tween.new()

	# Optionally, start orbiting camera right away
	start_camera_orbit()

func start_camera_orbit() -> void:
	#tween.stop_all()
	_orbit_camera()

func _orbit_camera(delta: float = 0.0) -> void:
	var target_position : Vector3 = Vector3.ZERO  # Point to orbit around
	var angle : float = orbit_speed * delta

	# Calculate new camera position on a circular path around the target
	var new_x : float = orbit_distance * cos(angle)
	var new_z : float = orbit_distance * sin(angle)
	var new_position : Vector3 = Vector3(new_x, 0, new_z) + target_position

	# Smoothly move the camera to this new position with the Tween
	tween.tween_property(camera, "global_transform.origin", new_position, 1.0)
