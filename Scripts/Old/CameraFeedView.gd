extends TextureRect

var camera_feed : CameraFeed;
var cam_texture : CameraTexture;

var adsb_https : HTTPRequest
var adsb_https_call_timer : Timer;

var geolocation : AndroidGeolocationPlugin

var camera_transform : Node3D;

var tracks : Dictionary[String,AircraftTrack]

var lat: float = 41.98461398314586
var long: float = -87.64343999482587
var radius: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	## camera Feed
	CameraServer.set_monitoring_feeds(true);
	camera_feed = CameraServer.feeds()[0];
	print(camera_feed.formats);
	camera_feed.set_format(0, {})
	camera_feed.feed_is_active = true;
	
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
	
	## Geolocation
	geolocation = AndroidGeolocationPlugin.new()
	add_child(geolocation)
	if(geolocation._has_location_permission()):
		geolocation.android_location_updated.connect(_on_geo_location_changed)
	geolocation.android_location_permission_updated.connect(_on_geo_location_permission_changed)
	
	## Camera transform
	camera_transform = Node3D.new()
	add_child(camera_transform)
	## color conversion
	
	#var camTextureY : CameraTexture = CameraTexture.new();
	#camTextureY.camera_feed_id = camera_feed.get_id();
	#
	#var camTextureCbCr : CameraTexture = CameraTexture.new();
	#camTextureCbCr.camera_feed_id = camera_feed.get_id();
	#
	#var mat: ShaderMaterial = ShaderMaterial.new()
	#if mat:
	#	mat.set_shader_parameter("camera_y", camTextureY)
	#	mat.set_shader_parameter("camera_cbcr", camTextureCbCr)
	
	var tex = texture as CameraTexture;
	tex.camera_feed_id = camera_feed.get_id();
	tex.camera_is_active = true;
	
	#self.material = mat
	
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
		var track : AircraftTrack = tracks.get_or_add(trackhex) as AircraftTrack
		if(track == null):
			track = AircraftTrack.new()
			add_child(track)
		track.position = Vector3(local_vector.x, local_vector.y,local_vector.z)
		# double check if this works

func _on_geo_location_permission_changed(granted: bool):
	if(granted):
		geolocation.android_location_updated.connect(_on_geo_location_changed)
	pass
	
func _on_geo_location_changed(location_dictionary: Dictionary):
	var latitude: float = location_dictionary["latitude"]
	var longitude: float = location_dictionary["longitude"]
	print(str('Location Update: Latitude[', latitude, '], Longitude[', longitude, ']'))
	
	pass
		
func _exit_tree() -> void:
	# Clean up and shutdown hardware sensor usage on exit
	if camera_feed:
		camera_feed.feed_is_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	
func geo_to_ECEF(latitude, longitude, altitude) -> Vector3:
	## ripped from google
	var a : float = 6378137.0  # WGS84 semi-major axis in meters
	var f : float = 1.0 / 298.257223563
	var e2 : float = 2 * f - f * f  # First eccentricity squared
	
	#lat = math.radians(lat_deg)
	#lon = math.radians(lon_deg)
	
	var sin_lat: float = sin(latitude)
	var cos_lat: float = cos(latitude)
	var sin_lon: float = sin(longitude)
	var cos_lon: float = cos(longitude)
	
	var N : float = a / sqrt(1.0 - e2 * sin_lat * sin_lat)
	
	var x = (N + altitude) * cos_lat * cos_lon
	var y = (N + altitude) * cos_lat * sin_lon
	var z = (N * (1.0 - e2) + altitude) * sin_lat
	return Vector3(x, y, z)
	pass
	
func geo_to_local(latitude, longitude, altitude) -> Vector3:
	return Vector3(latitude, altitude, longitude)
	pass
