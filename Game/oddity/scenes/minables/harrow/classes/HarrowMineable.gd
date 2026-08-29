extends Minable

class_name HarrowMineable

var seedpods : Array[HarrowSeedPod] 

func _ready() -> void:
	_harrow_mineable_ready()

func _harrow_mineable_ready() -> void:
	_mineable_ready()
	
	for node : Node3D in get_children():
		if node is HarrowSeedPod:
			seedpods.append(node)
			node.seedpod_destroyed.connect(on_seedpod_destroyed)
	
	resource_depleted.connect(_on_resource_depleted)

func _on_resource_depleted() -> void:
	for seed : HarrowSeedPod in seedpods:
		seed.fall()

func on_seedpod_destroyed(seedpod : HarrowSeedPod) -> void:
	seedpods.erase(seedpod)
