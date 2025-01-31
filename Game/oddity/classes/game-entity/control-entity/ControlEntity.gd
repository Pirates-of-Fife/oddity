extends GameEntity

class_name ControlEntity

signal toggle_third_person_view
signal toggle_look_around_view
signal increase_third_person_distance
signal decrease_third_person_distance

@export
var third_person_distance_change_sensitivity : float = 1

var look_around : bool = false
var third_person : bool = false

@export
var player : Mind = null

@export_category("Controller")

@export
var controller_reference : String

@export
var ai_controller_reference : String

@export_category("Anchor")
@export
var anchor : Anchor

func set_active_anchor(new_anchor : Anchor) -> void:
	anchor.active = false
	anchor = new_anchor
	new_anchor.active = true

func toggle_third_person() -> void:
	toggle_third_person_view.emit()

func third_person_decrease_distance() -> void:
	decrease_third_person_distance.emit()

func third_person_increase_distance() -> void:
	increase_third_person_distance.emit()

func toggle_look_around() -> void:
	toggle_look_around_view.emit()

func _control_entity_process(delta : float) -> void:
	_default_process(delta)
