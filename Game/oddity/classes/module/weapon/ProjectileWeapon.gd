extends Weapon

class_name ProjectileWeapon

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

signal weapon_cooldown_complete

@export
var shot_audio : PackedScene

func _ready() -> void:
	__projectile_weapon_ready()

func __projectile_weapon_ready() -> void:
	_weapon_ready()

	weapon_cooldown_timer = Timer.new()
	add_child(weapon_cooldown_timer)
	weapon_cooldown_timer.one_shot = true
	weapon_cooldown_timer.timeout.connect(on_weapon_cooldown_timer_timeout)
	weapon_cooldown_timer.wait_time = (module_resource as WeaponResource).cooldown

#	audio.stream = (module_resource as WeaponResource).sound

func on_weapon_cooldown_timer_timeout() -> void:
	weapon_cooldown_complete.emit()
	cooldown_complete = true

func shoot() -> void:
	# check if cooldown complete
	if cooldown_complete == false:
		return

	# spawn projectile

	var projectile_scene : PackedScene = (module_resource as WeaponResource).projectile.projectile_scene_file
	var projectile : Projectile = projectile_scene.instantiate()

	add_child(projectile)

	projectile.hit.connect(on_hit)
	projectile.damage = module_resource.damage
	projectile.global_position = nozzle.global_position
	projectile.linear_velocity = module_slot.vehicle.linear_velocity

	# apply force

	projectile.apply_central_impulse(Vector3(0, 0, (module_resource as WeaponResource).weapon_force) * global_basis.inverse())
	
	var audio : ProjectileWeaponShootAudioStreamPlayer3D = shot_audio.instantiate()
	audio.pitch_scale = randf_range(0.7, 1.3)
	audio.sound = (module_resource as WeaponResource).sound
	add_child(audio)

	# start cooldown
	cooldown_complete = false
	weapon_cooldown_timer.start()
	
	weapon_shot.emit()

func stop_shooting() -> void:
	weapon_stopped_shooting.emit()
