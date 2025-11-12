extends Node2D

const objType = "rival_discard"

const BUTTON_PATH = "res://GameObj/CardObjs/button.tscn"

const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

var discard = []

const buttons = [{"Action": "Search", "Label": "Search"}]

const searchBoxButtons = [{"Action": "Select Card", "Label": "Select"}]

var transitZone
var cardMan

func _ready() -> void:
	cardMan = $"../RivalCardManager"
	transitZone = $"../RivalTransit"
	
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("Control/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 100 - i

func get_card_by_indexID(ID):
	for i in range(discard.size()):
		if discard[i].indexID == ID:
			return discard[i]

func change_top():
	if(discard.size() > 0):
		self.get_node("Sprite2D").visible = true
		self.get_node("Sprite2D").texture = CardDatabase.get_card_art(discard[0].cardID)
	else:
		self.get_node("Sprite2D").visible = false

func add_to_discard(card):
	discard.insert(0, card)
	cardMan.despwan_card(discard[0].cardObj)
	discard[0].cardObj = null
	change_top()

func eraseCard(card):
	discard.erase(card)
	change_top()

func discard_selected():
	$Buttons.visible = true
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = false
	
func discard_unselected():
	$Buttons.visible = false
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = true

func call_fun(buttonType):
	match buttonType:
		"Search":
			transitZone.cardSearch.displaySearchBox(discard, "Discard", searchBoxButtons)
