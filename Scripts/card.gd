extends Node2D

signal hovered
signal hovered_off

const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -28

const objType = "card"

const BUTTON_PATH = "res://GameObj/button.tscn"
const SIDE_BUTTON_PATH = "res://GameObj/SideButtons.tscn"

var transitZone
var cardMan

var cardMeta

func _ready() -> void:
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
		
	old_buttons = $SideButtons.get_children()
	for i in range(old_buttons.size()):
		$SideButtons.remove_child(old_buttons[i])
	
	if(!card.cardState.faceup):
		for i in range(buttons.size()):
			if buttons[i].Action == "Flip":
				buttons[i] = {"Action": "Unflip", "Label": "Unflip"}
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		new_button.get_node("Control/Text").text = buttons[i].Label
		$Buttons.add_child(new_button)
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = self.z_index - i
		
		new_button = preload(SIDE_BUTTON_PATH).instantiate()
		if(buttons[i].Action == "Commit"):
			new_button.button_type = "Ready"
			new_button.get_node("Control/Text").text = "Ready"
		else:
			new_button.button_type = buttons[i].Action
			new_button.get_node("Control/Text").text = buttons[i].Label
		$SideButtons.add_child(new_button)
		new_button.position.x = (BUTTON_HEIGHT * i)
		new_button.z_index = self.z_index - i

func playCard():
	transitZone.move_to("cardpool", cardMeta, true)
	transitZone.deckZone.check()

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
	cardMeta.cardState.faceup = false
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Flip"):
			buttons[i].button_type = "Unflip"
			buttons[i].get_node("Control/Text").text = "Unflip"
	buttons = $SideButtons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Flip"):
			buttons[i].button_type = "Unflip"
			buttons[i].get_node("Control/Text").text = "Unflip"
	$"../../../Rival/RivalCardManager".rpc("flipCard", cardMeta)
	
func unflip():
	$AnimationPlayer.play("Unflip")
	cardMeta.cardState.faceup = true
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Unflip"):
			buttons[i].button_type = "Flip"
			buttons[i].get_node("Control/Text").text = "Flip"
	buttons = $SideButtons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Unflip"):
			buttons[i].button_type = "Flip"
			buttons[i].get_node("Control/Text").text = "Flip"
	$"../../../Rival/RivalCardManager".rpc("unflipCard", cardMeta)
	
func toTopDeck():
	transitZone.move_to("top deck", cardMeta, false)
	
func toBottomDeck():
	transitZone.move_to("bottom deck", cardMeta, false)
	
func commit():
	cardMeta.cardState.committed = true
	self.rotation = PI/2
	cardMan.card_unselected()
	transitZone.stageZone.update_pos()
	$"../../../Rival/RivalCardManager".rpc("commitCard", cardMeta)
	
func ready():
	cardMeta.cardState.committed = false
	self.rotation = 0
	cardMan.card_unselected()
	transitZone.stageZone.update_pos()
	$"../../../Rival/RivalCardManager".rpc("readyCard", cardMeta)

func call_fun(buttonType):
	match buttonType:
		"Play Card":
			playCard()
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
		"Play Ability":
			$"../../../Field/EffectsWindow".displayWindow()
			$"../../../Field/EffectsWindow".populateWindow(cardMeta)

func cardFlash():
	$"../../../Rival/RivalCardManager".rpc("flashRivalCard", cardMeta.indexID)
	$SelectAnimation.visible = true
	$AnimationPlayer.play("CardSelected")
