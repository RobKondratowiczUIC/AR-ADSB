extends Node3D
class_name AdsbTrackManager

var adsb_https : HTTPRequest
var adsb_https_call_timer : Timer;

@export var lat: float = 41.98461398314586
@export var long: float = -87.64343999482587
@export var radius: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## AADSB HTTPS
	adsb_https = HTTPRequest.new();
	add_child(adsb_https)
	adsb_https.request_completed.connect(_on_adsb_https_request_complete);
	#adsb_https.request("https://api.adsb.lol/v2/point/%f/%f/%f" % [lat,long, radius])
	
	## ADSB HTTPS Call Timer
	adsb_https_call_timer = Timer.new()
	add_child(adsb_https_call_timer)
	adsb_https_call_timer.wait_time = 5.0;
	adsb_https_call_timer.timeout.connect(_on_adsb_https_call_timer_timeout)
	adsb_https_call_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_adsb_https_call_timer_timeout():
	adsb_https.request("https://api.adsb.lol/v2/point/%f/%f/%f" % [lat,long, radius])
	
func _on_adsb_https_request_complete(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	process_tracks(json)
	pass
	
func process_tracks(json_obj):
	for trackjson in json_obj["ac"]:
		## doesnt account for old tracks that should be removed
		var trackhex= trackjson["hex"]
		var local_vector: Vector3 = geo_to_local(trackjson["lat"],trackjson["lon"],trackjson["alt_geom"])
		
		## this is broken
		
		#var current_track :AircraftTrack = find_child(trackhex) ##TODO: change
		#if(current_track == null):
		#	current_track = AircraftTrack.new()
		#	current_track.name = trackhex
		#	add_child(current_track)
		
		var current_track = null
		var current_tracks = get_children()
		for child in current_tracks:
			if(child is AircraftTrack):
				if(child.name == trackhex):
					current_track = child
				else:
					current_track = AircraftTrack.new()
					current_track.name = trackhex
					add_child(current_track)
					

		current_track.position = Vector3(local_vector.x, local_vector.y,local_vector.z)
		# double check if this works
		

func geo_to_local(latitude, longitude, altitude) -> Vector3:
	return Vector3(latitude, altitude, longitude)
	pass
