extends Node3D

class_name ModuleSlot

var module_in_area : Module

@export
var module : Module

func _ready() -> void:
	create_area()
	
func _process(delta: float) -> void:
	print(module_in_area)
	
	if module != null:
		return
	if module_in_area != null:
		if !module_in_area.is_being_held:
			module_in_area.insert(self)

func _on_body_entered(body : Node3D) -> void:
	print(body)
	if module != null:
		if body is Module:
			module_in_area = body
			print(module_in_area)

func _on_body_exited(body : Node3D) -> void:
	if body is Module:
		module_in_area = null

func create_area() -> void:
	var area : Area3D = Area3D.new()
	
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	var collider : CollisionShape3D = CollisionShape3D.new()
	collider.shape = BoxShape3D.new()
	
	add_child(area)
	
	area.add_child(collider)
