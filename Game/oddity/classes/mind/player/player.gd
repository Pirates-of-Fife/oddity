extends Mind

class_name Player

signal credits_added(credits : int)
signal credits_removed(credits : int)

signal died
signal respawned

@export
var credits : int

@export
var respawn_star_system : PackedScene

@export
var respawn_body : PackedScene

@export
var respawn_cost : int = 1000

@export
var respawn_hud : CanvasLayer

@export
var hud : CreditHud

var force_respawn_pressed_count : int = 0
var force_respawn_timer : Timer = Timer.new()
var has_died : bool = false

func _ready() -> void:
	_player_ready()

func add_credits(credits : int) -> void:
	self.credits += abs(credits)
	credits_added.emit(abs(credits))
	var world : World = get_tree().get_first_node_in_group("World")
	world.save_player_money_state()

func remove_credits(credits : int) -> void:
	self.credits -= abs(credits)
	credits_removed.emit(abs(credits))
	var world : World = get_tree().get_first_node_in_group("World")
	world.save_player_money_state()

func _player_ready() -> void:
	_mind_ready()
	posses.connect(on_posses)

	force_respawn_timer.one_shot = true
	force_respawn_timer.wait_time = 2
	force_respawn_timer.timeout.connect(force_respawn_timer_timeout)
	add_child(force_respawn_timer)

func force_respawn_timer_timeout() -> void:
	force_respawn_pressed_count = 0



func die() -> void:
	if has_died:
		return

	has_died = true
	
	var default_loadout : StarshipLoadout = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")

	ResourceSaver.save(default_loadout, Globals.PLAYER_SHIP_SAVE)
	
	current_controller.queue_free()

	respawn_hud.show()

	var low_pass_filter : AudioEffectLowPassFilter  = AudioEffectLowPassFilter.new()
	low_pass_filter.cutoff_hz = 500

	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), low_pass_filter, 0)

	var tween : Tween = get_tree().create_tween()
	tween.tween_property(low_pass_filter, "cutoff_hz", 0, 14)
	tween.play()

	await get_tree().create_timer(15).timeout

	remove_credits(respawn_cost)

	respawn()

func respawn() -> void:
	var world : World = get_tree().get_first_node_in_group("World")

	world.respawn_player()
	respawn_hud.hide()
	AudioServer.remove_bus_effect(AudioServer.get_bus_index("Master"), 0)
	has_died = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (Input.is_action_just_released("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().get_first_node_in_group("World").exit_to_main_menu()

	if (Input.is_action_just_pressed("hide_ui")):
		if $HeadsUpDisplay.visible:
			$HeadsUpDisplay.hide()
		else:
			$HeadsUpDisplay.show()

	if (Input.is_action_just_released("player_force_respawn")):
		force_respawn_pressed_count += 1

		if force_respawn_timer.is_stopped():
			force_respawn_timer.start()

		if force_respawn_pressed_count >= 5:
			die()

	if control_entity == null:
		return


func on_posses(control_entity : ControlEntity) -> void:
	if control_entity is Starship:
		save_last_possessed_starship(control_entity)

func save_last_possessed_starship(starship : Starship) -> void:
	var save_data : Dictionary = {}
	save_data["scene_path"] = starship.scene_file_path  # Store scene path, or use a unique ID if preferred

	var save_file : FileAccess = FileAccess.open("user://last_possessed_starship.save", FileAccess.WRITE)

	if save_file:
		save_file.store_var(save_data)
		save_file.close()
