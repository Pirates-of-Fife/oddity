extends Area3D

class_name CargoArea

@export
var cargo_in_area : CargoContainer

var lower_cargo_area : CargoArea
var upper_cargo_area : CargoArea

@export
var cargo_grid : CargoGrid

@export
var area_coordinate : Vector3

@export
var snapped_cargo : CargoContainer

@export
var valid : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var error_enter : Error = self.connect("body_entered", body_entered)
	var error_exit : Error = self.connect("body_exited", body_exited)

	if (error_enter != OK):
		printerr(str(self) + " failed to connect to body_entered." + str(error_enter))

	if (error_exit != OK):
		printerr(str(self) + " failed to connect to body_exited.")

	if cargo_in_area != null:
		valid = false


func cargo_added() -> void:
	valid = false

	if upper_cargo_area != null:
		upper_cargo_area.valid = true

	if lower_cargo_area != null:
		lower_cargo_area.snapped_cargo.can_be_picked_up = false

func cargo_removed() -> void:
	valid = true

	if lower_cargo_area != null:
		lower_cargo_area.snapped_cargo.can_be_picked_up = true
	if upper_cargo_area != null:
		upper_cargo_area.valid = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cargo_in_area == null:
		return

	if cargo_in_area.is_being_held and cargo_in_area.nearest_cargo_area == self and valid:
		$MeshInstance3D.show()
	else:
		$MeshInstance3D.hide()

	if cargo_in_area.is_being_held == false and cargo_in_area.nearest_cargo_area == self and valid:
		cargo_in_area.snap_to_grid(self)



func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area = body
		cargo_in_area.in_cargo_areas.append(self)

func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		if cargo_in_area != null:
			if cargo_in_area.in_cargo_areas.has(self):
				cargo_in_area.in_cargo_areas.erase(self)

		cargo_in_area = null
		$MeshInstance3D.hide()
