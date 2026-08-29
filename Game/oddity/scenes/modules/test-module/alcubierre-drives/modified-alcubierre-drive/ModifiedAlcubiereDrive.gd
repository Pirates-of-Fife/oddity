extends AlcubierreDrive

class_name ModifiedAlcubierreDrive

@export_category("Modifications")

@export
var special_charge_up_sound : AudioStreamPlayer3D

@export
var special_finished_sound : AudioStreamPlayer3D

@export
var special_charge_up_particles : GPUParticles3D

@export
var special_finish_particles : GPUParticles3D

@export
var deny_sound : AudioStreamPlayer3D

@export
var cool_down_timer : Timer

@export
var cool_down_time : float

var cooled_down : bool = true
var charging : bool = false

@export_category("jump")

@export
var jump_radius : float

@export
var jump_rotation : float

@export
var heat_build_up : float

@export
var fuel_per_jump : float

func _ready() -> void:
	super._ready()
	
	cool_down_timer.wait_time = cool_down_time
	cool_down_timer.one_shot = true
	cool_down_timer.timeout.connect(_on_cooldown_timer_finished)
	
	special_charge_up_sound.finished.connect(_on_charge_up_finished)

func deny() -> void:
	if !deny_sound.playing:
		deny_sound.play()
	
func use_special() -> void:
	if module_slot.vehicle == null:
		return
		
	var ship : Starship = module_slot.vehicle
	
	if ship.is_mass_locked:
		deny()
		return
	
	if !cooled_down:
		deny()
		return
	
	if ship.is_in_abyss:
		deny()
		return
	
	if charging:
		return
	
	charging = true
	
	special_charge_up_particles.emitting = true
	
	special_charge_up_sound.play()

func _on_charge_up_finished() -> void:
	special_charge_up_particles.emitting = false
	
	jump()

func jump() -> void:
	if module_slot.vehicle == null:
		deny()
		return
		
	var ship : Starship = module_slot.vehicle
	
	var new_position : Vector3 = ship.global_position + Vector3(randf_range(-jump_radius, jump_radius), randf_range(-jump_radius, jump_radius), randf_range(-jump_radius, jump_radius))
	var rot : float = deg_to_rad(jump_rotation)
	var new_rotation : Vector3 = ship.global_rotation + Vector3(randf_range(-rot, rot), randf_range(-rot, rot), randf_range(-rot, rot))
	
	special_finish_particles.emitting = true
	special_finished_sound.play()
	
	ship.global_position = new_position
	ship.global_rotation = new_rotation
	ship.add_heat(heat_build_up)
	
	cooled_down = false
	cool_down_timer.start()
	
	ship.current_fuel -= fuel_per_jump


func _on_cooldown_timer_finished() -> void:
	cooled_down = true
	charging = false
