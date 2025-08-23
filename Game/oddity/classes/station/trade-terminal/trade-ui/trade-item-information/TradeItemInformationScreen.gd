extends Node3D

class_name TradeItemInformationScreen

# this should be loaded only when the terminal turns on

@export
var current_trade_item : TradeResource

@export
var preview : Node3D

@export_flags_3d_render
var visibility_layers : int

@export
var currently_spawned_trade_item : GameEntity

@export
var rotation_speed : float = 4

@export
var camera : Camera3D

@export
var lights : Node3D

@export
var title : Label3D

@export
var credits : TradeCreditLabel

@export
var description : Label3D

func _process(delta: float) -> void:
	if currently_spawned_trade_item != null:
		currently_spawned_trade_item.rotate_y(rotation_speed * delta)

func display_trade_item(trade_item : TradeResource) -> void:
	if currently_spawned_trade_item != null:
		currently_spawned_trade_item.queue_free()
	
	current_trade_item = trade_item
	spawn_trade_item()
	
	title.text = current_trade_item.name
	description.text = current_trade_item.description
	credits.credits = current_trade_item.value

func spawn_trade_item() -> void:
	var trade_item : GameEntity = current_trade_item.scene.instantiate()
	
	preview.add_child(trade_item)
	
	trade_item.owner = get_tree().edited_scene_root
	
	camera.position.z = current_trade_item.preview_distance
	
	lights.scale = Vector3((current_trade_item.preview_distance / 5), (current_trade_item.preview_distance / 5), (current_trade_item.preview_distance / 5))
	
	currently_spawned_trade_item = trade_item
	
