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

	var starship_scene : PackedScene = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/RABS_KestrelMk1.tscn")

	if starship_scene:
		var ship : Node3D = starship_scene.instantiate()

		var loadout : StarshipLoadout

		var f : FileAccess = FileAccess.open(Globals.PLAYER_SHIP_SAVE, FileAccess.READ)
		if f == null:
			loadout = preload("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")
		else:
			loadout = load(Globals.PLAYER_SHIP_SAVE)

		ship.default_loadout = loadout

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
	$SubViewportContainer/MainMenuUi/LOADING.show()
	$SubViewportContainer/MainMenuUi/LoadingRect.show()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/world/world/MainScene.tscn")

func _on_credits_button_pressed() -> void:
	$SubViewportContainer/MainMenuUi/AnimationPlayer.play("Credits")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_background_music_finished() -> void:
	$BackgroundMusic.play()


func _on_back_pressed() -> void:
	$SubViewportContainer/MainMenuUi/AnimationPlayer.play("CreditsExit")
