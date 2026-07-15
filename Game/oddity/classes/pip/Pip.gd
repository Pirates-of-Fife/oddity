extends Sprite3D

class_name Pip

@export
var aimer : Starship

@export
var target : Starship

@export
var projectile_speed : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null:
		queue_free()
		return
		

	var projectile_vector : Vector3 = aimer.relative_linear_velocity + Vector3(0, 0, projectile_speed) * aimer.global_basis.inverse()
	var target_relative_vector : Vector3 = aimer.global_position - target.global_position
	var distance : float = target_relative_vector.length()
	var hit_time : float = distance / projectile_vector.length()
	
	
	
	global_position = get_intercept(aimer.global_position, projectile_vector.length(), target.global_position, target.linear_velocity - aimer.linear_velocity)
	print("Global diff: " + str(global_position - target.global_position) + " dist: " + str((global_position - target.global_position).length()))
	
	#print(target.linear_velocity + aimer.linear_velocity)
	#global_position = target.global_position + hit_time * (target.linear_velocity + aimer.linear_velocity) * target.global_basis.inverse()
	
	#global_position = target.global_position + Vector3(0, 0, projectile_vector.length()) * (target.linear_velocity + aimer.linear_velocity) * target.global_basis.inverse()
	
func get_intercept(shooter_position : Vector3, projectile_speed : float, target_position : Vector3, target_velocity : Vector3) -> Vector3:
	var a : float = projectile_speed * projectile_speed - target_velocity.dot(target_velocity)
	var b : float = 2 * target_velocity.dot(target_position - shooter_position)
	var c : float = (target_position - shooter_position).dot(target_position - shooter_position)
	
	var time : float = 0.0
	
	print("a: " + str(a))
	print("b: " + str(b))
	print("c: " + str(c))
	
	print("proj _speed: " + str(projectile_speed))
	print("targ_speed: " + str(target_velocity.length()))
	
	if projectile_speed > target_velocity.length():
		time = (b + sqrt(b * b + 4 * a * c)) / (2 * a)
		print(time)
		
	return target_position + (time * target_velocity)
	
