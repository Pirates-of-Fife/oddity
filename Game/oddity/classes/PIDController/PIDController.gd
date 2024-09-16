# based off this implementation : https://www.youtube.com/watch?v=zOByx3Izf5U

extends Node

class_name PIDController

# Controller gains
@export_category("Gains")

@export
var Kp : float # Proportional gain

@export
var Ki : float # Integral gain

@export
var Kd : float # Derivative gain

# derivative low-pass filter time constant

@export_category("Low pass filter")
@export_range(0.001, 1.0, 0.001)
var tau : float = 0.02

# output limits
@export_category("Limits")

@export
var limit_min : float

@export
var limit_max : float

# controller "memory"
var integrator : float = 0
var previous_error : float = 0
var differentiator : float = 0
var previous_measurement : float = 0

# controller output
var output : float = 0

func _init(proportional_gain : float, integral_gain : float, derivative_gain : float, low_pass_filter_tau : float, minimum_limit : float, maximum_limit : float) -> void:
	Kp = proportional_gain
	Ki = integral_gain
	Kd = derivative_gain
	
	tau = low_pass_filter_tau
	
	limit_min = minimum_limit
	limit_max = maximum_limit
	
func update(setpoint : float, measurement : float, delta : float) -> float:	
	# Error signal
	var error : float = setpoint - measurement
	
	# Proportional
	var proportional : float = Kp * error
	
	# Integral
	integrator = integrator + 0.5 * Ki * delta * (error + previous_error)
	
	# Anti-wind-up via dynamic integrator clamping
	var limit_min_integrator : float
	var limit_max_integrator : float
	
	if (limit_max > proportional):
		limit_max_integrator = limit_max - proportional
	else:
		limit_max_integrator = 0.0
	
	if (limit_min < proportional):
		limit_min_integrator = limit_min - proportional
	else:
		limit_min_integrator = 0.0
	
	# clamp integrator
	integrator = clampf(integrator, limit_min_integrator, limit_max_integrator)
	
	# Derivative (band-limited differentiator)
	differentiator = (
						-(2.0 * Kd * (measurement - previous_measurement))
						+ ((2.0 * tau - delta) * differentiator)
						/ (2.0 * tau + delta)
					)
	
	# Compute output and apply limits
	output = proportional + integrator + differentiator
	
	output = clampf(output, limit_min, limit_max)
	
	# store error and measurement for later use
	previous_error = error
	previous_measurement = measurement
	
	return output
