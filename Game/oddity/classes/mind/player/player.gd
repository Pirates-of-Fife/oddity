extends Mind

class_name Player

signal credits_added(credits : int)
signal credits_removed(credits : int)

signal died
signal respawned

@export
var credits : int

@export
var respawn_star_system : PackedScene

@export
var respawn_body : PackedScene

@export
var respawn_cost : int = 1000

@export
var respawn_hud : CanvasLayer

@export
var hud : CreditHud

@export
var inventory_hud : InventoryHud

@export
var inventory : PlayerInventoryResource

var force_respawn_pressed_count : int = 0
var force_respawn_timer : Timer = Timer.new()
var has_died : bool = false

func _ready() -> void:
	_player_ready()

func add_credits(credits : int) -> void:
	self.credits += abs(credits)
	credits_added.emit(abs(credits))
	var world : World = get_tree().get_first_node_in_group("World")
	world.save_player_money_state()

func remove_credits(credits : int) -> void:
	self.credits -= abs(credits)
	credits_removed.emit(abs(credits))
	var world : World = get_tree().get_first_node_in_group("World")
	world.save_player_money_state()

func _player_ready() -> void:
	_mind_ready()
	posses.connect(on_posses)

	force_respawn_timer.one_shot = true
	force_respawn_timer.wait_time = 2
	force_respawn_timer.timeout.connect(force_respawn_timer_timeout)
	add_child(force_respawn_timer)

func force_respawn_timer_timeout() -> void:
	force_respawn_pressed_count = 0

func store_item_in_slot(slot : int, entity : Node3D) -> void:
	if !is_entity_storable(entity):
		return
	
	if is_inventory_slot_occupied(slot):
		inventory_hud.show_error("slot occupied")
		return
	
	var inventory_slot : InventoryGameEntitySlot = create_inventory_slot_resource(entity)
			
	if entity is CargoContainer:
		if entity.snapped_to != null:
			entity.unsnap_from_grid()
	
	if entity is Module:
		if entity.module_slot != null:
			entity.uninsert()
	
	if entity is GameEntity:
		if entity.is_being_held:
			if control_entity is Creature:
				control_entity.drop()
		
		entity.queue_free()
	
	inventory_hud.store_item_in_slot(slot, inventory_slot)
	
	match slot:
		1:
			inventory.inventory_slot_1 = inventory_slot
		2:
			inventory.inventory_slot_2 = inventory_slot
		3:
			inventory.inventory_slot_3 = inventory_slot
		4:
			inventory.inventory_slot_4 = inventory_slot
		5:
			inventory.inventory_slot_5 = inventory_slot


func is_entity_storable(entity : Node3D) -> bool:
	if entity == null:
		inventory_hud.show_error("NO ENTITY TO STORE")
		return false
	
	if entity is StaticGameEntity:
		inventory_hud.show_error("Cannot store " + str(entity.entity_name))
		return false
		
	if entity is CargoContainer:
		if entity.container_size != CargoUnit.ContainerSize.CU_1:
			inventory_hud.show_error("Cannot store large cargo containers")
			return false
	
	if entity is Component:
		if entity.size > ModuleSize.ComponentSize.SIZE_2:
			inventory_hud.show_error("Cannot store large components")
			return false
	
	if entity is Weapon:
		inventory_hud.show_error("Cannot store large weapons")
		return false
	
	return true

func retrieve_item_in_slot(slot : int) -> void:
	if !is_inventory_slot_occupied(slot):
		return
		
	inventory_hud.retrieve_item_in_slot(slot)
	
	if control_entity is not Creature:
		return
	
	var creature : Creature = control_entity
	var entity : GameEntity
	
	match slot:
		1:
			entity = create_entity_from_inventory_slot_resource(inventory.inventory_slot_1)
			
			inventory.inventory_slot_1 = null
		2:
			entity = create_entity_from_inventory_slot_resource(inventory.inventory_slot_2)
			
			inventory.inventory_slot_2 = null
		3:
			entity = create_entity_from_inventory_slot_resource(inventory.inventory_slot_3)
			
			inventory.inventory_slot_3 = null
		4:
			entity = create_entity_from_inventory_slot_resource(inventory.inventory_slot_4)
			
			inventory.inventory_slot_4 = null
		5:
			entity = create_entity_from_inventory_slot_resource(inventory.inventory_slot_5)
			
			inventory.inventory_slot_5 = null

	get_tree().get_first_node_in_group("World").add_child(entity)
	
	entity.global_position = creature.pick_up_location.global_position
	entity.global_rotation = creature.pick_up_location.global_rotation


