extends Node3D
class_name AircraftTrack

## private
var lat: float
var long : float
var altitude : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_geo_position(new_lat, new_long, new_altitude):
	#TODO: add isdirty check to see if processing is needed?
	lat = new_lat
	long = new_long
	altitude = new_altitude
	
	recalculate_position();
	pass
	
func recalculate_position():
	pass