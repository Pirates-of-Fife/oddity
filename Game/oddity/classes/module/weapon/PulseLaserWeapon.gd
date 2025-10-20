extends BeamWeapon

class_name PulseLaserWeapon

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

var weapon_fire_time_timer : Timer
var is_firing : bool = false

signal weapon_cooldown_complete
signal weapon_stop_firing

func _ready() -> void:
	_pulse_laser_weapon_ready()

func _pulse_laser_weapon_ready() -> void:
	_weapon_ready()
	
	beam_laser.beam_weapon = self

	var pulse_laser_weapon_resource : PulseLaserWeaponResource = module_resource as PulseLaserWeaponResource

	beam_laser.damage = pulse_laser_weapon_resource.damage
	beam_laser.damage_fall_off = pulse_laser_weapon_resource.damage_fall_off
	beam_laser.max_beam_length = pulse_laser_weapon_resource.max_beam_length
	
	# Cooldown timer - delay between pulses
	weapon_cooldown_timer = Timer.new()
	add_child(weapon_cooldown_timer)
	weapon_cooldown_timer.one_shot = true
	weapon_cooldown_timer.timeout.connect(on_weapon_cooldown_timer_timeout)
	weapon_cooldown_timer.wait_time = pulse_laser_weapon_resource.cooldown
	
	# Fire time timer - duration of each pulse
	weapon_fire_time_timer = Timer.new()
	add_child(weapon_fire_time_timer)
	weapon_fire_time_timer.one_shot = true
	weapon_fire_time_timer.timeout.connect(on_weapon_fire_time_timer_timeout)
	weapon_fire_time_timer.wait_time = pulse_laser_weapon_resource.fire_time

func on_weapon_cooldown_timer_timeout() -> void:
	weapon_cooldown_complete.emit()
	cooldown_complete = true
	
func on_weapon_fire_time_timer_timeout() -> void:
	# Stop firing after fire_time duration
	beam_laser.stop_beam()
	beam_sound.stop()
	weapon_stop_firing.emit()
	is_firing = false
	
	# Start cooldown period
	weapon_cooldown_timer.start()
	cooldown_complete = false

func shoot() -> void:
	# Can only shoot if not in cooldown and not already firing
	if cooldown_complete == false or is_firing:
		return
	
	# Start firing the pulse
	is_firing = true
	beam_laser.start_beam()
	if !beam_sound.playing:
		beam_sound.play()
	
	# Start the fire time timer to stop after duration
	weapon_fire_time_timer.start()

func stop_shooting() -> void:
	# Manual stop - only if firing and fire timer hasn't completed
	if is_firing and weapon_fire_time_timer.time_left > 0:
		beam_laser.stop_beam()
		beam_sound.stop()
		weapon_stop_firing.emit()
		is_firing = false
		weapon_fire_time_timer.stop()
		
		# Start cooldown
		weapon_cooldown_timer.start()
		cooldown_complete = false

func on_hit(game_entity : GameEntity) -> void:
	pass
