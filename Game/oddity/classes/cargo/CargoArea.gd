extends Area3D

class_name CargoArea

@export
var cargo_in_area : CargoContainer

@export
var lower_cargo_area : CargoArea

var cargo_grid : CargoGrid

var area_coordinate : Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var error_enter : Error = self.connect("body_entered", body_entered)
	var error_exit : Error = self.connect("body_exited", body_exited)

	if (error_enter != OK):
		printerr(str(self) + " failed to connect to body_entered." + str(error_enter))

	if (error_exit != OK):
		printerr(str(self) + " failed to connect to body_exited.")

func snap_cargo_to_grid() -> void:
	cargo_in_area.reparent.call_deferred(self)
	cargo_in_area.freeze_static()
	cargo_in_area.global_position = self.global_position
	cargo_in_area.global_rotation = self.global_rotation



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cargo_in_area == null:
		return

	if cargo_in_area.is_being_held and cargo_in_area.nearest_cargo_area == self:
		$MeshInstance3D.show()
	else:
		$MeshInstance3D.hide()

	if cargo_in_area.is_being_held == false and cargo_in_area.nearest_cargo_area == self:
		snap_cargo_to_grid()


func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area = body
		cargo_in_area.in_cargo_areas.append(self)

func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area.in_cargo_areas.erase(self)
		cargo_in_area = null
		$MeshInstance3D.hide()
