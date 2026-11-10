extends Node

## Nodes
var adsb_https : HTTPRequest
var adsb_https_call_timer : Timer
var android_geo_location : AndroidGeolocationPlugin

## variables
@export var lat: float = 41.98461398314586
@export var long: float = -87.64343999482587
@export var radius: float = 25.0

var track_dict : Dictionary

@export var track_view : PackedScene = preload("res://Scenes/track_sprite.tscn"); # representation of a track in the scene # may want to change to not preload?

func _ready() -> void:
	## ADSB HTTPS
	adsb_https = HTTPRequest.new();
	add_child(adsb_https)
	adsb_https.request_completed.connect(_on_adsb_https_request_complete);
	
	## ADSB HTTPS Call Timer
	adsb_https_call_timer = Timer.new()
	add_child(adsb_https_call_timer)
	adsb_https_call_timer.wait_time = 5.0;
	adsb_https_call_timer.timeout.connect(_on_adsb_https_call_timer_timeout)
	adsb_https_call_timer.start()
	
	# ping adsb.lol immdiatly first
	_on_adsb_https_call_timer_timeout()
	
	android_geo_location = AndroidGeolocationPlugin.new()
	add_child(android_geo_location)
	android_geo_location.android_location_updated.connect(_on_android_location_updated)
	
	pass

func _process(delta: float) -> void:
	pass

func _on_adsb_https_call_timer_timeout():
	print("pinging ADSB.lol")
	adsb_https.request("https://api.adsb.lol/v2/point/%f/%f/%f" % [lat,long, radius])
	
func _on_adsb_https_request_complete(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if(json != null):
		process_tracks(json)
	pass
	
#func process_tracks(json_obj):
#	for track_json in json_obj["ac"]:
#		var track_node:Node3D = track_dict.get(track_json["hex"])
#		if(track_node == null):
#			track_node = track_view.instantiate() # should change to a sprite or something
#			add_child(track_node)
#			track_dict[track_json["hex"]] = track_node
#		track_node.position = geo_to_local(float(track_json["lat"]),float(track_json["lon"]),float(track_json["alt_baro"]) * 0.3048)

func process_tracks(json_obj):
	for track_json: Dictionary in json_obj["ac"]:
		print(track_json)
		var track_node:Track = track_dict.get(track_json["hex"])
		if(track_node == null):
			track_node = track_view.instantiate() # should change to a sprite or something
			add_child(track_node)
			track_dict[track_json["hex"]] = track_node
		track_node.position = geo_to_local(float(track_json["lat"]),float(track_json["lon"]),float(track_json["alt_baro"]) * 0.3048)
		track_node.speed_fts = float(track_json["gs"]) if track_json.has("gs") else 0.0 
		track_node.heading = float(track_json["track"]) if track_json.has("track") else 0.0 
		track_node.vertical_speed_ftm = float(track_json["baro_rate"]) if track_json.has("baro_rate") else (float(track_json["geom_rate"]) if track_json.has("geom_rate") else 0.0)

func _on_android_location_updated(dict):
	var newLat : float = float(dict["latitude"])
	var newLong : float = float(dict["longitude"])
	
	print("New Geolocation recieved ", newLat, newLong)
	
	if(newLat != null): lat = newLat
	if(newLong != null): long = newLong


#### Helper functions
	
## https://stackoverflow.com/questions/78154941/convert-data-of-the-format-longitude-latitude-altitude-into-the-format-x-y
func geo_to_local(latitude:float, longitude:float, altitude:float) -> Vector3:
	# ecef coordinates for the station:
	var bgr_xyz = gps_to_geocentric_ecef(self.lat, self.long, 1.6)
	
	# ecef coordinates for the (first) airplane:
	var plane_xyz = gps_to_geocentric_ecef(latitude, longitude, altitude)
	
	# xyz position of the airplane relative to the station, ecef orientation:
	var diff_xyz = plane_xyz - bgr_xyz
	
	# xyz position of the airplane relative to the station, station-local orientation
	var local_xyz = rotate_ecef_to_local_xyz(diff_xyz.x,diff_xyz.y,diff_xyz.z, self.lat, self.long)
	#var local_xyz = rotate_ecef_to_local_xyz(-diff_xyz.z,diff_xyz.x,diff_xyz.y, self.lat, self.long)
	return local_xyz

func rotate_ecef_to_local_xyz(dx, dy, dz, latitude, longintude):
	# rotates the coordinate differences dx, dy, dz fromm the global frame (ECEF) to
	# a local frame that has the geodetic normal to (lat, lon) as z-axis, while
	# the new x-axis is towards North and the y-axis towards East
	
	var nx:float = -dz 
	var ny:float = dx 
	var nz:float = dy 
	
	var latt:float = deg_to_rad(latitude)
	var lonn:float = deg_to_rad(longintude)
	
	var cos_lon:float = cos(lonn)
	var sin_lon:float = sin(lonn)
	var cos_lat:float = cos(latt)
	var sin_lat:float = sin(latt)
	var dxx:float = - dx * cos_lon * sin_lat - dy * sin_lon * sin_lat + dz * cos_lat
	var dyy:float = - dx * sin_lon + dy * cos_lon
	var dzz:float = dx * cos_lon * cos_lat + dy * sin_lon * cos_lat + dz * sin_lat

	#return Vector3(dxx, dyy, dzz)
	#return Vector3(-dzz, dxx, dyy)
	
	return Vector3(dyy, dzz, -dxx)
	
var a:float = 6378137  # semi major axis, WGS84
#var f = 1 / 298.257223563 # WGS84
var e2:float = 6.69437999014e-3  # eccentricity, WGS84 e2 = 1 - (1-f)*(1-f)

## TODO: double check that godot forward is north and godot right is east
func gps_to_geocentric_ecef(latitude:float, longitude:float, alt:float):
	# converts geodetic latitude, longitude, altitude based on WGS84 (GPS coordinates)
	# to geocentric x, y, z in meters (ECEF), sqrt(x^2+y^2+z^2) = geocentric radius
	# |z| distance to equatorial plane, |x| distance to the plane of the prime meridian
	# https://en.wikipedia.org/wiki/Geodetic_coordinates#Conversion
	# https://github.com/proj4js/proj4js/blob/master/lib/datumUtils.js#L68C5-L70C44
	# verify: https://tool-online.com/en/coordinate-converter.php (right select WORLD and XYZ (geocentric))
	# or: https://www.oc.nps.edu/oc2902w/coord/llhxyz.htm - paste lat, lon, height, then press "LLH to ECEF"
	
	var latt:float = deg_to_rad(latitude)
	var lonn:float = deg_to_rad(longitude)
	var sin_lat:float = sin(latt)
	var cos_lat:float = cos(latt)
	var cos_lon:float = cos(lonn)
	var sin_lon:float = sin(lonn)
	
	var rn:float = a / (sqrt(1 - e2 * sin_lat * sin_lat))
	var x:float = (rn + alt) * cos_lat * cos_lon
	var y:float = (rn + alt) * cos_lat * sin_lon
	var z:float = ((rn * (1 - e2)) + alt) * sin_lat
	
	return Vector3(x, y, z)
	#return Vector3(-z, x, y)


func _on_android_geolocation_plugin_android_location_updated(location_dictionary: Dictionary) -> void:
	lat = float(location_dictionary["latitude"])
	long = float(location_dictionary["longitude"])
	pass # Replace with function body.
