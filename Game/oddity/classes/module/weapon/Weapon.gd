extends Module

class_name Weapon

@export
var size : ModuleSize.HardpointSize

@export
var nozzle : Marker3D

@export
var projectile : PackedScene

@export
var force : float

@export
var cooldown_timer : Timer

@export
var spawner : MultiplayerSpawner

var can_shoot : bool = true

func _ready() -> void:
	_module_ready()
	_initialize_collision_shape()

func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()
	
	var module_size : ModuleSize = ModuleSize.new()
	
	box_shape.size = module_size.get_hardpoint_size(size)
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	
	collision_shape.shape = box_shape
		
	add_child(collision_shape)
	
@rpc("any_peer", "call_local")
func shoot() -> void:
	if !can_shoot:
		return
		
	var p : Projectile = projectile.instantiate()
	
	get_tree().get_first_node_in_group("World").add_child(p)
		
	p.global_position = nozzle.global_position
	p.global_rotation = nozzle.global_rotation
	p.apply_central_impulse(Vector3(0, 0, force) * global_basis.inverse())
	can_shoot = false
	cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
