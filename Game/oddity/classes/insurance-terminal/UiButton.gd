extends InteractionButton

class_name UiButton

@export_category("Label")

@export
var button_text_label : Label3D

@export
var button_text : String :
	set(value):
		button_text_label.text = value
	get:
		return button_text_label.text

@export_category("Material")

@export
var toggleable : bool = false

@export
var button_mesh : MeshInstance3D

@export
var start_material : StandardMaterial3D

@export
var selected_material : StandardMaterial3D

func _ready() -> void:
	if button_mesh == null:
		button_mesh = find_child("MeshInstance3D")
	if button_text_label == null:
		button_text_label = find_child("Label3D")

	if start_material != null:
		button_mesh.set_surface_override_material(0, start_material)

func select() -> void:
	if toggleable:
		button_mesh.set_surface_override_material(0, selected_material)
	
func deselect() -> void:
	button_mesh.set_surface_override_material(0, start_material)
