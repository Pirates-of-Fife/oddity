extends Creature

class_name Humanoid

@export_category("EVA")

@export
var can_eva : bool = true

@export
var eva_speed : float = 5

@export
var eva_force : float = 450

@export
var eva_roll_force : float = 50

var eva_movement_vector : Vector3
var eva_rotation_vector : Vector3

func _ready() -> void:
	_humanoid_ready()

func _humanoid_ready() -> void:
	creature_ready()
	
	can_interact_with_entity.connect(_interaction_entity_found)
	
func _interaction_entity_found(entity : Node3D) -> void:
	if entity == null:
		player.inventory_hud.interaction_icon_visibile = false
		player.inventory_hud.storable_icon_visibile = false
		return
		
	if player != null:
		if player is Player:
			player.inventory_hud.interaction_icon_visibile = true
			
			if player.is_entity_storable(entity):
				player.inventory_hud.storable_icon_visibile = true
			else:
				player.inventory_hud.storable_icon_visibile = false

func humanoid_process(delta : float) -> void:
	pass

func use_inventory_slot(slot : int) -> void:
	if player is not Player:
		return
	
	var p : Player = player
	
	if p.is_inventory_slot_occupied(slot):
		retrieve_entity(slot)
	else:
		store_entity(slot)

func store_entity(slot : int) -> void:
	if player is not Player:
		return
	
	var p : Player = player
	
	var entity : Node3D = interaction_probe()
	
	p.store_item_in_slot(slot, entity)

func retrieve_entity(slot : int) -> void:
	if player is not Player:
		return
	var p : Player = player

	var entity : Node3D = interaction_probe()
	
	if entity != null:
		p.inventory_hud.show_error("Inventory slot occupied")
		return
	
	p.retrieve_item_in_slot(slot)
	
func _physics_process(delta: float) -> void:
	humanoid_physics_process(delta)

func humanoid_physics_process(delta : float) -> void:
	creature_physics_process(delta)

	if !is_in_gravity() and can_eva:
		if relative_linear_velocity.length() > eva_speed:
			linear_damp = zero_g_overspeed_damp
		else:
			linear_damp = zero_g_damp

		apply_central_force(eva_movement_vector * eva_force * anchor.pitch_pivot.global_transform.basis.inverse())
		apply_torque(eva_rotation_vector * eva_roll_force * anchor.pitch_pivot.global_transform.basis.inverse())

	eva_movement_vector = Vector3.ZERO
	eva_rotation_vector = Vector3.ZERO

func eva_move_backwards() -> void:
	eva_movement_vector.z = 1

func eva_move_down() -> void:
	eva_movement_vector.y = -1

func eva_move_forwards() -> void:
	eva_movement_vector.z = -1

func eva_move_left() -> void:
	eva_movement_vector.x = -1

func eva_move_right() -> void:
	eva_movement_vector.x = 1

func eva_move_up() -> void:
	eva_movement_vector.y = 1

func eva_roll_left() -> void:
	eva_rotation_vector.z = -1

func eva_roll_right() -> void:
	eva_rotation_vector.z = 1
