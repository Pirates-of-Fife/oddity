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

@export
var store_particles : GPUParticles3D

@export
var retrieve_particles : GPUParticles3D

var eva_movement_vector : Vector3
var eva_rotation_vector : Vector3

@export
var meows : Array[AudioStreamWAV]

@export
var meow_player : AudioStreamPlayer3D

func _ready() -> void:
	_humanoid_ready()

func _humanoid_ready() -> void:
	creature_ready()
	
	can_interact_with_entity.connect(_interaction_entity_found)
	toggle_third_person_view.connect(_humanoid_third_person)

func _humanoid_third_person() -> void:
	if third_person:
		$Anchor/TwistPivot/Sprite3D.rotation.y = 0
		$Anchor/TwistPivot/Sprite3D.position.x = 0
	else:
		$Anchor/TwistPivot/Sprite3D.rotation.y = deg_to_rad(180)
		$Anchor/TwistPivot/Sprite3D.position.x = 0.119

func _interaction_entity_found(entity : Node3D) -> void:
	if player == null:
		return
	
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

func play_store_particles() -> void:
	store_particles.emitting = true
	$Anchor/TwistPivot/PitchPivot/CameraAnchor/Marker3D2/AudioStreamPlayer3D.play()

	
func play_release_particles() -> void:
	retrieve_particles.emitting = true
	$Anchor/TwistPivot/PitchPivot/CameraAnchor/Marker3D2/AudioStreamPlayer3D.play()
	
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
		apply_torque(-eva_rotation_vector.z * -anchor.pitch_pivot.global_transform.basis.z * eva_roll_force)		

	eva_movement_vector = Vector3.ZERO
	eva_rotation_vector = Vector3.ZERO
	
	if !is_in_gravity():	
		$Anchor/TwistPivot/Sprite3D.billboard = BaseMaterial3D.BILLBOARD_ENABLED
				
		if !third_person:
			$Anchor/TwistPivot/Sprite3D.hide()
		else:
			$Anchor/TwistPivot/Sprite3D.show()
	else:
		$Anchor/TwistPivot/Sprite3D.billboard = BaseMaterial3D.BILLBOARD_DISABLED
		$Anchor/TwistPivot/Sprite3D.show()
		
		if !third_person:
			if $Anchor/TwistPivot/PitchPivot.rotation.x >= 1.19246299346156:
				$Anchor/TwistPivot/Sprite3D.hide()
			else:
				$Anchor/TwistPivot/Sprite3D.show()

func meow() -> void:
	if meow_player.playing:
		return
		
	meow_player.stream = meows.pick_random()
	meow_player.play()

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
