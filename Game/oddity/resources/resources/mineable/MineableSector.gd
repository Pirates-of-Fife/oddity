extends Node3D

class_name MineableSector

@export
var mineable_transforms : Array 

@export_range(0.1, 1, 0.05)
var update_rate : float = 0.5

@export_range(10, 1000, 5, "or_greater")
var spawn_radius : float

var timer : Timer = Timer.new()

@export
var mineable_resource : MineableResource

@export
var mineable_spawn_root : Node3D

@export
var zone : PlayerDetectionZone

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	timer.autostart = false
	timer.wait_time = update_rate
	timer.one_shot = false
	timer.timeout.connect(_timer_timeout)
	add_child(timer)
	
	zone.activate.connect(_on_player_area_entered)
	zone.deactivate.connect(_on_player_area_exited)
	
func _timer_timeout() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	
	
	if player == null:
		return
		
	
	spawn_mineables(get_nearby_instances(to_local(player.global_position), spawn_radius))
	
func _on_player_area_entered(player : Player, control_entity : ControlEntity) -> void:
	timer.start()
	
func _on_player_area_exited(player : Player, control_entity : ControlEntity) -> void:
	timer.stop()
	despawn_mineables()

func get_nearby_instances(center: Vector3, radius: float) -> Array:
	var result : Array = []
	
	var r2 : float = radius * radius
	
	for i : int in range(mineable_transforms.size()):
		var mineable : MineableTransform = mineable_transforms[i]
		
		if center.distance_squared_to(mineable.mineable_transform.origin) <= r2:
			result.append(mineable)
				
	return result

func spawn_mineables(array : Array) -> void:
	for m : MineableTransform in array:
		if m.is_mineable_spawned:
			continue
		
		var mineable : PackedScene = mineable_resource.variants.pick_random()
		
		var instance : Minable = mineable.instantiate()
		instance.mineable_resource = mineable_resource
		
		mineable_spawn_root.add_child(instance)
		instance.transform = m.mineable_transform
		
		m.is_mineable_spawned = true

func despawn_mineables() -> void:
	for i : Node in mineable_spawn_root.get_children():
		i.queue_free()
	
	for m : MineableTransform in mineable_transforms:
		m.is_mineable_spawned = false
		
func append_transform(t : Transform3D) -> void:
	var mineable_transform : MineableTransform = MineableTransform.new()
	mineable_transform.index = mineable_transforms.size()
	mineable_transform.mineable_transform = t
	mineable_transform.mineable_transform.origin = to_local(mineable_transform.mineable_transform.origin)
	mineable_transforms.append(mineable_transform)
	
func spawn_placeholder_objects() -> void:
	var scene : PackedScene = load("res://classes/game-entity/static-game-entity/minable/placeholder_object.tscn")
	
	for i : MineableTransform in mineable_transforms:
		var a : Node3D = scene.instantiate()
		mineable_spawn_root.add_child(a)
		a.position = i.mineable_transform.origin
