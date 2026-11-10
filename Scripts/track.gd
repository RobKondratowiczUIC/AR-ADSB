class_name Track
extends Sprite3D


var speed_fts : float # knots
var heading : float # clockwise starting from north

var vertical_speed_ftm : float # feet per minute

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var movement_vec: Vector3 = Vector3();
	
	##TODO: fix the direction vector orientation and speed convertion values
	movement_vec.z =  speed_fts * (-cos(deg_to_rad(heading))) * 0.514444
	movement_vec.x =  speed_fts * (sin(deg_to_rad(heading))) * 0.514444
	
	movement_vec.y = (vertical_speed_ftm/60.0) * 0.3048
	
	position += movement_vec * delta
	
	pass
