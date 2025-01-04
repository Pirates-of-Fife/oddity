extends GameEntity

class_name Projectile

signal hit(game_entity : GameEntity)

@export
var timeout : float

@export
var on_hit_sound : PackedScene

var damage : float

func _ready() -> void:
	_projectile_ready()
	
func _projectile_ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var timer : Timer = Timer.new()
	
	add_child(timer)
	
	timer.wait_time = timeout
	timer.one_shot = true
	timer.timeout.connect(_on_timerout)
	timer.start()
	
func _on_timerout() -> void:
	queue_free()

func _on_body_entered(body : Node) -> void:
	if body is GameEntity or body is StaticGameEntity:
		body.take_damage(damage)
		if body is GameEntity:
			hit.emit(body)
		
		var hit_sound : AudioStreamPlayer3D = on_hit_sound.instantiate()
		get_tree().get_first_node_in_group("StarSystem").add_child(hit_sound)
		hit_sound.global_position = global_position
	
	if body is Shield:
		body.take_damage(damage)
		hit.emit(body.game_entity)
	
	queue_free()
	
