extends RigidBody3D

@export var G: float = 9.8
@export var center_node: Node3D
@export var center_mass: float = 1.0
@export var semi_minor_axis: float
var semi_major_axis: float
var angle: float = 0.0
var velocity: float = 0.0
var path_container: Node3D

func _ready() -> void:
	if not center_node:
		print("Error: Center node is not assigned.")
		return
	
	semi_major_axis = (global_transform.origin - center_node.global_transform.origin).length()
	path_container = get_parent().get_node("OrbitPath")
	#draw_orbit_path()

func _process(delta: float) -> void:
	if center_node:
		update_position(delta)

func update_position(delta: float) -> void:
	if center_node:
		var distance = calculate_distance_to_center(angle)
		velocity = sqrt(G * center_mass * (2.0 / distance - 1.0 / semi_major_axis))
		angle += velocity * delta / distance
		
		var new_pos = center_node.global_transform.origin + calculate_ellipse_pos(angle)
		var new_transform = global_transform
		new_transform.origin = new_pos
		set_global_transform(new_transform)

func calculate_ellipse_pos(angle: float) -> Vector3:
	var x = semi_major_axis * cos(angle)
	var z = semi_minor_axis * sin(angle)
	return Vector3(x, 0, z)

func calculate_distance_to_center(angle: float) -> float:
	var x = semi_major_axis * cos(angle)
	var z = semi_minor_axis * sin(angle)
	return sqrt(x * x + z * z)

func draw_orbit_path() -> void:
	var num_points = 100
	var step_angle = 2 * PI / num_points
	
	var line = ImmediateMesh.new()
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for i in range(num_points):
		var path_position = center_node.global_transform.origin + calculate_ellipse_pos(step_angle * i)
		surface_tool.add_vertex(path_position)
	
	surface_tool.commit(line)
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = line
	path_container.add_child(mesh_instance)
