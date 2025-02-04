extends Module

class_name Thruster

@export
var size : ModuleSize.ThrusterSize

@export_category("Thruster")

@export
var thruster_sound : AudioStreamPlayer3D

@export
var modifier : float = 1

@export
var current_thrust : float :
	set(value):
		current_thrust = clampf(value, 0, 1)

		if thruster_particles != null:
			thruster_particles.amount_ratio = current_thrust
		
		if thruster_sound != null:
			thruster_sound.volume_db = lerpf(thruster_sound.volume_db, lerpf(-20, 10, current_thrust * modifier), 0.2)
			if current_thrust == 0:
				thruster_sound.stop()
			else:
				if !thruster_sound.playing:
					thruster_sound.play()
	get:
		return current_thrust

@export
var thruster_particles : GPUParticles3D

@onready
var initial_direction : Vector3

func _process(delta: float) -> void:
	_default_process(delta)

	thruster_particles.process_material.set("direction", initial_direction * global_basis.inverse())

func _ready() -> void:
	_thruster_ready()

func _thruster_ready() -> void:
	_module_ready()

	initial_direction = thruster_particles.process_material.get("direction")
	uninserted.connect(_on_uninsert_thruster)

func _on_uninsert_thruster(slot : ModuleSlot) -> void:
	current_thrust = 0
