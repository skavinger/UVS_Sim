extends Node2D

const objType = "rival_deck"

var decklist
var deck = []

const BUTTON_PATH = "res://GameObj/button.tscn"
const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -28

var transitZone
var cardMan

var cardState = {
	"faceup": false,
	"currentZone": "deck",
	"committed": false
}

var rivalDeckList

const buttons = []

const searchBoxButtons = []

@rpc("any_peer")
func setUpRivalDeck(rivalDecklist):
	transitZone = $"../RivalTransit"
	cardMan = $"../RivalCardManager"
	#load decklist from deck
	decklist = rivalDecklist
	var cardCount = 0
	for i in range(decklist.main.size()):
		for j in decklist.main[i].count:
			deck.append({
				"cardID": decklist.main[i].cardID,
				"indexID": cardCount,
				"cardProperties": CardDatabase.getCard(decklist.main[i].cardID),
				"cardState": cardState.duplicate(),
				"cardObj": null
			})
			cardCount = cardCount + 1
	
	#init deck buttons
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("Control/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 100 - i

func get_card_by_indexID(ID):
	for i in range(deck.size()):
		if deck[i].indexID == ID:
			return deck[i]

func deck_selected():
	$Buttons.visible = true
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = false
	
func deck_unselected():
	$Buttons.visible = false
	var buttonList = $Buttons.get_children()
	for i in range(buttonList.size()):
		buttonList[i].get_node("Area2D/CollisionShape2D").disabled = true

func add_card_to_top(card):
	deck.insert(0, card)
	cardMan.despwan_card(card.cardObj)
	card.cardObj = null
	
func add_card_to_bottom(card):
	deck.append(card)
	cardMan.despwan_card(card.cardObj)
	card.cardObj = null

func eraseCard(card):
	deck.erase(card)
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
		
func call_fun(buttonType):
	match buttonType:
		"Search":
			transitZone.cardSearch.displaySearchBox(deck, "Deck", searchBoxButtons)
