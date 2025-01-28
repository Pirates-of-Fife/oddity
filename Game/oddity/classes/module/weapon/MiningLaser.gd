extends BeamWeapon

class_name MiningLaser

func _ready() -> void:
	_mining_laser_ready()

func _mining_laser_ready() -> void:
	_beam_weapon_ready()

	var beam_weapon_resource : MiningLaserResource = module_resource as MiningLaserResource

	beam_laser.mining_efficiency = beam_weapon_resource.mining_efficiency
	beam_laser.can_extract_resources = true
