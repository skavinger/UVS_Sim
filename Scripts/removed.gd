extends Node2D

const objType = "removed"

const BUTTON_PATH = "res://GameObj/button.tscn"

const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

const buttons = [{"Action": "Search", "Label": "Search"}]

const searchBoxButtons = [{"Action": "To Hand", "Label": "Add to Hand"}, 
{"Action": "To Stage", "Label": "Build"}, 
{"Action": "To Card Pool", "Label": "To Card Pool"}, 
{"Action": "To Discard", "Label": "To Discard"}, 
{"Action": "To Momentum", "Label": "To Momentum"},
{"Action": "To Top Deck", "Label": "To Top Deck"},
{"Action": "To Bottom Deck", "Label": "To Bottom Deck"}]

var removed = []
var cardMan
var transitZone

func _ready() -> void:
	cardMan = $"../CardManager"
	transitZone = $"../Transit"
	
	#init deck buttons
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("Image/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 100 - i

func change_top():
	if(removed.size() > 0):
		self.get_node("Sprite2D").visible = true
		self.get_node("Sprite2D").texture = load("res://Assets/Sets/" + removed[0].cardID.set + "/" + removed[0].cardID.number + ".jpg")
	else:
		self.get_node("Sprite2D").visible = false

func add_to_removed(card):
	removed.insert(0, card)
	cardMan.despwan_card(removed[0].cardObj)
	removed[0].cardObj = null
	change_top()

func eraseCard(card):
	removed.erase(card)
	change_top()
	
func removed_selected():
	$Buttons.visible = true
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = false
	
func removed_unselected():
	$Buttons.visible = false
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = true

func call_fun(buttonType):
	match buttonType:
		"Search":
			transitZone.cardSearch.displaySearchBox(removed, "Removed", searchBoxButtons)
