extends Area3D

class_name ModuleSellingArea

signal modules_updated

var modules : Array = Array()

func _ready() -> void:
	body_entered.connect(_on_module_added)
	body_exited.connect(_on_module_removed)
	

func _on_module_added(body : Node3D) -> void:
	print(body)
	if body is Module:
		if body is Thruster:
			return
		modules.append(body)
		modules_updated.emit()

func _on_module_removed(body : Node3D) -> void:
	if body is Module:
		if body is Thruster:
			return
		modules.erase(body)
		modules_updated.emit()

func sell_modules() -> void:
	var total : int = 0
	var player : Player = get_tree().get_first_node_in_group("Player")

	for module : Module in modules:
		total += module.value
		module.queue_free()
	
	player.add_credits(total)
