extends Node2D

const objType = "deck"

var decklist
var deck = []

const BUTTON_PATH = "res://GameObj/button.tscn"
const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

var transitZone
var cardMan
var card_database

var cardState = {
	"faceup": false,
	"currentZone": "deck",
	"committed": false
}

const buttons = [{"Action": "Draw 1", "Label": "Draw 1"}, 
{"Action": "Search", "Label": "Search"},
{"Action": "Shuffle", "Label": "Shuffle"}, 
{"Action": "Build Top", "Label": "Build Top"}, 
{"Action": "Add Top to Card Pool", "Label": "Top to Card Pool"}, 
{"Action": "Mill 1", "Label": "Mill 1"}, 
{"Action": "Remove Top", "Label": "Remove Top"}, 
{"Action": "Add Top to Momentum", "Label": "Top to Momentum"}]

const searchBoxButtons = [{"Action": "To Hand", "Label": "Add to Hand"}, 
{"Action": "To Stage", "Label": "Build"}, 
{"Action": "To Card Pool", "Label": "To Card Pool"}, 
{"Action": "To Discard", "Label": "Send to Discard"}, 
{"Action": "To Removed", "Label": "Remove"}, 
{"Action": "To Momentum", "Label": "To Momentum"}]

func _ready() -> void:
	transitZone = $"../Transit"
	cardMan = $"../CardManager"
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
	for i in range(decklist.main.size()):
		for j in decklist.main[i].count:
			deck.append({
				"cardID": decklist.main[i].cardID,
				"cardProperties": card_database.CARDS[decklist.main[i].cardID.set][decklist.main[i].cardID.number],
				"cardState": cardState.duplicate(),
				"cardObj": null
			})
	deck.shuffle()
	#init character
	transitZone.move_to("character", {
				"cardID": decklist.character.cardID,
				"cardProperties": card_database.CARDS[decklist.character.cardID.set][decklist.character.cardID.number],
				"cardState": cardState.duplicate(),
				"cardObj": null
			}, false)
	
	#init deck buttons
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i].Action
		$Buttons.add_child(new_button)
		new_button.get_node("Control/Text").text = buttons[i].Label
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 100 - i
	
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
	
func draw_card(count):
	for i in count:
		var card_drawn = deck[0]
		
		if deck.size() == 0:
			$Area2D/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
		transitZone.move_to("hand", card_drawn, true)

func eraseCard(card):
	deck.erase(card)

func buildTop():
	var topCard = deck[0]
	transitZone.move_to("stage", topCard, false)
	
func toCardPool():
	var topCard = deck[0]
	transitZone.move_to("cardpool", topCard, false)
	
func mill(count):
	for i in count:
		var topCard = deck[0]
		transitZone.move_to("discard", topCard, false)
		
func removeCount(count):
	for i in count:
		var topCard = deck[0]
		transitZone.move_to("removed", topCard, false)
		
func toMomentum():
	var topCard = deck[0]
	transitZone.move_to("momentum", topCard, false)
		
func call_fun(buttonType):
	match buttonType:
		"Draw 1":
			draw_card(1)
		"Search":
			transitZone.cardSearch.displaySearchBox(deck, "Deck", searchBoxButtons)
		"Build Top":
			buildTop()
		"Add Top to Card Pool":
			toCardPool()
		"Mill 1":
			mill(1)
		"Remove Top":
			removeCount(1)
		"Add Top to Momentum":
			toMomentum()
		"Shuffle":
			deck.shuffle()
			transitZone.cardSearch.dectectChange(deck, "Deck", searchBoxButtons)
