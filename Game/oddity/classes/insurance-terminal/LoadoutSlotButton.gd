extends UiButton

class_name LoadoutSlotButton

@export
var id : int = 0

@export_category("Loadout")

@export
var loadout : StarshipLoadout :
	set(value):
		loadout = value
		
		if value == null:
			button_text = "EMPTY"
		else:
			button_text = loadout.ship_name
	get:
		return loadout

signal loadoutSelected(loadout : Starship, button_id : int)

func _ready() -> void:
	super._ready()
	
	interacted.connect(_on_interacted)
	
	button_text = "EMPTY"

func _on_interacted(player : Player, control_entity: ControlEntity) -> void:
	loadoutSelected.emit(loadout, id)
