extends Node

@onready var virtual_camera: PhoneMatcher = $"Control/SubViewportContainer/SubViewport/Node3D/Camera3D"
@onready var menu: Control = $"Control/UI/PanelContainer"

#@onready var camera_controller : PhoneMatcher = $"Control/SubViewportContainer/SubViewport/Node3D/Camera3D"


func _on_fov_slider_value_changed(value: float) -> void:
	virtual_camera.fov = value;
	pass # Replace with function body.

func _on_acck_slider_value_changed(value: float) -> void:
	virtual_camera.k_acc = value
	pass;
	
func _on_magk_slider_value_changed(value: float) -> void:
	virtual_camera.k_mag = value
	pass;

func _on_button_pressed() -> void:
	menu.visible = !menu.visible
	pass # Replace with function body.
