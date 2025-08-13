extends Resource

class_name MineableResource

@export
var mineable_name : StringName

@export_range(100, 300000, 10)
var min_resource_health : float

@export_range(100, 300000, 10)
var max_resource_health : float

@export_range(1, 20, 1)
var min_resource_count : int

@export_range(1, 36, 1)
var max_resource_count : int

@export
var extractable_resources : Array[PackedScene]

@export_range(0, 10000, 10)
var extraction_force : float

@export_range(1, 20, 0.5)
var min_rarity : float

@export_range(1, 20, 0.5)
var max_rarity : float

@export
var variants : Array[PackedScene]

@export
var low_detail_mesh : ArrayMesh

@export_range(0, 1000000, 100)
var base_value : int

@export_range(0, 1, 0.05)
var value_variance : float

@export
var extraction_sound : PackedScene
