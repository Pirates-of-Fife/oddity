extends Weapon

class_name ProjectileWeapon

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

signal weapon_cooldown_complete
signal projectile_created(projectile : Projectile, weapon : ProjectileWeapon)

@export
var shot_audio : PackedScene

var aim_point : Pip
var aim_assist : float = 6.7

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
	
	if (module_slot.vehicle.current_ammo < (module_resource as ProjectileWeaponResource).ammo_usage):
		return
	
	module_slot.vehicle.current_ammo -= (module_resource as ProjectileWeaponResource).ammo_usage
	
	# spawn projectile
	
	nozzle.rotation = Vector3.ZERO
	var mod : float = 1
	
	if (module_slot.vehicle as Starship).is_bounty_target:
		aim_assist = 50
	
	if (aim_point != null):
		var angle : float = nozzle.global_position.angle_to(aim_point.global_position)
		
		angle = nozzle.global_basis.z.angle_to(aim_point.global_position - nozzle.global_position)
		
		print("angle" + str(angle))
		
		if (angle <= deg_to_rad(aim_assist)):		
			nozzle.look_at(aim_point.global_position)
			mod = -1
	else:
		nozzle.rotation = Vector3.ZERO
		mod = 1
	
	var projectile_scene : PackedScene = (module_resource as WeaponResource).projectile.projectile_scene_file
	var projectile : Projectile = projectile_scene.instantiate()

	projectile_created.emit(projectile, self)

	add_child(projectile)

	projectile.hit.connect(on_hit)
	projectile.damage = module_resource.damage
	projectile.global_position = nozzle.global_position
	projectile.linear_velocity = module_slot.vehicle.linear_velocity

	# apply force

	# projectile.apply_central_impulse(Vector3(0, 0, (module_resource as ProjectileWeaponResource).projectile_speed) * global_basis.inverse())
	
	#projectile.projectile_speed = (module_resource as ProjectileWeaponResource).projectile_speed + (module_slot.vehicle.relative_linear_velocity * module_slot.vehicle.global_basis.inverse())
	
	projectile.projectile_speed = module_slot.vehicle.relative_linear_velocity + Vector3(0, 0, mod * (module_resource as ProjectileWeaponResource).projectile_speed) * nozzle.global_basis.inverse()
	
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
