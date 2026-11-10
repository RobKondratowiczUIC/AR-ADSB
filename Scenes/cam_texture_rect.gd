extends TextureRect

@export var cam_feed_id: int
@export var cam_feed_format_id: int

var raw_tex: CameraTexture

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	raw_tex = CameraTexture.new();
	raw_tex.camera_feed_id = cam_feed_id;
	
	var text_mat : ShaderMaterial