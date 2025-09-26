extends Node2D

signal hovered
signal hovered_off

const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

const objType = "card"

const BUTTON_PATH = "res://GameObj/button.tscn"

var transitZone
var cardMan

var cardMeta

func _ready() -> void:
	get_parent().connect_card_signals(self)
	transitZone = $"../../Transit"
	cardMan = $"../../CardManager"

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func setMeta(card):
	cardMeta = card

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
		new_button.get_node("Control/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = self.z_index - i
		
func toHand():
	transitZone.move_to("hand", cardMeta, true)

func toStage():
	transitZone.move_to("stage", cardMeta, false)

func toDiscard():
	transitZone.move_to("discard", cardMeta, false)
	
func toCardPool():
	transitZone.move_to("cardpool", cardMeta, false)
	
func toRemoved():
	transitZone.move_to("removed", cardMeta, false)
	
func toMomentum():
	transitZone.move_to("momentum", cardMeta, false)
	
func flip():
	$AnimationPlayer.play("Flip")
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Flip"):
			buttons[i].button_type = "Unflip"
			buttons[i].get_node("Control/Text").text = "Unflip"
	
func unflip():
	$AnimationPlayer.play("Unflip")
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Unflip"):
			buttons[i].button_type = "Flip"
			buttons[i].get_node("Control/Text").text = "Flip"
	
func toTopDeck():
	transitZone.move_to("top deck", cardMeta, false)
	
func toBottomDeck():
	transitZone.move_to("bottom deck", cardMeta, false)
	
func commit():
	cardMeta.cardState.committed = true
	self.rotation = PI/2
	var buttons = $Buttons.get_children()
	cardMan.card_unselected()
	transitZone.stageZone.update_pos()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Commit"):
			buttons[i].button_type = "Ready"
			buttons[i].get_node("Control/Text").text = "Ready"
	
func ready():
	cardMeta.cardState.committed = false
	self.rotation = 0
	cardMan.card_unselected()
	var buttons = $Buttons.get_children()
	transitZone.stageZone.update_pos()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Ready"):
			buttons[i].button_type = "Commit"
			buttons[i].get_node("Control/Text").text = "Commit"

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
		"Commit":
			commit()
		"Ready":
			ready()
