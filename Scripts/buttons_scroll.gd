extends Control

const objType = "searchBoxButton"
var button_type

func _on_texture_rect_2_mouse_entered() -> void:
	$TextureRect2.texture = load("res://Assets/Button_Ready_Hovered.png")
	$RichTextLabel.modulate = "#ffffff"


func _on_texture_rect_2_mouse_exited() -> void:
	$TextureRect2.texture = load("res://Assets/Button_Ready.png")
	$RichTextLabel.modulate = "#000000"
