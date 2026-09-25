extends Openable

class_name ComponentHatch

@export_category("Components")

@export
var component_slots : Array[DynamicModuleSlot]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	openable_opening.connect(_on_open)
	openable_closing.connect(_on_close)

func _on_open() -> void:
	for c : DynamicModuleSlot in component_slots:
		c.usable = true
	
func _on_close() -> void:
	for c : DynamicModuleSlot in component_slots:
		c.usable = false