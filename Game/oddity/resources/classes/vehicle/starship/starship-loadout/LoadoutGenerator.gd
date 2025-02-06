@tool
extends Node

class_name LoadoutGenerator

@export
var starship : Starship

@export
var generate_empty_load_out : bool :
	set(value):
		generate_empty_loadout_resource()

@export
var save_load_out : bool :
	set(value):
		editor_save_current_load_out()

@export
var editor_load_loadout : bool :
	set(value):
		editor__load_loadout()

@export
var clear_load_out : bool :
	set(value):
		clear_modules(starship)

@export
var load_loadout_editor : StarshipLoadout

@export
var output : StarshipLoadout


func editor__load_loadout() -> void:
	clear_modules(starship)

	load_loadout(starship, load_loadout_editor)

func clear_modules(starship : Starship) -> void:
	var children : Array = starship.find_children("*", "", true, false)

	for node : Node in children:
		if node is DynamicModuleSlot:
			if node.module != null:
				var module : Module = node.module

				module.uninsert()
				module.queue_free()


func save_loadout(starship : Starship, save_cargo : bool = false, save_entities : bool = false, save_as_player_ship_save : bool = false) -> void:
	var loadout : StarshipLoadout = StarshipLoadout.new()

	var children : Array = starship.find_children("*", "", true, false)

	for node : Node in children:
		if node is ThrusterSlot:
			loadout.module_slots.append(generate_thruster_slot_entry(node))
		if node is ComponentSlot:
			loadout.module_slots.append(generate_component_slot_entry(node))
		if node is Hardpoint:
			loadout.module_slots.append(generate_hardpoint_slot_entry(node))
		if node is AlcubierreDriveSlot:
			loadout.module_slots.append(generate_alcubierre_slot_entry(node))
		if node is AbyssalJumpDriveSlot:
			loadout.module_slots.append(generate_abyss_slot_entry(node))
		if node is RadiatorSlot:
			loadout.module_slots.append(generate_radiator_slot_entry(node))

	if save_cargo:
		for cargo_grid : CargoGrid in starship.cargo_grids:
			for cargo : CargoContainer in cargo_grid.current_cargo_in_grid:
				loadout.cargo.append(generate_cargo_container_entry(cargo))

	if save_entities:
		var frame_of_references : Array = starship.find_children("*", "FrameOfReference", true, false)

		for frame_of_reference : FrameOfReference in frame_of_references:
			for child : Node in frame_of_reference.get_children():
				if child is GameEntity:
					loadout.entities.append(generate_game_entity_entry(child, starship))

	loadout.value = 0
	loadout.current_health = starship.current_hull_health

	for i : ModuleSlotLoadoutResource in loadout.module_slots:
		loadout.value += i.value
	for i : CargoContainerLoadoutResource in loadout.cargo:
		loadout.value += i.value
	for i : GameEntityLoadoutResource in loadout.entities:
		loadout.value += i.value

	loadout.ship_name = starship.ship_name
	

	if save_as_player_ship_save:
		loadout.apply_health = true
		var err : Error = ResourceSaver.save(loadout, Globals.PLAYER_SHIP_SAVE)
		if err == OK:
			print("Loadout saved successfully")
		else:
			print("Failed to save loadout")
	else:
		var err : Error = ResourceSaver.save(loadout, Globals.STARSHIP_SAVED_LOADOUT)
		if err == OK:
			print("Loadout saved successfully")
		else:
			print("Failed to save loadout")

func load_loadout(starship : Starship, loadout : StarshipLoadout, apply_health : bool = false) -> void:
	clear_modules(starship)

	var children : Array = starship.find_children("*", "", true, false)

	starship.ship_name = loadout.ship_name

	for node : Node in children:
		if node is DynamicModuleSlot:
			var module_scene : PackedScene = loadout.get_module_by_id(node.id)

			if module_scene != null:
				var module : Module = module_scene.instantiate()
				starship.add_child(module)
				module.insert(node)

	for cargo_resource : CargoContainerLoadoutResource in loadout.cargo:
		var cargo_grid : CargoGrid = null

		for grid : CargoGrid in starship.cargo_grids:
			if grid.id == cargo_resource.cargo_grid_id:
				cargo_grid = grid

		if cargo_grid != null:
			var cargo : CargoContainer = cargo_resource.cargo_container.instantiate()
			starship.add_child(cargo)
			cargo_grid.add_cargo_container(cargo)

	for entity : GameEntityLoadoutResource in loadout.entities:
		var game_entity : GameEntity = entity.game_entity.instantiate()
		starship.add_child(game_entity)
		game_entity.position = entity.position
		game_entity.rotation = entity.rotation
	
	if apply_health:
		starship.current_hull_health = loadout.current_health
		


