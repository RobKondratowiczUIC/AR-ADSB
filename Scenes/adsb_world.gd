extends Node3D
class_name AdsbWorld

@export var selected_track: Track

signal selected_track_changed(icao: Track)

@onready var MainCamera:Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		var mouseLoc:Vector2 = get_viewport().get_mouse_position()
		var from : Vector3 = MainCamera.project_ray_origin(mouseLoc)
		var to : Vector3 = from + MainCamera.project_ray_normal(mouseLoc) * 1000000
		
		print(from)
		print(to)
		
		#var ray:RayCast3D = RayCast3D.new();
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from , to)
		query.collide_with_areas = true;
		# should be called in _physics_process
		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

		#print(result["collider"])
		if result:
			var track_collider: Area3D = result["collider"]
			var track : Track = track_collider.get_parent()
			if track:
				print(track.hex)
				selected_track = track
				selected_track_changed.emit(selected_track)
			else:
				selected_track_changed.emit(null)
		else:
			selected_track_changed.emit(null)
		
		
#func _input(event):
#	print("Event")
#	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
#		print("MouseEvent")
#		var from = MainCamera.project_ray_origin(event.position)
#		var to = from + MainCamera.project_ray_normal(event.position) * 10000000
#		
#		#var ray:RayCast3D = RayCast3D.new();
#		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from , to)
#		# should be called in _physics_process
#		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
#		
#		print(result["collider"])
