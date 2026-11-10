extends Control
class_name AdsbScreenSpaceDrawing

@onready var adsb_manager : AdsbTrackManager = $"../UI/SubViewportContainer/SubViewport/Node3D/ADSBTrackManager"
@onready var camera : Camera3D = $"../UI/SubViewportContainer/SubViewport/Node3D/PhoneMatcher"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float):
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw() -> void:
	print("drawing..")
	for track in adsb_manager.get_children():
		print(track.name)
		if track is Node3D:
			var track3d :Vector3 = track.global_position
			if(!camera.is_position_behind(track3d)):
				var track2d :Vector2 = camera.unproject_position(track3d)
				draw_circle(track2d, 5, Color.RED)
				print(track2d)
	pass