func editor_save_current_load_out() -> void:
	if starship == null:
		return

	var loadout : StarshipLoadout = StarshipLoadout.new()

	var children : Array = starship.find_children("*", "", true, false)

	for node : Node in children:
		if node is ThrusterSlot:
			loadout.module_slots.append(generate_thruster_slot_entry(node))
		if node is ComponentSlot:
			loadout.module_slots.append(generate_component_slot_entry(node))
		if node is Hardpoint:
			loadout.module_slots.append(generate_hardpoint_slot_entry(node))
		if node is AlcubierreDriveSlot:
			loadout.module_slots.append(generate_alcubierre_slot_entry(node))
		if node is AbyssalJumpDriveSlot:
			loadout.module_slots.append(generate_abyss_slot_entry(node))
		if node is RadiatorSlot:
			loadout.module_slots.append(generate_radiator_slot_entry(node))

	output = loadout

func generate_empty_loadout_resource() -> void:
	if starship == null:
		return

	var loadout : StarshipLoadout = StarshipLoadout.new()

	var children : Array = starship.find_children("*", "", true, false)

	for node : Node in children:
		if node is ThrusterSlot:
			loadout.module_slots.append(generate_thruster_slot_entry(node, false))
		if node is ComponentSlot:
			loadout.module_slots.append(generate_component_slot_entry(node, false))
		if node is Hardpoint:
			loadout.module_slots.append(generate_hardpoint_slot_entry(node, false))
		if node is AlcubierreDriveSlot:
			loadout.module_slots.append(generate_alcubierre_slot_entry(node, false))
		if node is AbyssalJumpDriveSlot:
			loadout.module_slots.append(generate_abyss_slot_entry(node, false))
		if node is RadiatorSlot:
			loadout.module_slots.append(generate_radiator_slot_entry(node, false))

	output = loadout

func generate_cargo_container_entry(cargo : CargoContainer) -> CargoContainerLoadoutResource:
	var container_entry : CargoContainerLoadoutResource = CargoContainerLoadoutResource.new()

	container_entry.cargo_container = load(cargo.scene_file_path)
	container_entry.cargo_grid_id = cargo.snapped_to.cargo_grid.id
	container_entry.value = cargo.value

	return container_entry

func generate_game_entity_entry(entity : GameEntity, starship : Starship) -> GameEntityLoadoutResource:
	var game_entity_entry : GameEntityLoadoutResource = GameEntityLoadoutResource.new()

	game_entity_entry.game_entity = load(entity.scene_file_path)
	game_entity_entry.position = starship.to_local(entity.global_position)
	game_entity_entry.rotation = entity.rotation
	game_entity_entry.value = entity.value

	return game_entity_entry

func generate_thruster_slot_entry(slot : ThrusterSlot, save_module : bool = true) -> ThrusterSlotLoadoutResource:
	var slot_entry : ThrusterSlotLoadoutResource = ThrusterSlotLoadoutResource.new()

	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name

	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value

	return slot_entry

func generate_radiator_slot_entry(slot : RadiatorSlot, save_module : bool = true) -> RadiatorSlotLoadoutResource:
	var slot_entry : RadiatorSlotLoadoutResource = RadiatorSlotLoadoutResource.new()

	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name

	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value

	return slot_entry

func generate_component_slot_entry(slot : ComponentSlot, save_module : bool = true) -> ComponentSlotLoadoutResource:
	var slot_entry : ComponentSlotLoadoutResource = ComponentSlotLoadoutResource.new()

	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name


	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value

	return slot_entry

func generate_hardpoint_slot_entry(slot : Hardpoint, save_module : bool = true) -> HardpointLoadoutResource:
	var slot_entry : HardpointLoadoutResource = HardpointLoadoutResource.new()

	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name


	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value


	return slot_entry

func generate_alcubierre_slot_entry(slot : AlcubierreDriveSlot, save_module : bool = true) -> AlcubierreDriveSlotLoadoutResource:
	var slot_entry : AlcubierreDriveSlotLoadoutResource = AlcubierreDriveSlotLoadoutResource.new()

	slot_entry.size = slot.alcubierre_drive_size
	slot_entry.id = slot.id
	slot_entry.name = slot.name

	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value


	return slot_entry

func generate_abyss_slot_entry(slot : AbyssalJumpDriveSlot, save_module : bool = true) -> AbyssalJumpDriveSlotLoadoutResource:
	var slot_entry : AbyssalJumpDriveSlotLoadoutResource = AbyssalJumpDriveSlotLoadoutResource.new()

	slot_entry.size = slot.abyssal_jump_drive_size
	slot_entry.id = slot.id
	slot_entry.name = slot.name

	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
			slot_entry.value = slot.module.value

	return slot_entry
