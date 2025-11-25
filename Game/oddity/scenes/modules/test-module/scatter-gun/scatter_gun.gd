extends ProjectileWeapon

class_name ScatterWeapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_scatter_weapon_ready()

func _scatter_weapon_ready() -> void:
	__projectile_weapon_ready()
	
	projectile_created.connect(_on_projectile_created)

func _on_projectile_created(projectile : Projectile, original_weapon : ProjectileWeapon) -> void:
	if (projectile is not ScatterProjectile):
		return
	
	var scatter_projectile : ScatterProjectile = projectile
	
	scatter_projectile.projectile_force = (module_resource as ScatterGunResource).secondary_projectile_force
	scatter_projectile.projectile_sound = (module_resource as ScatterGunResource).secondary_projectile_sound
	scatter_projectile.scattered_projectile = (module_resource as ScatterGunResource).secondary_projectile
	scatter_projectile.secondary_projectile_damage = (module_resource as ScatterGunResource).secondary_projectile_damage
	scatter_projectile.original_weapon = original_weapon
	
