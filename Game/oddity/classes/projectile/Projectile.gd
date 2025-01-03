extends GameEntity

class_name Projectile

signal hit(game_entity : GameEntity)

@export
var timeout : float

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
	if body is GameEntity:
		body.take_damage(damage)
		hit.emit(body)
	
	if body is Shield:
		body.take_damage(damage)
		hit.emit(body.game_entity)
	
	queue_free()
	
