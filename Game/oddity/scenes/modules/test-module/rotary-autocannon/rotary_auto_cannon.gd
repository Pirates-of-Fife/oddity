extends ProjectileWeapon

@export
var barrel_mesh : MeshInstance3D

var firing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__projectile_weapon_ready()
	
	weapon_shot.connect(_on_shoot)
	weapon_stopped_shooting.connect(_on_stop_shooting)

func _on_shoot() -> void:
	firing = true

func _on_stop_shooting() -> void:
	firing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if firing:
		barrel_mesh.rotate_z(15)
