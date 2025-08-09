extends ComponentResource

class_name CoolerResource

@export_category("Cooler Info")

@export # how much heat a cooler can abosrb per interval
var cooling_capacity : float

@export # how much heat a cooler can maximally store
var heat_sink_size : float

@export
var cooling_interval : float
