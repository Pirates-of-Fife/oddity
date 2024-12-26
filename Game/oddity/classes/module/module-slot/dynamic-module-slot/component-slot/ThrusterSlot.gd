extends DynamicModuleSlot

class_name ThrusterSlot

@export
var size : ModuleSize.ThrusterSize

@export
var type : ThrusterType

enum ThrusterType
{
	MAIN = 0,
	RCS,
	RETRO,
	VTOL
}

func _module_fits(module : Module) -> bool:
	if self.module != null:
		return false

	if module is Thruster:
		if module.size == size:
			if type == ThrusterType.MAIN:
				if module is MainThruster:
					return true
			if type == ThrusterType.RCS:
				if module is RcsThruster:
					return true
			if type == ThrusterType.RETRO:
				if module is RetroThruster:
					return true
			if type == ThrusterType.VTOL:
				if module is VtolThruster:
					return true
	return false

func _thruster_slot_ready() -> void:
	initialize_area_automatically = false
	_dynamic_module_slot_ready()
	add_to_group("ComponentSlot")

	var area : Area3D = $SlotArea

	area.collision_layer = 524288
	area.collision_mask = 524288


	if highlight_box == null:

		var mesh_instance : MeshInstance3D = MeshInstance3D.new()
		var box_mesh : BoxMesh = BoxMesh.new()
		box_mesh.size = area.get_child(0).shape.size
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


func _ready() -> void:
	_thruster_slot_ready()
