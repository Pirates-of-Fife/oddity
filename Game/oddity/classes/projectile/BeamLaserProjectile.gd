extends Node3D

class_name BeamLaserProjectile

signal hit(game_entity : GameEntity)

@export
var damage : float

@export
var max_beam_length : float

@export
var damage_fall_off : Curve

@export
var particles : GPUParticles3D

@export
var raycast : RayCast3D

@export
var beam_mesh : MeshInstance3D

@export
var mining_efficiency : float

@export
var can_extract_resources : bool = false

var timer : Timer = Timer.new()

var is_started : bool = false
var last_hit : Node3D
var hit_distance : float
var hit_position : Vector3

func _ready() -> void:
	_beam_laser_projectile_ready()

func _beam_laser_projectile_ready() -> void:
	raycast.target_position.z = max_beam_length
	
	stop_beam()
	
	timer.autostart = false
	timer.one_shot = false
	timer.wait_time = 0.2
	timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	

func _on_timer_timeout() -> void:
	if last_hit == null:
		return
	
	var damage_at_distance : float = damage_fall_off.sample(hit_distance / max_beam_length) * damage
		
	if last_hit is GameEntity:
		last_hit.take_damage(damage_at_distance)
		hit.emit(last_hit)
	
	if last_hit is Shield:
		last_hit.take_damage(damage_at_distance)
	
	if last_hit is StaticGameEntity:
		last_hit.take_damage(damage_at_distance)
		hit.emit(last_hit)
	
	# Mining Stuff here later
	
	if can_extract_resources:
		if last_hit is Minable:
			var mining_efficiency_at_distance : float = damage_fall_off.sample(hit_distance / max_beam_length) * mining_efficiency
			last_hit.mine(mining_efficiency_at_distance, hit_position)
			hit.emit(last_hit)

func _process(delta: float) -> void:
	_beam_laser_projectile_process(delta)

func start_beam() -> void:
	raycast.enabled = true
	beam_mesh.show()
	is_started = true
	raycast.target_position.z = max_beam_length
	
	if timer.is_stopped():
		timer.start()

func stop_beam() -> void:
	raycast.enabled = false
	beam_mesh.hide()
	particles.emitting = false
	is_started = false
	timer.stop()

func _beam_laser_projectile_process(delta: float) -> void:
	if !is_started:
		return
		
	var cast_point : Vector3
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		cast_point = to_local(raycast.get_collision_point())
		last_hit = raycast.get_collider()
		beam_mesh.mesh.height = cast_point.z
		beam_mesh.position.z = cast_point.z / 2
		hit_distance = cast_point.z
		hit_position = raycast.get_collision_point()
		particles.position = cast_point
		particles.emitting = true
	else:
		last_hit = null
		cast_point = raycast.target_position
		beam_mesh.mesh.height = cast_point.z
		beam_mesh.position.z = cast_point.z / 2
		particles.emitting = false
