class_name Track
extends Sprite3D


var speed_fts : float
var heading : float 

var vertical_speed_ftm : float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var movement_dir: Vector3 = Vector3();
	
	##TODO: fix the direction vector orientation and speed convertion values
	movement_dir.z =  speed_fts * (-cos(heading)) * 0.3048 * delta
	movement_dir.x =  speed_fts * (sin(heading)) * 0.3048 * delta
	
	movement_dir.y = (vertical_speed_ftm*60.0) * 0.3048
	
	position += movement_dir * delta
	
	pass
