extends Module

class_name Weapon

@export_category("Size")

@export
var size : ModuleSize.HardpointSize

@export_category("Weapon")

@export
var nozzle : Marker3D

var weapon_cooldown_timer : Timer
var cooldown_complete : bool = true

signal weapon_shot
signal weapon_hit(target : GameEntity)
signal weapon_cooldown_complete

func _ready() -> void:
	_weapon_ready()
	
func _weapon_ready() -> void:
	_module_ready()
	
	weapon_cooldown_timer = Timer.new()
	add_child(weapon_cooldown_timer)
	weapon_cooldown_timer.one_shot = true
	weapon_cooldown_timer.timeout.connect(on_weapon_cooldown_timer_timeout)
	weapon_cooldown_timer.wait_time = (module_resource as WeaponResource).cooldown

func on_weapon_cooldown_timer_timeout() -> void:
	weapon_cooldown_complete.emit()
	cooldown_complete = true
	pass

func shoot() -> void:
	# check if cooldown complete
	if cooldown_complete == false:
		return
	
	# spawn projectile
	
	var projectile_scene : PackedScene = (module_resource as WeaponResource).projectile.projectile_scene_file
	var projectile : Projectile = projectile_scene.instantiate()
	projectile.global_position = nozzle.global_position
	projectile.linear_velocity = module_slot.vehicle.linear_velocity
	
	add_child(projectile)
	
	# apply force
	
	projectile.apply_central_impulse(Vector3(0, 0, (module_resource as WeaponResource).weapon_force) * global_basis.inverse())
	
	# start cooldown
	cooldown_complete = false
	weapon_cooldown_timer.start()
	
