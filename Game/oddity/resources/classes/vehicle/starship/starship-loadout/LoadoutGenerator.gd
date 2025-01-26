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
			
		
func save_loadout(starship : Starship) -> void:
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

	var err : Error = ResourceSaver.save(loadout, "user://saved_loadout.tres")
	if err == OK:
		print("Loadout saved successfully")
	else:
		print("Failed to save loadout")

func load_loadout(starship : Starship, loadout : StarshipLoadout) -> void:
	clear_modules(starship)
	
	var children : Array = starship.find_children("*", "", true, false)
		
	for node : Node in children:
		if node is DynamicModuleSlot:
			var module_scene : PackedScene = loadout.get_module_by_id(node.id)
			
			if module_scene != null:
				var module : Module = module_scene.instantiate()
				starship.add_child(module)
				module.insert(node)
			

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
	
func generate_thruster_slot_entry(slot : ThrusterSlot, save_module : bool = true) -> ThrusterSlotLoadoutResource:
	var slot_entry : ThrusterSlotLoadoutResource = ThrusterSlotLoadoutResource.new()
	
	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
		
	return slot_entry
	
func generate_radiator_slot_entry(slot : RadiatorSlot, save_module : bool = true) -> RadiatorSlotLoadoutResource:
	var slot_entry : RadiatorSlotLoadoutResource = RadiatorSlotLoadoutResource.new()
	
	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
		
	return slot_entry

func generate_component_slot_entry(slot : ComponentSlot, save_module : bool = true) -> ComponentSlotLoadoutResource:
	var slot_entry : ComponentSlotLoadoutResource = ComponentSlotLoadoutResource.new()
	
	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
	
	return slot_entry
	
func generate_hardpoint_slot_entry(slot : Hardpoint, save_module : bool = true) -> HardpointLoadoutResource:
	var slot_entry : HardpointLoadoutResource = HardpointLoadoutResource.new()
	
	slot_entry.size = slot.size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
	
	
	return slot_entry
	
func generate_alcubierre_slot_entry(slot : AlcubierreDriveSlot, save_module : bool = true) -> AlcubierreDriveSlotLoadoutResource:
	var slot_entry : AlcubierreDriveSlotLoadoutResource = AlcubierreDriveSlotLoadoutResource.new()
	
	slot_entry.size = slot.alcubierre_drive_size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
	
	return slot_entry
	
func generate_abyss_slot_entry(slot : AbyssalJumpDriveSlot, save_module : bool = true) -> AbyssalJumpDriveSlotLoadoutResource:
	var slot_entry : AbyssalJumpDriveSlotLoadoutResource = AbyssalJumpDriveSlotLoadoutResource.new()
	
	slot_entry.size = slot.abyssal_jump_drive_size
	slot_entry.id = slot.id
	slot_entry.name = slot.name
	
	if save_module:
		if slot.module != null:
			slot_entry.module = load(slot.module.scene_file_path)
	
	return slot_entry
