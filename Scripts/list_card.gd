extends Control

var cardMeta
var source

signal hovered
signal clicked_right
signal clicked_left

func _ready() -> void:
	get_parent().get_parent().get_parent().get_parent().connect_signals(self)

func _on_card_image_mouse_entered() -> void:
	$Timer.start()

func _on_card_image_mouse_exited() -> void:
	$Timer.stop()

func _on_timer_timeout() -> void:
	emit_signal("hovered", {"set": cardMeta.setName, "number": cardMeta.cardNumber})


func _on_card_image_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				emit_signal("clicked_left", source, cardMeta)
			MOUSE_BUTTON_RIGHT:
				emit_signal("clicked_right", source, cardMeta)
