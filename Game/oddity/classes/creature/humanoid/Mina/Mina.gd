extends AnimatedSprite3D

class_name Mina

@export
var humanoid : Humanoid

@export
var hand_sprites : Array[Sprite3D]

var hand_texture : Texture2D = preload("res://classes/creature/humanoid/Mina/sprites/MinaHands.png")
var suit_hand_texture : Texture2D = preload("res://classes/creature/humanoid/Mina/sprites/MinaHands.png")

var in_habitable_atmo : bool

enum State
{
	IDLE,
	FALLING,
	FLOATING
}

var current_state : State = State.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	humanoid.frame_of_reference_changed.connect(on_frame_of_reference_changed)

	on_frame_of_reference_changed()
	
	
func on_frame_of_reference_changed() -> void:
	if humanoid.active_frame_of_reference != null:
		in_habitable_atmo = humanoid.active_frame_of_reference.habitable
	else:
		in_habitable_atmo = false

	change_state(current_state, current_state, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if humanoid.is_in_gravity():
		if !humanoid.is_grounded():
			change_state(current_state, State.FALLING)
		else:
			change_state(current_state, State.IDLE)
	else:
		change_state(current_state, State.FLOATING)

func change_state(old_state : State, new_state : State, atmo_switch : bool = false) -> void:
	if old_state == new_state and !atmo_switch:
		return
		
	current_state = new_state
	
	if new_state == State.IDLE:
		idle()
	elif new_state == State.FALLING:
		falling()
	elif new_state == State.FLOATING:
		floating()

func idle() -> void:
	if in_habitable_atmo:	
		animation = "idleAtmo"
		hands_to_atmo()
	else:
		animation = "idleSuit"
		hands_to_suit()
	
func falling() -> void:
	if in_habitable_atmo:	
		animation = "fallAtmo"
		hands_to_atmo()
	else:
		animation = "fallSuit"
		hands_to_suit()
		
func floating() -> void:
	if in_habitable_atmo:	
		animation = "floatAtmo"
		hands_to_atmo()
	else:
		animation = "floatSuit"
		hands_to_suit()

func hands_to_atmo() -> void:
	for s : Sprite3D in hand_sprites:
		s.texture = hand_texture

func hands_to_suit() -> void:
	for s : Sprite3D in hand_sprites:
		s.texture = suit_hand_texture	