extends Node2D

const objType = "button"

var button_type

func _on_area_2d_mouse_entered() -> void:
	$Image.texture = load("res://Assets/Button_Ready_Hovered.png")
	$Control/Text.modulate = "#ffffff"


func _on_area_2d_mouse_exited() -> void:
	$Image.texture = load("res://Assets/Button_Ready.png")
	$Control/Text.modulate = "#000000"
	
