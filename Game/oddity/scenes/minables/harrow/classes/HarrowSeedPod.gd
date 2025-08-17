extends CargoContainer

class_name HarrowSeedPod

signal seedpod_destroyed(seedpod : HarrowSeedPod)

@export
var is_on_tree : bool = false

@export
var health : float = 1000

@export
var mesh : Node3D

@export
var sound : AudioStreamPlayer3D

@export
var particles : GPUParticles3D

var original_value : float
var original_health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_seed_pod_ready()
	on_damage_taken.connect(_on_seed_pod_damage_taken)
	on_interact.connect(_on_seed_pod_interact)
	sound.finished.connect(despawn)
	original_value = value
	original_health = health
	
func _seed_pod_ready() -> void:
	_cargo_container_ready()

func despawn() -> void:
	queue_free()

func fall() -> void:
	if is_on_tree:
		freeze = false
		is_on_tree = false
		take_damage(randf_range(100, 1000))
	
func destroyed() -> void:
	seedpod_destroyed.emit(self)
	mesh.hide()
	particles.emitting = true
	sound.play()

func _on_seed_pod_interact() -> void:
	fall()
	
func _on_seed_pod_damage_taken(damage : float) -> void:
	fall()
	
	health -= damage
	
	value = lerpf(0, original_value, health / original_health)
	
	if health <= 0:
		destroyed()
