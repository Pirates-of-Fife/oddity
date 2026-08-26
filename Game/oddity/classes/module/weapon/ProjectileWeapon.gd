extends Weapon

class_name ProjectileWeapon

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

signal weapon_cooldown_complete
signal projectile_created(projectile : Projectile, weapon : ProjectileWeapon)

@export
var shot_audio : PackedScene

func _ready() -> void:
	__projectile_weapon_ready()

func __projectile_weapon_ready() -> void:
	_weapon_ready()
	
	aim_assist = 10
	
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
	
	if (module_slot.vehicle.current_ammo < (module_resource as ProjectileWeaponResource).ammo_usage):
		return
	
	module_slot.vehicle.current_ammo -= (module_resource as ProjectileWeaponResource).ammo_usage
	
	# spawn projectile
	
	nozzle.rotation = Vector3.ZERO
	var mod : float = 1
	
	if (module_slot.vehicle as Starship).is_bounty_target:
		aim_assist = 70
	
	if (aim_point != Vector3.ZERO):
		var angle : float = nozzle.global_basis.z.angle_to(aim_point - nozzle.global_position)
		
		if (angle <= deg_to_rad(aim_assist)):		
			nozzle.look_at(aim_point)
			mod = -1
	else:
		nozzle.rotation = Vector3.ZERO
		mod = 1
	
	var projectile_scene : PackedScene = (module_resource as WeaponResource).projectile.projectile_scene_file
	var projectile : Projectile = projectile_scene.instantiate()

	projectile_created.emit(projectile, self)

	add_child(projectile)

	projectile.hit.connect(on_hit)
	projectile.hull_damage = module_resource.hull_damage
	projectile.shield_damage = module_resource.shield_damage
	projectile.penetration = module_resource.penetration
	projectile.global_position = nozzle.global_position
	projectile.global_rotation = nozzle.global_rotation
	projectile.linear_velocity = module_slot.vehicle.linear_velocity


	var velocity : Vector3 = nozzle.global_basis * Vector3(0, 0, mod * (module_resource as ProjectileWeaponResource).projectile_speed)
	
	projectile.apply_central_impulse(velocity * projectile.mass)
	
	var audio : ProjectileWeaponShootAudioStreamPlayer3D = shot_audio.instantiate()
	audio.pitch_scale = randf_range(0.7, 1.3)
	audio.sound = (module_resource as WeaponResource).sound
	add_child(audio)

	# start cooldown
	cooldown_complete = false
	weapon_cooldown_timer.start()

	weapon_shot.emit()
	
	if (module_slot != null):
		module_slot.vehicle.add_heat((module_resource as ProjectileWeaponResource).heat_per_shot)
		
func stop_shooting() -> void:
	weapon_stopped_shooting.emit()
