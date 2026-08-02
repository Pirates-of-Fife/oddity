extends Openable

class_name RABS_KestrelMk1_Ramp

var initial_direction : Vector3

func _ready() -> void:
	super._ready()
	
	initial_direction = $GPUParticles3D.process_material.get("direction")

func _process(delta: float) -> void:
	$GPUParticles3D.process_material.set("direction", initial_direction * global_basis.inverse())
	$GPUParticles3D2.process_material.set("direction", initial_direction * global_basis.inverse())

func _on_openable_opening() -> void:
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true

func _on_openable_closing() -> void:
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true

func _on_openable_closed() -> void:
	$GPUParticles3D.emitting = false
	$GPUParticles3D2.emitting = false

func _on_openable_opened() -> void:
	$GPUParticles3D.emitting = false
	$GPUParticles3D2.emitting = false