extends Node3D
@onready var environment :WorldEnvironment = $"WorldEnvironment"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CameraServer.set_monitoring_feeds(true)
	environment.environment = Environment.new()
	
	
	var feeds:Array[CameraFeed] = CameraServer.feeds()
	var feed: CameraFeed = feeds[0]
	feed.set_format(0, {})
	feed.feed_is_active = true
	
	environment.environment.background_mode = Environment.BG_CAMERA_FEED;
	environment.environment.background_camera_feed_id = 1;
	
	environment.camera_attributes = CameraAttributes.new()
	
# Attempt to configure any already detected feeds immediately
#	_configure_feeds()
#	
#func _on_camera_feed_added(_id: int) -> void:
#	_configure_feeds()
#		
#func _configure_feeds() -> void:
#	var feeds:Array[CameraFeed] = CameraServer.feeds()
#	if feeds.size() > 0:
#		# Access the primary feed (ID 1 in your Environment settings maps to index 0 here)
#		var feed: CameraFeed = feeds[0]
#		
#		# Turn the camera stream on
#		feed.set_format(0, {})
#		feed.feed_is_active = true
#		
#		print("Activated camera feed: ", feed.get_name())
#	else:
#		print("No camera feeds detected. Note: Windows requires external plugins.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


