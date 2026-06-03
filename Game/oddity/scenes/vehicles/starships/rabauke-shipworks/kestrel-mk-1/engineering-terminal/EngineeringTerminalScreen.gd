extends Node2D

class_name EngineeringTerminalScreen

@export
var engineering_terminal : EngineeringTerminal

var starship : Starship

func type(key : String) -> void:
	$RichTextLabel.add_text(key)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if engineering_terminal == null:
		printerr("No engineering terminal assigned")
		return
	
	if engineering_terminal.starship == null:
		printerr("No starship assigned at engineering terminal")
		return
	
	starship = engineering_terminal.starship

func connect_component_slots() -> void:
	var children : Array = starship.find_children("*", "", true, false)
	
	for node : Node in children:
		if node is DynamicModuleSlot:
			node.module_inserted.connect(_on_module_inserted)
			node.module_removed.connect(_on_module_removed)
		

func focus() -> void:
	var textedit : TextEdit = $TextEdit
	
	#textedit.focus_mode = Control.FOCUS_ALL
	textedit.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_module_inserted(module : Module, slot_id : int) -> void:
	pass

func _on_module_removed(module : Module, slot_id : int) -> void:
	pass
