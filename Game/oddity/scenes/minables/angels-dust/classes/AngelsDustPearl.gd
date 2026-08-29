extends CargoContainer

class_name AngelsDustPearl

@export
var normal_container : Node3D

@export
var new_collider : Node3D

@export
var old_collider : Node3D

@export
var cardboard_box : Node3D

var placed : bool = false

func _ready() -> void:
	_angels_dust_pearl_ready()

	
func _angels_dust_pearl_ready() -> void:
	_cargo_container_ready()
	snapped_to_grid.connect(_on_container_placed_in_grid)
	
func _on_container_placed_in_grid(cargo_area : CargoArea, cargo_grid : CargoGrid) -> void:
	if placed:
		return
		
	placed = true
	
	print("AWOOGA")
	
	var random_number : int = randi_range(1, 100000)
	
	if random_number % 16 == 0:
		cardboard_box.show()
		gravity_scale = 0.2
	else:
		normal_container.show()
		gravity_scale = 0.8
	
	
