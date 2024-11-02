extends Node

var players : Dictionary = {}

@rpc("any_peer", "call_local")
func remove_projectile(p : Projectile) -> void:
	p.queue_free()
