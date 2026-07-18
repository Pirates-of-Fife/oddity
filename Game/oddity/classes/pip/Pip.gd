extends Sprite3D

class_name Pip

@export
var aimer : Starship

@export
var target : Starship

@export
var gun : ProjectileWeapon

@export
var projectile_speed : float

var enemy_pip : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_pip:
		texture = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		queue_free()
		return
	
	if aimer == null:
		queue_free()
		return
	
	var projectile_vector : Vector3 = aimer.linear_velocity + Vector3(0, 0, projectile_speed) * aimer.global_basis
	
	global_position = get_intercept(aimer.global_position, projectile_vector.length(), target.global_position, target.linear_velocity - aimer.linear_velocity)
	
	if gun != null:
		gun.aim_point = global_position

func _exit_tree() -> void:
	if gun != null:
		gun.aim_point = Vector3.ZERO

func get_intercept(shooter_position : Vector3, projectile_speed : float, target_position : Vector3, target_velocity : Vector3) -> Vector3:
	var a : float = projectile_speed * projectile_speed - target_velocity.dot(target_velocity)
	var b : float = 2 * target_velocity.dot(target_position - shooter_position)
	var c : float = (target_position - shooter_position).dot(target_position - shooter_position)
	
	var time : float = 0.0
	
	if projectile_speed > target_velocity.length():
		time = (b + sqrt(b * b + 4 * a * c)) / (2 * a)
		
	return target_position + (time * target_velocity)
	
