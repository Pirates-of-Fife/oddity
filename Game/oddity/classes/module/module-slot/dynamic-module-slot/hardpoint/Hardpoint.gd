@tool
extends DynamicModuleSlot

class_name Hardpoint

@export
var size : ModuleSize.HardpointSize

@export
var assignment : HardpointAssignment 

enum HardpointAssignment
{
	PRIMARY,
	SECONDARY,
	TERTIARY
}

func _module_fits(module : Module) -> bool:
	if self.module != null:
		return false

	if module is Weapon:
		if module.size == size:
			return true
	return false

func _ready() -> void:
	_hardpoint_ready()

func _hardpoint_ready() -> void:
	_dynamic_module_slot_ready()
	add_to_group("Hardpoint")
	

func _initialize_area() -> void:
	if area_root == null:
		area_root = Node3D.new()
		add_child(area_root)
		area_root.owner = get_tree().edited_scene_root
	else:
		for c : Node3D in area_root.get_children():
			c.queue_free()

	var area : Area3D = Area3D.new()

	area.collision_layer = 524288
	area.collision_mask = 524288

	area.monitoring = true

	var box_shape : BoxShape3D = BoxShape3D.new()

	var module_size : ModuleSize = ModuleSize.new()

	box_shape.size = module_size.get_hardpoint_size(size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	area_root.add_child(area)
	area.add_child(collision_shape)
	area.owner = get_tree().edited_scene_root
	collision_shape.owner = get_tree().edited_scene_root

	var mesh_instance : MeshInstance3D = MeshInstance3D.new()
	var box_mesh : BoxMesh = BoxMesh.new()
	box_mesh.size = box_shape.size
	mesh_instance.mesh = box_mesh

	# Assign the highlight material
	var highlight_material : Material = preload("res://classes/cargo/CargoHighlightMaterial.tres")
	mesh_instance.material_override = highlight_material
	mesh_instance.visible = false  # Hide by default

	# Add MeshInstance3D as a child of the Area3D
	area.add_child(mesh_instance)
	mesh_instance.owner = get_tree().edited_scene_root

	highlight_box = mesh_instance

	var error_enter : Error = area.body_entered.connect(_on_area_3d_body_entered)
	var error_exit : Error = area.body_exited.connect(_on_area_3d_body_exited)

	if (error_enter != OK):
		printerr("Component Slot area enter failed to connect.")
	if (error_exit != OK):
		printerr("Component Slot area exit failed to connect.")
