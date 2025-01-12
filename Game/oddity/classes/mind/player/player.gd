extends Mind

class_name Player

signal credits_added(credits : int)
signal credits_removed(credits : int)

@export
var credits : int 


func _ready() -> void:
	_player_ready()

func add_credits(credits : int) -> void:
	self.credits += abs(credits)
	credits_added.emit(abs(credits))
	
func remove_credits(credits : int) -> void:
	self.credits -= abs(credits)
	credits_removed.emit(abs(credits))

func _player_ready() -> void:
	_mind_ready()
	posses.connect(on_posses)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (Input.is_action_just_released("ui_cancel")):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://ui/main-menu/MainMenu.tscn")

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
