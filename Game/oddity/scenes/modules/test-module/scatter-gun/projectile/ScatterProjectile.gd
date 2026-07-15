extends Projectile

class_name ScatterProjectile

@export_category("Scatter")

@export
var scattered_projectile : ProjectileResource

@export
var spawn_positions : Array[Marker3D]



var projectile_sound : AudioStream

var secondary_projectile_damage : float

var scatter_time : float 

var scatter_timer : Timer

var original_weapon : ProjectileWeapon

@export
var secondary_projectile_audio : PackedScene

@export
var scatter_particles : GPUParticles3D

func _ready() -> void:
	_scatter_projectile_ready()
	
func _scatter_projectile_ready() -> void:
	_projectile_ready()

# once this method gets executed, all properties are already set.
func scatter_projectiles() -> void:
	for scatter_position_marker : Marker3D in $ScatterPositions.get_children():
		var projectile_scene : PackedScene = scattered_projectile.projectile_scene_file
		var projectile : Projectile = projectile_scene.instantiate()
		
		get_tree().get_first_node_in_group("World").add_child(projectile)

		projectile.hit.connect(original_weapon.on_hit)
		projectile.damage = secondary_projectile_damage
		projectile.global_position = scatter_position_marker.global_position
		projectile.global_rotation = scatter_position_marker.global_rotation
		projectile.linear_velocity = linear_velocity
		
		projectile.apply_central_impulse(projectile_speed * projectile.mass)
		
	var audio : ProjectileWeaponShootAudioStreamPlayer3D = secondary_projectile_audio.instantiate()
	audio.pitch_scale = randf_range(0.7, 1.3)
	audio.sound = projectile_sound
	
	scatter_particles.emitting = true
	
	get_tree().get_first_node_in_group("World").add_child(audio)
	
	
func set_up_timer() -> void:
	scatter_timer = Timer.new()
	scatter_timer.one_shot = true
	scatter_timer.wait_time = scatter_time
	scatter_timer.timeout.connect(_on_scatter_timer_timeout)
	scatter_timer.autostart = true
	add_child(scatter_timer)

	
func _on_scatter_timer_timeout() -> void:
	scatter_projectiles()


func _on_scatter_particle_finished() -> void:
	queue_free()
