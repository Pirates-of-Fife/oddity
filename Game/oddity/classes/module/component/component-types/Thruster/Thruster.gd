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
var thruster_heat_curve : Curve

@export
var thruster_heat_multiplier : float

@export
var fuel_usage : float

var heat_timer : Timer = Timer.new()

var current_heat : float :
	get:
		return thruster_heat_curve.sample(current_thrust) * thruster_heat_multiplier

var current_fuel_usage : float :
	get:
		return thruster_heat_curve.sample(current_thrust) * fuel_usage

@export
var current_thrust : float :
	set(value):
		current_thrust = clampf(value, 0, 1)

		if thruster_particles != null:
			thruster_particles.amount_ratio = current_thrust

		if thruster_sound != null:
			thruster_sound.volume_db = lerpf(thruster_sound.volume_db, lerpf(-20, 20, current_thrust * modifier), 0.2)
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

	heat_timer.one_shot = false
	heat_timer.timeout.connect(heat_timer_timeout)
	heat_timer.wait_time = 0.1
	add_child(heat_timer)
	heat_timer.start()

func heat_timer_timeout() -> void:
	if module_slot != null:
		module_slot.vehicle.add_heat(current_heat)
		
		if module_slot.vehicle.current_fuel > 0:
			module_slot.vehicle.current_fuel -= current_fuel_usage


func _on_uninsert_thruster(slot : ModuleSlot) -> void:
	current_thrust = 0
