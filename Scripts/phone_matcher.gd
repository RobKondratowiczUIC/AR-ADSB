extends Camera3D
class_name PhoneMatcher

var pitch: float = 0.0
var roll: float = 0.0
var yaw: float = 0.0

var initial_yaw : float = 0.0

#var k: float = 0.9
#var k2: float = 0.9
@export var k_acc : float = 0.5
@export var k_mag : float = 0.95

func _ready():
	#await(get_tree(),"idle_frame")
	#var magnet: Vector3 = Input.get_magnetometer()
	#print(magnet)
	#initial_yaw = atan2(-magnet.x, magnet.z) 
	pass

func _physics_process(delta):
	var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	gravity = gravity.rotated(-Vector3.FORWARD, rotation.z)
	var pitch_acc = atan2(gravity.z, -gravity.y)
	var yaw_magnet = atan2(-magnet.x, magnet.z)
	
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k_acc)
	##yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	#yaw = lerp_angle(yaw_magnet, yaw , k2)
	yaw = lerp_angle(yaw_magnet, yaw , k_mag)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k_acc) 
	
	#rotation = Vector3(pitch, yaw - initial_yaw, roll)
	rotation = Vector3(pitch, yaw, roll)