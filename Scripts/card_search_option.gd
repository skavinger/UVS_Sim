extends Control

const BUTTON_PATH = "res://GameObj/CardObjs/buttonsScroll.tscn"
const objType = "searchBoxCard"
const BUTTON_HEIGHT = -28

var cardMeta

var transitZone

func _ready() -> void:
	transitZone = $"../../../../../../Player/Transit"

func setMeta(data):
	cardMeta = data

func set_buttons(_card, buttons):
	var old_buttons = $Buttons.get_children()
	for i in range(old_buttons.size()):
		$Buttons.remove_child(old_buttons[i])
		
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("RichTextLabel").text = buttons[i].Label
		new_button.position.y = (BUTTON_HEIGHT * i)
		new_button.z_index = self.z_index - i

func toHand():
	transitZone.move_to("hand", cardMeta, null)

func toStage():
	transitZone.move_to("stage", cardMeta, null)

func toDiscard():
	transitZone.move_to("discard", cardMeta, null)
	
func toCardPool():
	transitZone.move_to("cardpool", cardMeta, null)
	
func toRemoved():
	transitZone.move_to("removed", cardMeta, null)
	
func toMomentum():
	transitZone.move_to("momentum", cardMeta, null)
	
func flip():
	$AnimationPlayer.play("Flip")
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Flip"):
			buttons[i].button_type = "Unflip"
			buttons[i].get_node("Image/Text").text = "Unflip"
	
func unflip():
	$AnimationPlayer.play("Unflip")
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Unflip"):
			buttons[i].button_type = "Flip"
			buttons[i].get_node("Image/Text").text = "Flip"
	
func toTopDeck():
	transitZone.move_to("top deck", cardMeta, false)
	
func toBottomDeck():
	transitZone.move_to("bottom deck", cardMeta, false)

func call_fun(buttonType):
	match buttonType:
		"To Hand":
			toHand()
		"To Stage":
			toStage()
		"To Discard":
			toDiscard()
		"To Card Pool":
			toCardPool()
		"To Removed":
			toRemoved()
		"To Momentum":
			toMomentum()
		"Flip":
			flip()
		"Unflip":
			unflip()
		"To Top Deck":
			toTopDeck()
		"To Bottom Deck":
			toBottomDeck()
