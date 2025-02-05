extends RigidBody3D

class_name Projectile

signal hit(game_entity : GameEntity)

@export
var timeout : float

@export
var on_hit_sound : PackedScene

@export
var collision_timeout : float = 0.05

@export_flags_3d_physics
var projectile_collision_layer : int

@export
var projectile_hit_particle : PackedScene

var damage : float

func _ready() -> void:
	_projectile_ready()
	
func _projectile_ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var timer : Timer = Timer.new()
	var timer_collision : Timer = Timer.new()
	
	add_child(timer)
	add_child(timer_collision)
	
	remove()
	
func remove() -> void:
	await get_tree().create_timer(timeout).timeout
	queue_free()

func activate_collision() -> void:
	collision_layer = projectile_collision_layer
	collision_mask = projectile_collision_layer

func _on_body_entered(body : Node) -> void:	
	if body is GameEntity or body is StaticGameEntity:
		body.take_damage(damage)
		if body is GameEntity:
			hit.emit(body)
		
		var hit_sound : AudioStreamPlayer3D = on_hit_sound.instantiate()
		get_tree().get_first_node_in_group("StarSystem").add_child(hit_sound)
		hit_sound.global_position = global_position
	
	if body is Shield:
		body.take_damage(damage)
		hit.emit(body.game_entity)
	
	var particles : GPUParticles3D = projectile_hit_particle.instantiate()
	get_tree().get_first_node_in_group("StarSystem").add_child(particles)
	particles.global_position = global_position
	
	queue_free()
	
