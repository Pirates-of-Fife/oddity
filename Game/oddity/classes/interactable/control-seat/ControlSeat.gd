extends Interactable

class_name ControlSeat

@export_category("Control Entity")

@export
var target_control_entity : ControlEntity

@export
var control_seat_anchor : Anchor

var player_using_seat : Player
var entity_using_seat : ControlEntity
var entity_parent : Node3D

@export
var spawn_location : Marker3D 

@export_category("Third Person")

@export
var min_distance : float = 10

@export
var max_distance : float = 100

var original_anchor_position : Vector3 = Vector3(0, 1.021, 0)

func _ready() -> void:
	add_to_group("ControlSeat")
	original_anchor_position = control_seat_anchor.position
	
func interact(player : Mind, control_entity : ControlEntity) -> void:
	enter_seat(player, control_entity)
	interacted.emit(player, control_entity)

func enter_seat(player : Mind, control_entity : ControlEntity) -> void:
	if target_control_entity.player != null:
		return
	
	$Sprite3D.show()
	
	entity_parent = control_entity.get_parent_node_3d()
	entity_using_seat = control_entity
	player_using_seat = player
	
	target_control_entity.set_active_anchor(control_seat_anchor)
	player_using_seat.possess(target_control_entity)
	entity_using_seat.reparent.call_deferred(self)
	entity_using_seat.freeze_static()
	entity_using_seat.hide()
	entity_using_seat.global_position = spawn_location.global_position
	
	if target_control_entity is Vehicle:
		target_control_entity.active_control_seat = self
	
func exit_seat() -> void:
	entity_using_seat.unfreeze()
	entity_using_seat.reparent.call_deferred(entity_parent)
	player_using_seat.possess(entity_using_seat)
	
	$Sprite3D.hide()
	
	target_control_entity.third_person = false
	
	entity_using_seat.global_position = spawn_location.global_position
	entity_using_seat.show()

	if target_control_entity is Vehicle:
		target_control_entity.active_control_seat = null
		
	await get_tree().create_timer(0.45).timeout
	
	control_seat_anchor.position = original_anchor_position
	control_seat_anchor.camera_anchor.position = Vector3.ZERO
	control_seat_anchor.reset()

func enter_third_person_view() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		control_seat_anchor.camera_anchor,
		"position",
		Vector3(control_seat_anchor.camera_anchor.position.x, control_seat_anchor.camera_anchor.position.y, 20),
		0.4
	)
	
	tween.tween_property(
		control_seat_anchor,
		"position",
		control_seat_anchor.to_local(target_control_entity.global_position),
		0.4
	)
	
func reset_view() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		control_seat_anchor.camera_anchor,
		"position",
		 Vector3.ZERO,
		0.4
	)
	
	tween.tween_property(
		control_seat_anchor,
		"position",
		original_anchor_position,
		0.4
	)

func increase_distance(distance : float) -> void:
	control_seat_anchor.camera_anchor.position.z += distance
	control_seat_anchor.camera_anchor.position.z = clampf(control_seat_anchor.camera_anchor.position.z, min_distance, max_distance)

func decrease_distance(distance : float) -> void:
	control_seat_anchor.camera_anchor.position.z -= distance
	control_seat_anchor.camera_anchor.position.z = clampf(control_seat_anchor.camera_anchor.position.z, min_distance, max_distance)
