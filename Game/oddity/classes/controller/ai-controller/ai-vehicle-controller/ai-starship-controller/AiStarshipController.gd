extends AiVehicleController

class_name AiStarshipController

var starship_pitch_down_command : StarshipPitchDownCommand = StarshipPitchDownCommand.new()
var starship_pitch_up_command : StarshipPitchUpCommand = StarshipPitchUpCommand.new()
var starship_roll_left_command : StarshipRollLeftCommand = StarshipRollLeftCommand.new()
var starship_roll_right_command : StarshipRollRightCommand = StarshipRollRightCommand.new()
var starship_yaw_left_command : StarshipYawLeftCommand = StarshipYawLeftCommand.new()
var starship_yaw_right_command : StarshipYawRightCommand = StarshipYawRightCommand.new()

var starship_thrust_forward_command : StarshipThrustForwardCommand = StarshipThrustForwardCommand.new()
var starship_thrust_backward_command : StarshipThrustBackwardCommand = StarshipThrustBackwardCommand.new()
var starship_thrust_left_command : StarshipThrustLeftCommand = StarshipThrustLeftCommand.new()
var starship_thrust_right_command : StarshipThrustRightCommand = StarshipThrustRightCommand.new()
var starship_thrust_up_command : StarshipThrustUpCommand = StarshipThrustUpCommand.new()
var starship_thrust_down_command : StarshipThrustDownCommand = StarshipThrustDownCommand.new()

var starship_toggle_landing_gear_command : StarshipToggleLandingGearCommand = StarshipToggleLandingGearCommand.new()

var starship_shoot_primary_command : StarshipShootPrimaryCommand = StarshipShootPrimaryCommand.new()
var starship_shoot_secondary_command : StarshipShootSecondaryCommand = StarshipShootSecondaryCommand.new()

@export_category("AI Settings")

@export
var player_detection_range : float = 20000

@export
var player_engagement_range : float = 300

var evade_change_time : float = 15

@onready
var timer : Timer = Timer.new()

var player : Player
var distance_to_player : float

enum EvasionDirection
{
	EVADE_LEFT,
	EVADE_RIGHT,
	EVADE_UP,
	EVADE_DOWN
}

var current_ai_state : AiState = AiState.NONE

enum AiState
{
	NONE,
	FLYING_TO_PLAYER,
	ENGAGING_PLAYER,
	FLEE
}

var current_evasion : EvasionDirection

func _ready() -> void:
	_ai_starship_controller_ready()

func _ai_starship_controller_ready() -> void:
	_ai_vehicle_controller_ready()
	
	timer.one_shot = false
	timer.wait_time = evade_change_time
	timer.autostart = true
	timer.timeout.connect(change_evasion)
	
	add_child(timer)
	
	change_evasion()
	
	player = get_tree().get_first_node_in_group("Player")
	
	(control_entity as Starship).shield_broken.connect(change_state_to_flee)
	(control_entity as Starship).change_to_damaged_state.connect(change_state_to_flee)
	(control_entity as Starship).shield_online.connect(change_state_back_to_none)
	
	evade_change_time = randf_range(0, 60)


func change_evasion() -> void:
	current_evasion = get_random_evasion()
	
	timer.wait_time = randf_range(1, 20)

func get_random_evasion() -> EvasionDirection:
	return randi_range(0, 3)

func _process(delta: float) -> void:
	_ai_starship_controller_process(delta)

func change_state_to_flee() -> void:
	if (control_entity as Starship).current_hull_health <= (control_entity as Starship).hull_health_damaged_state:
		current_ai_state = AiState.FLEE

func change_state_back_to_none() -> void:
	current_ai_state = AiState.NONE

