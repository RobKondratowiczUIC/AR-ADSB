extends Node


@onready var adsb_world:AdsbWorld = $Control/SubViewportContainer/SubViewport/Node3D

@onready var virtual_camera: PhoneMatcher = $"Control/SubViewportContainer/SubViewport/Node3D/Camera3D"
@onready var menu: Control = $"Control/UI/PanelContainer"
@onready var menu_track_hex_label : Label =  $Control/UI/HBoxContainer/Hex
@onready var menu_track_alt_label : Label = $Control/UI/HBoxContainer/Altitude
@onready var menu_track_typ_label : Label = $Control/UI/HBoxContainer/Type

var selected_track : Track


#@onready var camera_controller : PhoneMatcher = $"Control/SubViewportContainer/SubViewport/Node3D/Camera3D"

func _process(delta: float) -> void:
	if selected_track:
		menu_track_hex_label.text = "Hex: %s" % selected_track.hex
		menu_track_typ_label.text = "Type: %s" % selected_track.full_ac_track["t"]
		menu_track_alt_label.text = "Alt: %f ft" % selected_track.full_ac_track["alt_baro"]
	else:
		menu_track_hex_label.text = "Hex: N/A"
		menu_track_alt_label.text = "Alt: N/A ft"

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


func _on_adsb_world_selected_track_changed(icao: Track) -> void:
	selected_track = icao
	pass # Replace with function body.
