extends Control

const BUTTON_PATH = "res://GameObj/cardSearchOption.tscn"
const objType = "searchBoxCard"
const BUTTON_HEIGHT = -16
const BUTTON_OFFSET = -80

var card_meta

func setMeta(data):
	card_meta = data

func set_buttons(card, buttons):
	var old_buttons = $Buttons.get_children()
	for i in range(old_buttons.size()):
		$Buttons.remove_child(old_buttons[i])
		
	if(card.cardState.faceup):
		buttons.append({"Action": "Flip", "Label": "Flip"})
	else:
		buttons.append({"Action": "Unflip", "Label": "Unflip"})
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("Image/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = self.z_index - i
