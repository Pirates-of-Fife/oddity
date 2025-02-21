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

	var beam_weapon_resource : BeamWeaponResource = module_resource as BeamWeaponResource

	beam_laser.damage = beam_weapon_resource.damage
	beam_laser.damage_fall_off = beam_weapon_resource.damage_fall_off
	beam_laser.max_beam_length = beam_weapon_resource.max_beam_length

func shoot() -> void:
	beam_laser.start_beam()
	if !beam_sound.playing:
		beam_sound.play()

func stop_shooting() -> void:
	beam_laser.stop_beam()
	beam_sound.stop()

func on_hit(game_entity : GameEntity) -> void:
	pass
