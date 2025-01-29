extends Module

class_name Thruster

@export
var size : ModuleSize.ThrusterSize

@export_category("Thruster")

@export
var current_thrust : float :
	set(value):
		current_thrust = clampf(value, 0, 1)

		if thruster_particles != null:
			thruster_particles.amount_ratio = current_thrust
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
	uninserted.connect(_on_uninsert)

func _on_uninsert(slot : ModuleSlot) -> void:
	current_thrust = 0
