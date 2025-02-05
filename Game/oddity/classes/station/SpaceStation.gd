extends StaticGameEntity

class_name SpaceStation

@export
var station_name : StringName

@export
var space_station_zone : SpaceStationZone

@export
var station_frame_of_reference : FrameOfReference

@export
var rotation_speed : float

var rotate_on : bool = true

@export
var station_label_1 : Label3D

@export
var station_label_2 : Label3D

@export
var donau_walzer_player : BlueDanubePlayer

@export
var speed_limit : float = 100

var enforce_speed_limit : bool = false

func _ready() -> void:
	_space_station_ready()
	
func _space_station_ready() -> void:
	station_label_1.text = station_name
	station_label_2.text = station_name
	station_frame_of_reference.body_entered.connect(_on_player_enter_station)
	station_frame_of_reference.body_exited.connect(_on_player_exit_station)

func _on_player_enter_station(body : Node3D) -> void:
	rotate_on = true

	for i : Node3D in station_frame_of_reference.bodies_in_reference_frame:
		if i is Creature or i is Starship:
			rotate_on = false

func _on_player_exit_station(body : Node3D) -> void:
	rotate_on = true

	for i : Node3D in station_frame_of_reference.bodies_in_reference_frame:
		if i is Creature or i is Starship:
			rotate_on = false	
			
func player_near_station() -> void:
	if !donau_walzer_player.playing:
		donau_walzer_player.resume_playing()

func player_stop_music() -> void:
	donau_walzer_player.pause_playing()
	
func _process(delta: float) -> void:
	_space_station_process(delta)

func _space_station_process(delta : float) -> void:
	if rotate_on:
		rotate(Vector3(1, 0, 0) * global_basis.inverse(), rotation_speed * delta)
	
	if enforce_speed_limit:
		var player : Player = get_tree().get_first_node_in_group("Player")
		
		if player.control_entity is Starship:
			var ship : Starship = player.control_entity
			if ship.current_max_velocity > 100:
				ship.current_max_velocity = speed_limit

func _on_space_station_zone_activate(player: Player, control_entity: ControlEntity) -> void:
	player_near_station()
		
	if player.control_entity is Starship:
		var ship : Starship = player.control_entity
		ship.radio_chatter.start_playing()

func _on_space_station_zone_deactivate(player: Player, control_entity: ControlEntity) -> void:
	player_stop_music()

	if player.control_entity is Starship:
		var ship : Starship = player.control_entity
		ship.radio_chatter.stop_playing()

func _on_player_force_speed_limit_activate(player: Player, control_entity: ControlEntity) -> void:
	enforce_speed_limit = true


func _on_player_force_speed_limit_deactivate(player: Player, control_entity: ControlEntity) -> void:
	enforce_speed_limit = false

func _on_tree_exiting() -> void:
	var p : Player = get_tree().get_first_node_in_group("Player")
	
	if p == null:
		return
	
	var c : ControlEntity = p.control_entity
	if c is Starship:
		c.radio_chatter.stop_playing()
	donau_walzer_player.reparent(c)
	donau_walzer_player.remove_after_play = true
	donau_walzer_player.pause_playing()
