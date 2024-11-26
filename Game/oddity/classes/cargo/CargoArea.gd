extends Area3D

class_name CargoArea

@export
var cargo_in_area : CargoContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var error_enter : Error = self.connect("body_entered", body_entered)
	var error_exit : Error = self.connect("body_exited", body_exited)

	if (error_enter != OK):
		printerr(str(self) + " failed to connect to body_entered." + str(error_enter))

	if (error_exit != OK):
		printerr(str(self) + " failed to connect to body_exited.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cargo_in_area == null:
		return

	if cargo_in_area.is_being_held and cargo_in_area.nearest_cargo_area == self:
		$MeshInstance3D.show()
	else:
		$MeshInstance3D.hide()


func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area = body
		cargo_in_area.in_cargo_areas.append(self)

func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area.in_cargo_areas.erase(self)
		cargo_in_area = null
		$MeshInstance3D.hide()
