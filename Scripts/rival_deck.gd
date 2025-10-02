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
var card_database

var cardState = {
	"faceup": false,
	"currentZone": "deck",
	"committed": false
}

const buttons = []

const searchBoxButtons = []

func _ready() -> void:
	transitZone = $"../RivalTransit"
	cardMan = $"../RivalCardManager"
	#load decklist from deck
	card_database = preload("res://Scripts/card_database.gd")
	decklist = {
		"character": {
			"cardID" : {
				"set" : "CHA03-GMM",
				"number" : "01"
			}
		}, 
		"main": [
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "13"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "14"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "15"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "16"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "17"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "18"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "19"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "20"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "21"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "22"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "06"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "07"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "08"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "09"
				}
			},
			{
				"count" : 4,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "10"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "11"
				}
			},
			{
				"count" : 3,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "12"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "04"
				}
			},
			{
				"count" : 2,
				"cardID" : {
					"set" : "CHA03-GMM",
					"number" : "05"
				}
			}
		],
		"side": []
	}
	var cardCount = 0
	for i in range(decklist.main.size()):
		for j in decklist.main[i].count:
			deck.append({
				"cardID": decklist.main[i].cardID,
				"indexID": cardCount,
				"cardProperties": card_database.CARDS[decklist.main[i].cardID.set][decklist.main[i].cardID.number],
				"cardState": cardState.duplicate(),
				"cardObj": null
			})
			cardCount = cardCount + 1
	deck.shuffle()
	
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
