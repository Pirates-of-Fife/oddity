extends Node

class_name Caretaker

@export_category("World")

@export
var world : World

@export_category("Setup")

@export_range(1, 60, 1, "suffix:Minutes")
var auto_save_time : float = 5

@onready
var auto_save_timer : Timer = Timer.new()

@export
var disable_auto_save : bool = false

func _ready() -> void:
	if !disable_auto_save:
		auto_save_timer.wait_time = auto_save_time * 60
		auto_save_timer.autostart = true
		auto_save_timer.timeout.connect(_auto_save_timeout)
		add_child(auto_save_timer)

func _auto_save_timeout() -> void:
	print_rich("[color=green]Autosave Initiated[/color]")
	save()
	auto_save_timer.start()

func save(used_bed : bool = false, bed_index : int = -1, ship_id : String = "") -> void:
	var entities_in_star_system : Array[Node] = get_tree().get_nodes_in_group("GameEntity")
	var starships_in_star_system : Array[Node] = get_tree().get_nodes_in_group("Starship")
		
	var save_file : SaveFile = get_save_file()
	
	save_file.player_position = save_player_position(used_bed, bed_index, ship_id)
	save_file.inventory = save_inventory()
	save_file.credits = world.player.credits
	save_file.active_ships = save_active_starships(save_file.active_ships, starships_in_star_system.duplicate())
	save_file.game_entities = save_game_entities(save_file.game_entities, entities_in_star_system.duplicate())
	
	save_save_file(save_file)

func save_inventory() -> PlayerInventoryResource:	
	return world.player.inventory 

func save_player_position(used_bed : bool = false, bed_index : int = -1, ship_id : String = "") -> PlayerPositionSave:
	var player_save : PlayerPositionSave = PlayerPositionSave.new()
	
	player_save.position = StringVector.create(world.player_control_entity.global_position)
	player_save.rotation = StringVector.create(world.player_control_entity.global_rotation) 
	player_save.star_system = world.get_current_star_sytem_resource()
	player_save.respawn_at_station = false
	player_save.used_a_bed = used_bed
	player_save.bed_index = bed_index
	player_save.starship_slept_with = ship_id
	
	return player_save

func save_active_starships(saved_ships : Array[StarshipSave], starships_in_star_system : Array[Node]) -> Array[StarshipSave]:
	var loadout_generator : LoadoutGenerator = LoadoutGenerator.new()

	var array_copy : Array[StarshipSave] = saved_ships.duplicate()

	for starship_save : StarshipSave in array_copy:
		if starship_save.star_system.name == world.get_current_star_sytem_resource().name:
			saved_ships.erase(starship_save)
	
	for entity : GameEntity in starships_in_star_system:
		if entity is Starship:
			if entity.is_player_ship:
				var new_save : StarshipSave = StarshipSave.new()
				new_save.star_system = world.get_current_star_sytem_resource()
				new_save.position = StringVector.create(entity.global_position)
				new_save.rotation = StringVector.create(entity.global_rotation)
				new_save.game_entity_scene = entity.scene_file_path
				new_save.value = entity.value
				new_save.loadout = loadout_generator.save_loadout(entity as Starship, true, true)
				
				saved_ships.append(new_save)
		
	return saved_ships

func save_game_entities(saved_entities : Array[GameEntitySave], entities_in_star_system : Array[Node]) -> Array[GameEntitySave]:	
	var system : String = world.get_current_star_sytem_resource().name

	var array_copy : Array[GameEntitySave] = saved_entities.duplicate()
	
	for game_entity_save : GameEntitySave in array_copy:
		if game_entity_save.star_system.name == system:
			saved_entities.erase(game_entity_save)	
	
	for entity : GameEntity in entities_in_star_system:
		if !entity.save:
			continue
			
		if entity is Starship:
			continue
			
		if entity is Module:
			if entity.module_slot != null:
				continue
	
		if entity is CargoContainer:
			if entity.snapped_to != null:
				if entity.snapped_to.cargo_grid.ship_grid:
					continue
					
		if entity.freeze:
			continue
		
		var new_save : GameEntitySave = GameEntitySave.new()
		new_save.star_system = world.get_current_star_sytem_resource()
		new_save.game_entity_scene = entity.scene_file_path
		new_save.position = StringVector.create(entity.global_position)
		new_save.rotation = StringVector.create(entity.global_rotation)
		new_save.value = entity.value
				
		saved_entities.append(new_save)
		
	return saved_entities

# Separate from save() because these get updated when the player uses the insurance terminal
func update_insured_ships(insured_ships : Array[StarshipLoadout]) -> void:
	var save_file : SaveFile = get_save_file()
	save_file.insured_ships = insured_ships
	save_save_file(save_file)

func update_stored_ships(stored_ships : Array[StarshipLoadout]) -> void:
	var save_file : SaveFile = get_save_file()
	save_file.stored_ships = stored_ships
	save_save_file(save_file)

func update_last_used_starship(loadout : StarshipLoadout) -> void:
	var save_file : SaveFile = get_save_file()
	save_file.last_used_ship = loadout
	save_save_file(save_file)

func get_save_file() -> SaveFile:
	var f : FileAccess = FileAccess.open(Globals.SAVE_FILE, FileAccess.READ)
	
	if f == null:
		return create_new_empty_save_file()
		
	return load(Globals.SAVE_FILE)
	
func create_new_empty_save_file() -> SaveFile:
	var new_save_file : SaveFile = SaveFile.new()
	
	new_save_file.player_position = PlayerPositionSave.new()
	new_save_file.player_position.respawn_at_station = true
	new_save_file.player_position.star_system = load("res://scenes/world/gateway/GatewayResource.tres")
	
	new_save_file.inventory = PlayerInventoryResource.new()
	new_save_file.credits = 10_000_000 # WARNING - reduce!
	
	new_save_file.active_ships = []
	new_save_file.insured_ships = []
	new_save_file.insured_ships.resize(10)
	new_save_file.insured_ships.fill(null)
	new_save_file.stored_ships = []
	new_save_file.stored_ships.resize(10)
	new_save_file.stored_ships.fill(null)
	new_save_file.game_entities = []
	
	return new_save_file
	
func save_save_file(save_file : SaveFile) -> void:
	var result : Error = ResourceSaver.save(save_file, Globals.SAVE_FILE)
	
	if result != Error.OK:
		push_error("Something went wrong while trying to save!")
