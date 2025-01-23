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

var is_started : bool = false

func _ready() -> void:
	_beam_laser_projectile_ready()

func _beam_laser_projectile_ready() -> void:
	raycast.target_position.z = max_beam_length
	
func _process(delta: float) -> void:
	_beam_laser_projectile_process(delta)

func start_beam() -> void:
	raycast.enabled = true
	beam_mesh.show()
	is_started = true
	print("beam start")

func stop_beam() -> void:
	raycast.enabled = false
	beam_mesh.hide()
	particles.emitting = false
	is_started = false
	print("beam stop")

func _beam_laser_projectile_process(delta: float) -> void:
	if !is_started:
		return
		
	var cast_point : Vector3
	raycast.force_raycast_update()
		
	if raycast.is_colliding():
		print(raycast.get_collider())
		cast_point = to_local(raycast.get_collision_point())
		
		beam_mesh.mesh.height = cast_point.z
		beam_mesh.position.z = cast_point.z / 2
		particles.position = cast_point
		particles.emitting = true
	else:
		cast_point = raycast.target_position
		particles.emitting = false
