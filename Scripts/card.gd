extends Node2D

signal hovered
signal hovered_off

const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

const objType = "card"

const BUTTON_PATH = "res://GameObj/button.tscn"

var transitZone

var cardMeta

func _ready() -> void:
	get_parent().connect_card_signals(self)
	transitZone = $"../../Transit"

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func setMeta(card):
	cardMeta = card

func set_buttons(card, buttons):
	if(card.cardState.faceup):
		buttons.append("Flip")
	else:
		buttons.append("Unflip")
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i]
		$Buttons.add_child(new_button)
		new_button.get_node("Image/Text").text = buttons[i]
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 200 - i
		
func build():
	transitZone.move_to("stage", cardMeta, false)

func toDiscard():
	transitZone.move_to("discard", cardMeta, false)
	
func toCardPool():
	transitZone.move_to("cardpool", cardMeta, false)
	
func remove():
	transitZone.move_to("removed", cardMeta, false)
	
func toMomentum():
	transitZone.move_to("momentum", cardMeta, false)
	
func flip():
	pass
	
func unflip():
	pass
	
func toDeck():
	pass

func call_fun(buttonName):
	match buttonName:
		"Build":
			build()
		"To Discard":
			toDiscard()
		"Add to Card Pool":
			toCardPool()
		"Remove":
			remove()
		"Add to Momentum":
			toMomentum()
		"Flip":
			flip()
		"Unflip":
			unflip()
		"To Deck":
			toDeck()
