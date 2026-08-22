extends PlayerDetectionZone

class_name GameEntityZone

var game_entity_save : GameEntitySave

var spawned : bool = false

func _ready() -> void:
	activate_distance = 5000
	deactivate_distance = 6500
	update_time = 1
	one_shot = false

	add_to_group("GameEntity")

	activate.connect(on_activate)

	super._ready()
	
func on_activate(player : Player, control_entity : ControlEntity) -> void:
	if spawned:
		return

	var scene : PackedScene = load(game_entity_save.game_entity_scene)
	var game_entity : GameEntity = scene.instantiate()
	
	get_tree().get_first_node_in_group("StarSystem").add_child(game_entity)
	
	game_entity.value = game_entity_save.value
	game_entity.global_position = game_entity_save.position.toVector3()
	game_entity.global_rotation = game_entity_save.rotation.toVector3()
	
	spawned = true
	
	queue_free()