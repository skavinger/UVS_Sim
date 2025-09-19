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
var animationMan
var card_database

var buttons = ["Draw 1", "Build Top", "Add Top to Card Pool", "Mill 1"]

func _ready() -> void:
	transitZone = $"../Transit"
	cardMan = $"../CardManager"
	animationMan = $"../AnimationManager"
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
				"cardObj": null
			})
	deck.shuffle()
	#init character
	transitZone.move_to("character", {
				"cardID": decklist.character.cardID,
				"cardProperties": card_database.CARDS[decklist.character.cardID.set][decklist.character.cardID.number],
				"cardObj": null
			})
	
	#init deck buttons
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i]
		$Buttons.add_child(new_button)
		new_button.get_node("Image/Text").text = buttons[i]
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
		new_button.z_index = 100 - i
	
func deck_selected():
	$Buttons.visible = true
	
func deck_unselected():
	$Buttons.visible = false

func draw_card(count):
	for i in count:
		var card_drawn = deck[0]
		deck.erase(card_drawn)
		
		if deck.size() == 0:
			$Area2D/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
		transitZone.move_to("hand", card_drawn)
	
func buildTop():
	var topCard = deck[0]
	deck.erase(topCard)
	transitZone.move_to("stage", topCard)
	
func toCardPool():
	var topCard = deck[0]
	deck.erase(topCard)
	transitZone.move_to("cardpool", topCard)
	
func mill(count):
	for i in count:
		var topCard = deck[0]
		deck.erase(topCard)
		transitZone.move_to("discard", topCard)
		
	
func call_fun(buttonName):
	match buttonName:
		"Draw 1":
			draw_card(1)
		"Build Top":
			buildTop()
		"Add Top to Card Pool":
			toCardPool()
		"Mill 1":
			mill(1)
