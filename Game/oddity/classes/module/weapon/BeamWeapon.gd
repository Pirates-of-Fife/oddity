extends Weapon

class_name BeamWeapon

@export_category("Beam")

@export
var beam_laser : BeamLaserProjectile

@export
var beam_sound : AudioStreamPlayer3D

func _ready() -> void:
	_beam_weapon_ready()

func _beam_weapon_ready() -> void:
	_weapon_ready()
	
	aim_assist = 5
	
	beam_laser.beam_weapon = self

	var beam_weapon_resource : BeamWeaponResource = module_resource as BeamWeaponResource

	beam_laser.shield_damage = beam_weapon_resource.shield_damage
	beam_laser.hull_damage = beam_weapon_resource.hull_damage
	beam_laser.damage_fall_off = beam_weapon_resource.damage_fall_off
	beam_laser.max_beam_length = beam_weapon_resource.max_beam_length
	
	beam_laser.reparent(nozzle)

func shoot() -> void:
	nozzle.rotation = Vector3.ZERO
		
	if (module_slot.vehicle as Starship).is_bounty_target:
		aim_assist = 20
	
	if (aim_point != Vector3.ZERO):
		var angle : float = nozzle.global_position.angle_to(aim_point)
		
		angle = nozzle.global_basis.z.angle_to(aim_point - nozzle.global_position)
				
		if (angle <= deg_to_rad(aim_assist)):		
			nozzle.look_at(to_global(-to_local(aim_point)))			
	else:
		nozzle.rotation = Vector3.ZERO

	beam_laser.start_beam()
	if !beam_sound.playing:
		beam_sound.play()

func stop_shooting() -> void:
	beam_laser.stop_beam()
	beam_sound.stop()

func on_hit(game_entity : GameEntity) -> void:
	pass

