extends Resource

class_name PlayerPositionSave

@export
var respawn_at_station : bool = true

@export
var position : StringVector

@export
var rotation : StringVector

@export
var star_system : StarSystemResource

@export
var used_a_bed : bool = false

@export
var bed_index : int = -1

@export
var starship_slept_with : String