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

var cargo_areas_for_container : Array

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
		if lower_cargo_area.snapped_cargo != null:
			lower_cargo_area.snapped_cargo.can_be_picked_up = false

func cargo_removed() -> void:
	valid = true

	if lower_cargo_area != null:
		if lower_cargo_area.snapped_cargo != null:
			lower_cargo_area.snapped_cargo.can_be_picked_up = true
	if upper_cargo_area != null:
		upper_cargo_area.valid = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if valid:
		$ValidDebugMesh.show()
	else:
		$ValidDebugMesh.hide()

	if cargo_in_area == null:
		return

	if cargo_in_area.is_being_held and cargo_in_area.nearest_cargo_area == self and valid:
		highlight_cargo_areas(cargo_areas_for_container)
		#highlight_on()
	else:
		highlight_off_cargo_areas(cargo_areas_for_container)

	if cargo_in_area.is_being_held == false and cargo_in_area.nearest_cargo_area == self and valid:
		cargo_in_area.snap_to_grid(cargo_areas_for_container)

	#highlight_off()

func highlight_cargo_areas(areas : Array) -> void:
	#print("bulk highlight")
	for c : CargoArea in areas:
		c.highlight_on()
		#print("highlight " + str(c.area_coordinate))

func highlight_off_cargo_areas(areas : Array) -> void:
	#print("bulk highlight")
	for c : CargoArea in areas:
		c.highlight_off()
		#print("highlight " + str(c.area_coordinate))



func find_cargo_areas_from_shape(shape: Vector3) -> Array:
	# Array to store the cargo areas that the container will snap to
	var cargo_areas: Array = []

	# Calculate offsets for each dimension (half of the shape)
	var x_offset: int = int(floor(shape.x / 2.0))
	var y_offset: int = int(floor(shape.y / 2.0))
	var z_offset: int = int(floor(shape.z / 2.0))

	# Calculate the range for each dimension, ensuring it covers all positions the container occupies.
	var x_min: int = area_coordinate.x - x_offset
	var x_max: int = area_coordinate.x + x_offset + (1 if int(shape.x) % 2 != 0 else 0)  # Ensure coverage for odd shapes

	var y_min: int = area_coordinate.y - y_offset
	var y_max: int = area_coordinate.y + y_offset + (1 if int(shape.y) % 2 != 0 else 0)  # Ensure coverage for odd shapes

	var z_min: int = area_coordinate.z - z_offset
	var z_max: int = area_coordinate.z + z_offset + (1 if int(shape.z) % 2 != 0 else 0)  # Ensure coverage for odd shapes

	# Debug prints to understand range calculations
	#print("Cargo: ", area_coordinate)
	#print("Shape: ", shape)
	#print("Offsets: ", Vector3(x_offset, y_offset, z_offset))
	#print("Ranges x: ", x_min, " to ", x_max)
	#print("Ranges y: ", y_min, " to ", y_max)
	#print("Ranges z: ", z_min, " to ", z_max)

	# Loop through the ranges and check each coordinate
	for x : int in range(x_min, x_max):
		for y : int in range(y_min, y_max):
			for z : int in range(z_min, z_max):
				var coordinate: Vector3 = Vector3(x, y, z)
				print("Checking coordinate: ", coordinate)

				# Find and append cargo area if it exists at this coordinate
				var cargo_area: CargoArea = cargo_grid.find_cargo_area(coordinate)
				if cargo_area != null:
					cargo_areas.append(cargo_area)

	return cargo_areas






func highlight_on() -> void:
	$MeshInstance3D.show()

func highlight_off() -> void:
	$MeshInstance3D.hide()


func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area = body
		cargo_in_area.in_cargo_areas.append(self)

		cargo_areas_for_container = find_cargo_areas_from_shape(cargo_in_area.container_cu_shape)

func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		if cargo_in_area != null:
			if cargo_in_area.in_cargo_areas.has(self):
				cargo_in_area.in_cargo_areas.erase(self)

		highlight_off_cargo_areas(cargo_areas_for_container)
		cargo_in_area = null
		#$MeshInstance3D.hide()
