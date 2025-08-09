extends Resource

class_name FoliageResource

@export_category("Foliage")

@export
var foliage_mesh : ArrayMesh

@export
var scale_multiplier : float = 1

@export_range(0, 1, 0.01)
var scale_variance : float = 0
