extends ComponentResource

class_name AlcubierreDriveResource

@export_category("Alcubierre Drive Stats")

@export
var spool_time : float

@export
var acceleration : float

@export
var deacceleration : float

@export
var max_speed : float

@export
var max_turn_speed : float

@export
var fuel_per_second : float

@export
var fuel_curve : Curve

@export_subgroup("Sounds")

@export
var charging_start : AudioStream

@export
var charging_sound : AudioStream

@export
var charging_end : AudioStream

@export
var travelling_sound : AudioStream
