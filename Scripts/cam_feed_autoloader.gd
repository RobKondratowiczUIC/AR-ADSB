extends Node

#func _ready():
#	await get_tree().process_frame
#	CameraServer.set_monitoring_feeds(true)
#	#CameraServer.feed_created.connect(_on_feed_created)
#	CameraServer.camera_feed_added.connect(_on_feed_added)
#	# 2. Check if a camera feed is already available at startup
#	var feeds = CameraServer.feeds()
#	if feeds.size() > 0:
#		_activate_camera(feeds[0])
#	else:
#		print("Waiting for camera feed connections...")
#
#func _on_feed_added(feed: CameraFeed) -> void:
#	_activate_camera(feed)
#
#func _activate_camera(feed: CameraFeed) -> void:
#	if feed and not feed.feed_is_active:
#		#feed.set_format(0,{"output": "separate"})
#		feed.set_format(0,{})
#		feed.feed_is_active = true
#		print("Camera activated: ", feed.get_name(), " ID: ", feed.get_id())



func _ready() -> void:
	print("Godot version: ", Engine.get_version_info())

	if OS.get_name() == "Android":
		print("Camera permission before request: ",
			OS.get_granted_permissions())

		if not OS.get_granted_permissions().has("android.permission.CAMERA"):
			print("Requesting camera permission...")
			OS.request_permission("android.permission.CAMERA")

			# Permission dialogs are asynchronous. Run the app again
			# after granting permission if needed.

	CameraServer.monitoring_feeds = true
	#await get_tree().create_timer(1.0).timeout
	
	print(CameraServer.feeds())

	for feed in CameraServer.feeds():
		if feed.get_position() != CameraFeed.FEED_BACK:
			continue

		print("Selected feed: ", feed.get_name())
		print("Feed ID: ", feed.get_id())

		feed.frame_changed.connect(func():
			print("Camera frame received")
		, CONNECT_ONE_SHOT)
		
		feed.set_format(0,{})
		feed.set_active(true)
		#feed.feed_is_active = true
		
		#var tex = CameraTexture.new();
		#tex.camera_feed_id = feed.get_id();
		#tex.camera_is_active = true
		
		#print(feed.formats)

		print("Active immediately: ", feed.feed_is_active)

		await get_tree().create_timer(3.0).timeout

		print("Active after 3 seconds: ", feed.feed_is_active)
		break