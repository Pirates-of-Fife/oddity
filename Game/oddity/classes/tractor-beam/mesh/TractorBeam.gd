extends Node3D

class_name TractorBeam

@export_category("Animation Stuff")

@export
var animator : AnimationPlayer

@export
var yaw : MeshInstance3D

@export
var casing : MeshInstance3D

@export_category("Tractor Beam Laser")

@export
var nozzle : Marker3D

@export
var raycast : RayCast3D

@export
var mesh : MeshInstance3D

@export
var audio : AudioStreamPlayer3D

@export
var particles : GPUParticles3D

@export
var movement_speed : float

@export_category("Utilities")

@export
var area : Area3D

@export
var intermediate_position : Marker3D

@export
var skip_drop_off : bool = false

@export
var cargo_bay_drop_off_position : Marker3D

@export
var cargo_grid : CargoGrid

@export
var ramp : RABS_KestrelMk1_Ramp

@export
var timer_to_start_picking : Timer

@export
var timer_between_picks : Timer

@export
var collision_shapes : Array[CollisionShape3D]

var active : bool
var entities : Array[GameEntity]
var grabbed : GameEntity

var current_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ramp.openable_closing.connect(on_ramp_closing)
	area.body_entered.connect(_on_area_entered)
	area.body_exited.connect(_on_area_exited)
	timer_to_start_picking.timeout.connect(on_start_picking)
	timer_between_picks.timeout.connect(on_pick_next)
	
	for c : CollisionShape3D in collision_shapes:
		c.reparent(area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		return

	if grabbed != null:
		tractor_beam_effects(grabbed)

func on_start_picking() -> void:
	if !active:
		return
	
	var entity_to_grab : GameEntity = pick_entity_to_take()
	
	if entity_to_grab == null:
		timer_to_start_picking.start()
		return
		
	grab(entity_to_grab)

func on_pick_next() -> void:
	if !active:
		return

	var entity_to_grab : GameEntity = pick_entity_to_take()
	
	if entity_to_grab == null:
		timer_to_start_picking.start()
		return
		
	grab(entity_to_grab)
	
func grab(game_entity : GameEntity) -> void:
	game_entity.can_be_picked_up = false
	game_entity.gravity_scale = 0
	grabbed = game_entity
	
	move_to_intermediate()
	start_tractor_beam_effects(grabbed)
	
func move_to_intermediate() -> void:
	var tween : Tween = get_tree().create_tween()
	
	var speed : float = movement_speed
	
	if grabbed.global_position.distance_to(intermediate_position.global_position) > 200:
		speed = movement_speed * 10
	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(
		grabbed,
		"global_position",
		intermediate_position.global_position,
		grabbed.global_position.distance_to(intermediate_position.global_position) / (speed)
	)
	tween.finished.connect(on_intermediate_reached)
	
	current_tween = tween
	
func move_to_destination() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(
		grabbed,
		"global_position",
		cargo_bay_drop_off_position.global_position,
		grabbed.global_position.distance_to(cargo_bay_drop_off_position.global_position) / movement_speed
	)
	tween.finished.connect(on_destination_reached)
	
	current_tween = tween

func on_intermediate_reached() -> void:
	if skip_drop_off: 
		stop_tractor_beam_effects()
		
		current_tween.stop()
		grabbed.can_be_picked_up = true
		grabbed.gravity_scale = 1
		entities.erase(grabbed)
		grabbed = null
		
		timer_between_picks.start()
		
		return
	
	grabbed.linear_velocity = Vector3.ZERO
		
	move_to_destination()

func on_destination_reached() -> void:
	grabbed.can_be_picked_up = true
	grabbed.gravity_scale = 1
	if grabbed is CargoContainer:
		cargo_grid.add_cargo_container(grabbed)
	
	stop_tractor_beam_effects()
	
	current_tween.stop()
	entities.erase(grabbed)
	grabbed = null
	
	timer_between_picks.start()

func start_tractor_beam_effects(game_entity : GameEntity) -> void:
	particles.global_position = game_entity.global_position
	particles.emitting = true
	audio.play()
	mesh.show()
	
func tractor_beam_effects(game_entity : GameEntity) -> void:
	nozzle.look_at((game_entity.global_position) + (nozzle.global_position - game_entity.global_position) * 1000)
	var distance : float = nozzle.global_position.distance_to(game_entity.global_position)
	mesh.mesh.height = distance
	mesh.position.z = distance / 2 / 5
	particles.global_position = game_entity.global_position
	
	yaw.rotation = Vector3.ZERO
	var rotation_vec : Vector3 = yaw.to_local(game_entity.global_position)# + yaw.global_position - game_entity.global_position * 1000)
	rotation_vec.y = 0
	var angle : float = yaw.global_basis.z.angle_to(yaw.global_position - yaw.to_global(rotation_vec))
	yaw.rotation.y = -angle
	
	casing.rotation = Vector3.ZERO
	rotation_vec = casing.to_local(game_entity.global_position)# + yaw.global_position - game_entity.global_position * 1000)
	rotation_vec.x = 0
	angle = casing.global_basis.z.angle_to(casing.global_position - casing.to_global(rotation_vec))
	casing.rotation.x = -angle

func stop_tractor_beam_effects() -> void:
	particles.emitting = false
	audio.stop()
	mesh.hide()
	yaw.rotation = Vector3.ZERO
	casing.rotation = Vector3.ZERO
	
func pick_entity_to_take() -> GameEntity:
	if cargo_grid.cargo_areas_left == 0:
		return null
	
	if entities.size() == 0:
		return null
	
	entities.sort_custom(sort_entities)
	
	var closest : GameEntity = entities[0]
	
	if closest.is_being_held and entities.size() > 1: 
		closest = entities[1] # fool proof, no way the player can hold two entities right?
	
	if !closest.can_be_picked_up:
		return null
	
	return closest

func sort_entities(a : GameEntity, b : GameEntity) -> bool:
	if a.distance_to(global_position) < b.distance_to(global_position):
		if a.can_be_picked_up > b.can_be_picked_up:
			return true
	return false

func _on_area_entered(body : Node) -> void:
	if entities.size() == 0:
		timer_to_start_picking.start()

	if body is GameEntity:
		entities.append(body)

func _on_area_exited(body : Node) -> void:
	if body is GameEntity:
		entities.erase(body)

func activate() -> void:
	if is_door_closed():
		return
	
	if active:
		return
	
	animator.play("TractorBeamExtend")
	active = true
	
	timer_to_start_picking.start()
	
func deactivate() -> void:	
	if !active:
		return
	
	if current_tween != null:
		current_tween.stop()
	if grabbed != null:
		grabbed.can_be_picked_up = true
		grabbed.gravity_scale = 1
		entities.erase(grabbed)
		grabbed = null
	
	stop_tractor_beam_effects()
	animator.play("TractorBeamRetract")
	active = false
	
func on_ramp_closing() -> void:
	deactivate()

func is_door_closed() -> bool:
	return ramp.state == Openable.State.CLOSED or ramp.state == Openable.State.CLOSING
		
