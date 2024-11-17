extends GameEntity

class_name Projectile

signal hit(starship : Starship)

@export
var damage : float

var own_ship : Starship

func _ready() -> void:
	$Timer.start()
		
	# Set damage to a random value between 1 and the set damage value

func _on_body_entered(body: Node) -> void:
	if body is Projectile or body == own_ship:
		return
		
	if body is Starship:
		body.damage.rpc(damage)
		hit.emit(body)
	
	print(damage)
	
	queue_free()
	#GameManager.remove_projectile.rpc(self)


func _on_timer_timeout() -> void:
	# Enable specific layers and mask layers as shown in the image
	var layer_mask : int = 0
	layer_mask |= (1 << 1)  # Layer 1
	#layer_mask |= (1 << 7)  # Layer 8
	#layer_mask |= (1 << 9)  # Layer 10
	#layer_mask |= (1 << 19) # Layer 20
	
	self.collision_layer = layer_mask  # Set layer
	self.collision_mask = layer_mask  # Set collision mask


func _on_delete_timer_timeout() -> void:
	queue_free()
