extends CanvasLayer

class_name CreditHud

@onready
var credit_change_label : PackedScene = preload("res://classes/mind/player/CreditChangeLabel.tscn")

@export
var player : Player

@export
var current_credits : int

@export
var displayed_credits : int

@onready
var queue : Control = $Container/Queue

@onready
var credit_label : Label = $Container/CreditLabel

var queue_length : int = 0

func add_to_queue(label : CreditChangeLabel) -> void:
	queue.add_child(label)
	label.position.x = 48
	label.position.y = queue_length * 14
	queue_length += 1

	$Timer.start()

func remove_from_queue() -> void:
	if queue_length == 0:
		return

	var label : CreditChangeLabel = queue.get_child(0)

	current_credits += label.credits
	#credit_label.text = convert_to_human_readable(current_credits)

	label.queue_free()

	queue_length -= 1

	for l : CreditChangeLabel in queue.get_children():
		l.position.y -= 14

	if queue_length == 0:
		$Timer.stop()
	else:
		$Timer.start()

func convert_to_human_readable(credits : int) -> String:
	var suffixes : Array = ["", "k", "M", "B", "T", "P"] # Add more if needed
	var index : int = 0
	var value : float = float(credits)

	if credits < 1000:
		return str(credits)

	# Reduce the value and find the appropriate suffix
	while value >= 1000 and index < suffixes.size() - 1:
		value /= 1000
		index += 1

	# Format the result to one decimal place if necessary
	if value >= 10:
		return str(round(value)) + suffixes[index]
	else:
		return "%.1f%s" % [value, suffixes[index]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.credits_added.connect(on_credits_added)
	player.credits_removed.connect(on_credits_removed)
	current_credits = player.credits
	displayed_credits = current_credits

	player.posses.connect(on_possess)

func on_possess(control_entity : ControlEntity) -> void:
	if control_entity is Starship:
		$Container/OnFootCrosshair.hide()
	else:
		$Container/OnFootCrosshair.show()

func _process(delta: float) -> void:
	displayed_credits = lerp(displayed_credits, current_credits, 0.1)
	credit_label.text = convert_to_human_readable(displayed_credits)

func on_credits_added(credits : int) -> void:
	var label : CreditChangeLabel = credit_change_label.instantiate()
	label.credits = credits

	label.text = "+ " + convert_to_human_readable(credits)

	add_to_queue(label)

func on_credits_removed(credits : int) -> void:
	var label : CreditChangeLabel = credit_change_label.instantiate()
	label.credits = -credits

	label.text = "- " + convert_to_human_readable(credits)

	add_to_queue(label)


func _on_timer_timeout() -> void:
	remove_from_queue()