func create_inventory_slot_resource(entity : GameEntity) -> InventoryGameEntitySlot:
	var slot : InventoryGameEntitySlot = InventoryGameEntitySlot.new()
	
	slot.game_entity = load(entity.scene_file_path)
	
	if entity is Module:
		if entity.module_resource is ComponentResource:
			var component_resource : ComponentResource = entity.module_resource
			
			slot.name = component_resource.manufacturer + " " + component_resource.model + " | Size " + component_resource.size
	elif entity is CargoContainer:
		slot.name = entity.contents
	elif entity is GameEntity:
		slot.name = entity.entity_name
	
	slot.value = entity.value
	
	return slot

func create_entity_from_inventory_slot_resource(slot : InventoryGameEntitySlot) -> GameEntity:
	var entity : GameEntity = slot.game_entity.instantiate()
	entity.value = slot.value
	
	return entity

func is_inventory_slot_occupied(slot : int) -> bool:
	match slot:
		1:
			if inventory.inventory_slot_1 == null:
				return false
			else:
				return true
		2:
			if inventory.inventory_slot_2 == null:
				return false
			else:
				return true
		3:
			if inventory.inventory_slot_3 == null:
				return false
			else:
				return true
		4:
			if inventory.inventory_slot_4 == null:
				return false
			else:
				return true
		5:
			if inventory.inventory_slot_5 == null:
				return false
			else:
				return true
	
	return true

func die() -> void:
	if has_died:
		return

	has_died = true
	
	var default_loadout : StarshipLoadout = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")

	ResourceSaver.save(default_loadout, Globals.PLAYER_SHIP_SAVE)
	
	current_controller.queue_free()

	respawn_hud.show()

	var low_pass_filter : AudioEffectLowPassFilter  = AudioEffectLowPassFilter.new()
	low_pass_filter.cutoff_hz = 500

	AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), low_pass_filter, 0)

	var tween : Tween = get_tree().create_tween()
	tween.tween_property(low_pass_filter, "cutoff_hz", 0, 14)
	tween.play()

	await get_tree().create_timer(15).timeout

	remove_credits(respawn_cost)

	respawn()

func respawn() -> void:
	var world : World = get_tree().get_first_node_in_group("World")

	world.respawn_player()
	respawn_hud.hide()
	AudioServer.remove_bus_effect(AudioServer.get_bus_index("Master"), 0)
	has_died = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (Input.is_action_just_released("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().get_first_node_in_group("World").exit_to_main_menu()

	if (Input.is_action_just_pressed("hide_ui")):
		if $HeadsUpDisplay.visible:
			$HeadsUpDisplay.hide()
		else:
			$HeadsUpDisplay.show()

	if (Input.is_action_just_released("player_force_respawn")):
		force_respawn_pressed_count += 1

		if force_respawn_timer.is_stopped():
			force_respawn_timer.start()

		if force_respawn_pressed_count >= 5:
			die()

	if control_entity == null:
		return


func on_posses(control_entity : ControlEntity) -> void:
	if control_entity is Starship:
		save_last_possessed_starship(control_entity)

func save_last_possessed_starship(starship : Starship) -> void:
	var save_data : Dictionary = {}
	save_data["scene_path"] = starship.scene_file_path  # Store scene path, or use a unique ID if preferred

	var save_file : FileAccess = FileAccess.open("user://last_possessed_starship.save", FileAccess.WRITE)

	if save_file:
		save_file.store_var(save_data)
		save_file.close()
