extends Area3D

class_name CargoArea

# Bodies in the Area
@export
var cargo_in_area : CargoContainer

var other_bodies_in_area : Array

# Related Cargo Areas
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

var placement_valid : bool = false

var cargo_areas_for_container : Array

signal cargo_entered(container : CargoContainer)
signal cargo_exited(container : CargoContainer)

## Cargo container enters area
## calculate placement areas
## check if valid
## if valid --> highlight areas
## if rotated do steps 2,3,4 again
## if not being held and area is highlighted --> snap

func cargo_entered_area(container : CargoContainer) -> void:
	cargo_grid.highlight_off.emit()
	cargo_in_area = container
	cargo_in_area.calculate_valid_placement_positions()

#	cargo_in_area.container_snapping_rotated.connect(update_highlight)
	cargo_in_area.in_cargo_areas.append(self)

#	update_highlight(cargo_in_area)

	#cargo_in_area.find_nearest_cargo_area()

func update_highlight(container : CargoContainer) -> void:
	if cargo_in_area != null:
		if cargo_in_area.nearest_cargo_area != self:
			return

	cargo_areas_for_container = find_cargo_areas_from_shape(container.container_cu_shape)
	placement_valid = is_placement_valid(cargo_areas_for_container)

func find_cargo_areas_from_shape(shape: Vector3) -> Array:
	var cargo_areas: Array = []

	for x : int in range(area_coordinate.x, area_coordinate.x + shape.x):
		for y : int in range(area_coordinate.y, area_coordinate.y + shape.y):
			for z : int in range(area_coordinate.z, area_coordinate.z + shape.z):
				var cargo_area : CargoArea = cargo_grid.find_cargo_area(Vector3(x,y,z))

				if cargo_area != null:
					cargo_areas.append(cargo_area)

	return cargo_areas

func is_placement_valid(areas : Array) -> bool:

	print("Placement: " + str(areas))

	if areas.size() < cargo_in_area.cargo_units:
		print("size too small: " + str(areas.size()) + " vs " + str(cargo_in_area.cargo_units))
		return false

	for c : CargoArea in areas:
		if c.snapped_cargo != null:
			print("area full")
			return false

		if c.other_bodies_in_area.size() != 0:
			print("area occupied")
			return false

	print("VALID")
	return true

func highlight_areas() -> void:
	if cargo_in_area.is_being_held and valid:
		if cargo_in_area.nearest_cargo_area == self:
			cargo_grid.highlight_cargo_areas(cargo_areas_for_container)

func snap() -> void:
	if cargo_in_area != null:
		if cargo_in_area.is_being_held == false and cargo_in_area.nearest_cargo_area != null:
			if cargo_in_area.nearest_cargo_area == self and valid and placement_valid:
				cargo_in_area.snap_to_grid(cargo_areas_for_container)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var error_enter : Error = self.connect("body_entered", body_entered)
	var error_exit : Error = self.connect("body_exited", body_exited)

	if (error_enter != OK):
		printerr(str(self) + " failed to connect to body_entered." + str(error_enter))

	if (error_exit != OK):
		printerr(str(self) + " failed to connect to body_exited.")

	cargo_entered.connect(cargo_entered_area)
	cargo_exited.connect(cargo_exited_area)

	if cargo_in_area != null:
		valid = false

func cargo_added() -> void:
	valid = false

	if upper_cargo_area != null:
		upper_cargo_area.valid = true

	if lower_cargo_area != null:
		if lower_cargo_area.snapped_cargo != null:
			if lower_cargo_area.snapped_cargo != snapped_cargo:
				lower_cargo_area.snapped_cargo.can_be_picked_up = false

func cargo_removed() -> void:
	if lower_cargo_area != null:
		if lower_cargo_area.snapped_cargo != null:
			valid = true

	if lower_cargo_area == null:
		valid = true

	if lower_cargo_area != null:
		if lower_cargo_area.snapped_cargo != null:
			lower_cargo_area.snapped_cargo.can_be_picked_up = true
	if upper_cargo_area != null:
		upper_cargo_area.valid = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_area()

	#if cargo_in_area != null:
	#	cargo_in_area.find_nearest_cargo_area()
	#	print("nearest: " + str(cargo_in_area.nearest_cargo_area))

	#if placement_valid:
	#	highlight_areas()
	#	print("highlighting")

#	snap()


#	if cargo_in_area != null:


	#if cargo_in_area :
	#	highlight_off_cargo_areas(cargo_areas_for_container)


	#highlight_off()
#	$ActiveCargo.hide()
	#if cargo_in_area != null:
		##cargo_in_area.find_nearest_cargo_area()
		#cargo_areas_for_container = find_cargo_areas_from_shape(cargo_in_area.container_cu_shape)
		#placement_valid = is_placement_valid(cargo_areas_for_container)
##
		#if placement_valid:
			#highlight_areas()




	#highlight_off()





func highlight_on() -> void:
	$MeshInstance3D.show()

func highlight_off() -> void:
	$MeshInstance3D.hide()

func update_area() -> void:
	if valid:
		$ValidDebugMesh.show()
		monitoring = true
	else:
		$ValidDebugMesh.hide()
		monitoring = false

	if cargo_in_area == null:
		if lower_cargo_area != null:
			if lower_cargo_area.cargo_in_area != null:
				valid = false

func search_cargo_areas_for_container() -> void:
	cargo_areas_for_container = find_cargo_areas_from_shape(cargo_in_area.container_cu_shape)


func cargo_exited_area(container : CargoContainer) -> void:
	if cargo_in_area != null:
		if cargo_in_area.in_cargo_areas.has(self):
			#cargo_in_area.container_snapping_rotated.disconnect(update_highlight)
			cargo_in_area.in_cargo_areas.erase(self)
			cargo_in_area = null
			placement_valid = false

func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_entered.emit(body)
		return

	other_bodies_in_area.append(body)

		#print(cargo_areas_for_container)


func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_exited.emit(body)
		return

	other_bodies_in_area.erase(body)
