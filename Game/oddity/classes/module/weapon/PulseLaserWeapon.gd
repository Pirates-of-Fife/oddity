extends BeamWeapon

class_name PulseLaserWeapon

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

var weapon_fire_time_timer : Timer
var weapon_shot_complete : bool = true

signal weapon_cooldown_complete
signal weapon_stop_firing

func _ready() -> void:
	_beam_weapon_ready()

func _beam_weapon_ready() -> void:
	_weapon_ready()
	
	beam_laser.beam_weapon = self

	var pulse_laser_weapon_resource : PulseLaserWeaponResource = module_resource as PulseLaserWeaponResource

	beam_laser.damage = pulse_laser_weapon_resource.damage
	beam_laser.damage_fall_off = pulse_laser_weapon_resource.damage_fall_off
	beam_laser.max_beam_length = pulse_laser_weapon_resource.max_beam_length
	
	weapon_cooldown_timer = Timer.new()
	add_child(weapon_cooldown_timer)
	weapon_cooldown_timer.one_shot = true
	weapon_cooldown_timer.timeout.connect(on_weapon_cooldown_timer_timeout)
	weapon_cooldown_timer.wait_time = pulse_laser_weapon_resource.cooldown

func on_weapon_cooldown_timer_timeout() -> void:
	weapon_cooldown_complete.emit()
	cooldown_complete = true
	
func on_weapon_shoot_timer_timeout() -> void:
	weapon_stop_firing.emit()
	weapon_shot_complete = true

func shoot() -> void:
	if cooldown_complete == false:
		return
	
	beam_laser.start_beam()
	if !beam_sound.playing:
		beam_sound.play()

func stop_shooting() -> void:
	beam_laser.stop_beam()
	beam_sound.stop()

func on_hit(game_entity : GameEntity) -> void:
	pass
