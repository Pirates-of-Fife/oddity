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
	if valid:
		$ValidDebugMesh.show()
	else:
		$ValidDebugMesh.hide()

	#if cargo_in_area == null:
		#if lower_cargo_area != null:
			#if lower_cargo_area.cargo_in_area != null:
				#valid = false

#	if cargo_in_area != null:


	#if cargo_in_area :
	#	highlight_off_cargo_areas(cargo_areas_for_container)

	#highlight_off()
#	$ActiveCargo.hide()

	if cargo_in_area != null:
		if cargo_in_area.is_being_held == false and cargo_in_area.nearest_cargo_area != null:
			if cargo_in_area.nearest_cargo_area == self and valid:
				cargo_in_area.snap_to_grid(cargo_areas_for_container)

	#highlight_off()

func highlight_cargo_areas(areas : Array) -> void:
	#print("bulk highlight")
	highlight_on()
	for c : CargoArea in areas:
		c.highlight_on()
		#print("highlight " + str(c.area_coordinate))

func highlight_off_cargo_areas(areas : Array) -> void:
	#print("bulk highlight")
	highlight_off()
	for c : CargoArea in areas:
		c.highlight_off()
		#print("highlight " + str(c.area_coordinate))

func find_cargo_areas_from_shape(shape: Vector3) -> Array:
	# Array to store the cargo areas that the container will snap to
	var cargo_areas: Array = []

	#var hx : int = int(floorf(shape.x / 2))
	#var hy : int = int(floorf(shape.y / 2))
	#var hz : int = int(floorf(shape.z / 2))
#
	#var x_min : int = area_coordinate.x - hx
	#var x_max : int = area_coordinate.x + hx + (int(shape.x) % 2)
#
	#var y_min : int = area_coordinate.y - hy
	#var y_max : int = area_coordinate.y + hy + (int(shape.y) % 2)
#
	#var z_min : int = area_coordinate.z - hz
	#var z_max : int = area_coordinate.z + hz + (int(shape.z) % 2)

	for x : int in range(area_coordinate.x, area_coordinate.x + shape.x):
		for y : int in range(area_coordinate.y, area_coordinate.y + shape.y):
			for z : int in range(area_coordinate.z, area_coordinate.z + shape.z):
				var cargo_area : CargoArea = cargo_grid.find_cargo_area(Vector3(x,y,z))

				if cargo_area != null:
					cargo_areas.append(cargo_area)
					
	#for x : int in range(x_min, x_max):
		#for y : int in range(y_min, y_max):
			#for z : int in range(z_min, z_max):
				#var cargo_area : CargoArea = cargo_grid.find_cargo_area(Vector3(x,y,z))
#
				#if cargo_area != null:
					#cargo_areas.append(cargo_area)

	return cargo_areas

func highlight_on() -> void:
	$MeshInstance3D.show()

func highlight_off() -> void:
	$MeshInstance3D.hide()

func highlight_cargo() -> void:
	if cargo_in_area.is_being_held and valid:
		if cargo_in_area.nearest_cargo_area == self:
			$ActiveCargo.show()
			if cargo_areas_for_container.size() == cargo_in_area.cargo_units:
				highlight_cargo_areas(cargo_areas_for_container)

func body_entered(body: Node3D) -> void:
	if body is CargoContainer:
		cargo_in_area = body
		cargo_in_area.in_cargo_areas.append(self)
		cargo_in_area.find_nearest_cargo_area()
		print("Cargo entered")
		search_cargo_areas_for_container()
		highlight_cargo()

		#print(cargo_areas_for_container)

func search_cargo_areas_for_container() -> void:
	cargo_areas_for_container = find_cargo_areas_from_shape(cargo_in_area.container_cu_shape)


func body_exited(body: Node3D) -> void:
	if body is CargoContainer:
		if cargo_in_area != null:
			if cargo_in_area.in_cargo_areas.has(self):
				cargo_in_area.in_cargo_areas.erase(self)
				cargo_in_area.find_nearest_cargo_area()
				cargo_in_area = null
				highlight_off_cargo_areas(cargo_areas_for_container)
		#$MeshInstance3D.hide()
