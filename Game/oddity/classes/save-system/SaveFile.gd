extends Resource

class_name SaveFile

@export_category("Position")

@export
var player_position : PlayerPositionSave

@export_category("Inventory and Money")

@export
var inventory : PlayerInventoryResource

@export
var credits : int 

@export_category("Active Ships")

@export
var last_used_ship : StarshipLoadout 

@export
var active_ships : Array[StarshipSave]

@export_category("Insured Ships")

@export
var insured_ships : Array[StarshipLoadout]

@export_category("Stored Ships")

@export
var stored_ships : Array[StarshipLoadout]

@export_category("Game Entities")

@export
var game_entities : Array[GameEntitySave]
