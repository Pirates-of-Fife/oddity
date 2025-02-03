extends ProjectileWeapon

@export
var cooldown_complete_sound : AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__projectile_weapon_ready()
	
	weapon_cooldown_complete.connect(on_cooldown_complete)

func on_cooldown_complete() -> void:
	cooldown_complete_sound.play()