func _ai_starship_controller_process(delta : float) -> void:
	if player == null:
		return
	
	distance_to_player = (control_entity.global_position - player.global_position).length()
	
	if current_ai_state == AiState.FLEE:
		thrust_towards()
		rotate_away_from_player()
		return
	
	if distance_to_player > player_detection_range:
		current_ai_state = AiState.NONE
	
	if distance_to_player <= player_detection_range:
		current_ai_state = AiState.FLYING_TO_PLAYER
	if distance_to_player <= player_engagement_range:
		current_ai_state = AiState.ENGAGING_PLAYER
	
	if current_ai_state == AiState.FLYING_TO_PLAYER:
		rotate_towards_player()
		thrust_towards()
		
	if current_ai_state == AiState.ENGAGING_PLAYER:
		rotate_towards_player()
		evade()
		shoot_player() 


func rotate_away_from_player() -> void:
	var direction_to_player : Vector3 = (player.global_position - control_entity.global_position) * control_entity.global_basis.inverse()
		
	var normalized_direction: Vector3 = direction_to_player.normalized()
	
	# Determine turn intensity based on the magnitude of the deviation
	# The intensity will be lower the closer the direction is to alignment
	var yaw_intensity: float = pow(abs(normalized_direction.x), 0.5)
	var pitch_intensity: float = pow(abs(normalized_direction.y), 0.5)
		
	if direction_to_player.x > 0:
		starship_yaw_right_command.execute(control_entity, StarshipYawRightCommand.Params.new(yaw_intensity))
	elif direction_to_player.x < 0:
		starship_yaw_left_command.execute(control_entity, StarshipYawLeftCommand.Params.new(yaw_intensity))

	
	if direction_to_player.y > 0:
		starship_pitch_down_command.execute(control_entity, StarshipPitchDownCommand.Params.new(pitch_intensity))
	elif direction_to_player.y < 0:
		starship_pitch_up_command.execute(control_entity, StarshipPitchUpCommand.Params.new(pitch_intensity))
		
func rotate_towards_player() -> void:

	var direction_to_player : Vector3 = (player.global_position - control_entity.global_position) * control_entity.global_basis.inverse().inverse()
		
	var normalized_direction: Vector3 = direction_to_player.normalized()
	
	# Determine turn intensity based on the magnitude of the deviation
	# The intensity will be lower the closer the direction is to alignment
	var yaw_intensity: float = pow(abs(normalized_direction.x), 0.5)
	var pitch_intensity: float = pow(abs(normalized_direction.y), 0.5)
		
	if direction_to_player.x > 0:
		starship_yaw_right_command.execute(control_entity, StarshipYawRightCommand.Params.new(yaw_intensity))
	elif direction_to_player.x < 0:
		starship_yaw_left_command.execute(control_entity, StarshipYawLeftCommand.Params.new(yaw_intensity))

	
	if direction_to_player.y > 0:
		starship_pitch_down_command.execute(control_entity, StarshipPitchDownCommand.Params.new(pitch_intensity))
	elif direction_to_player.y < 0:
		starship_pitch_up_command.execute(control_entity, StarshipPitchUpCommand.Params.new(pitch_intensity))

	
			
func thrust_towards() -> void:
	starship_thrust_forward_command.execute(control_entity, StarshipThrustForwardCommand.Params.new(1))
	
func shoot_player() -> void:
	starship_shoot_primary_command.execute(control_entity)
	starship_shoot_secondary_command.execute(control_entity)
	
func evade() -> void:
	var evasion_amount : float = randf_range(0.1, 0.5)
	
	match current_evasion:
		EvasionDirection.EVADE_LEFT:
			starship_thrust_left_command.execute(control_entity, StarshipThrustLeftCommand.Params.new(evasion_amount))
		EvasionDirection.EVADE_RIGHT:
			starship_thrust_right_command.execute(control_entity, StarshipThrustRightCommand.Params.new(evasion_amount))
		EvasionDirection.EVADE_UP:
			starship_thrust_up_command.execute(control_entity, StarshipThrustUpCommand.Params.new(evasion_amount))
		EvasionDirection.EVADE_DOWN:
			starship_thrust_down_command.execute(control_entity, StarshipThrustDownCommand.Params.new(evasion_amount))
