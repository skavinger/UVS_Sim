extends Node2D

signal hovered
signal hovered_off

const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -28

const objType = "rival_card"

const BUTTON_PATH = "res://GameObj/button.tscn"
const SIDE_BUTTON_PATH = "res://GameObj/SideButtons.tscn"

var transitZone
var cardMan

var cardMeta

func _ready() -> void:
	transitZone = $"../../RivalTransit"
	cardMan = $"../../RivalCardManager"

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func setMeta(card):
	cardMeta = card

func set_buttons(_card, buttons):
	var old_buttons = $Buttons.get_children()
	for i in range(old_buttons.size()):
		$Buttons.remove_child(old_buttons[i])
		
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
	cardMeta.cardState.faceup = false
	var buttons = $Buttons.get_children()
	for i in range(buttons.size()):
		if(buttons[i].button_type == "Flip"):
			buttons[i].button_type = "Unflip"
			buttons[i].get_node("Control/Text").text = "Unflip"
	
func unflip():
	$AnimationPlayer.play("Unflip")
	cardMeta.cardState.faceup = true
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
	self.rotation = PI + PI/2
	cardMan.card_unselected()
	transitZone.stageZone.update_pos()
	
func ready():
	cardMeta.cardState.committed = false
	self.rotation = PI
	cardMan.card_unselected()
	transitZone.stageZone.update_pos()

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
		"Select Card":
			cardFlash()

func cardFlash():
	$SelectAnimation.visible = true
	$AnimationPlayer.play("CardSelected")
	$"../../../Player/CardManager".rpc("flashRivalCard", cardMeta.indexID)
	var publicMessage = "Selected face down card in " + cardMeta.cardState.currentZone
	var privateMessage = "Selected " + cardMeta.cardProperties.Name + " in " + cardMeta.cardState.currentZone
	if cardMeta.cardState.faceup:
		publicMessage = privateMessage
	$"../../../Field/Chat".addGameEventToLog(privateMessage,publicMessage)
