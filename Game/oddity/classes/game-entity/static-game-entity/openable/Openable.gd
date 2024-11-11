extends StaticGameEntity

# Base class for doors, hatches, etc.

class_name Openable

enum State {
	OPEN,
	CLOSED,
	OPENING,
	CLOSING
}

enum Type {
	MANUAL,
	AUTO
}

@export
var animation_player : AnimationPlayer

var state : State

@export
var type : Type

@export
var detection_area : Area3D

@export
var interactables : Array = Array()

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_player_animation_finished)
	animation_player.animation_changed.connect(on_animation_player_animation_changed)
	
	state = State.CLOSED
	
	if interactables.size() > 0:
		for i : NodePath in interactables:
			var interactable : Variant = get_node(i)
			
			if interactable is Interactable:
				interactable.interacted.connect(on_interact)

func open() -> void:
	if state == State.CLOSED:
		animation_player.play("open")
		state = State.OPENING
	
	elif state == State.CLOSING:
		animation_player.queue("open")
	
func close() -> void:
	if state == State.OPEN:
		animation_player.play("close")
		state = State.CLOSING
	
	elif state == State.OPENING:
		animation_player.queue("close")
		
func toggle_open_state() -> void:
	if state == State.OPEN or state == State.OPENING:
		close()
	elif state == State.CLOSED or state == State.CLOSING:
		open()

func on_interact(player : Player, control_entity : ControlEntity) -> void:
	toggle_open_state()

func creature_entered(body : Node3D) -> void:
	if body is Creature and type == Type.AUTO:
		open()
	
func creature_exited(body : Node3D) -> void:
	if body is Creature and type == Type.AUTO:
		close()

func on_animation_player_animation_finished(anim_name : String) -> void:
	if anim_name == "open":
		state = State.OPEN
	elif anim_name == "close":
		state = State.CLOSED
		
func on_animation_player_animation_changed(old_name : String, new_name : String) -> void:
	if new_name == "open" and old_name == "close":
		state = State.OPENING
	elif new_name == "close" and old_name == "open":
		state = State.CLOSING
		
