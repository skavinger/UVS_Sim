extends Node2D

var decklist
var deck = []

const BUTTON_PATH = "res://GameObj/button.tscn"
const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

var objType = "deck"

var zoneMan
var cardMan
var card_database

var buttons = ["Draw 1", "Build Top", "Add Top to Card Pool"]

func _ready() -> void:
	#load decklist from deck
	card_database = preload("res://Scripts/card_database.gd")
	decklist = preload("res://Scripts/decklist.gd")
	for i in range(decklist.decklist.main.size()):
		for j in decklist.decklist.main[i].count:
			deck.append({
				"cardID": decklist.decklist.main[i].cardID,
				"cardProperties": card_database.CARDS[decklist.decklist.main[i].cardID.set][decklist.decklist.main[i].cardID.number]
			})
	
	deck.shuffle()
	zoneMan = $"../ZoneManager"
	cardMan = $"../CardManager"
	
	#init character
	var character = cardMan.spawn_card(decklist.decklist.character)
	zoneMan.stageZone.add_character_to_stage(character)
	character.get_node("AnimationPlayer").play("Card_Flip")
	
	#init deck buttons
	for i in range(buttons.size()):
		var new_button = preload(BUTTON_PATH).instantiate()
		new_button.button_type = buttons[i]
		$Buttons.add_child(new_button)
		new_button.get_node("Image/Text").text = buttons[i]
		new_button.position.y = BUTTON_OFFSET + (BUTTON_HEIGHT * i)
	
func deck_selected():
	$Buttons.visible = true
	
func deck_unselected():
	$Buttons.visible = false

func draw_card():
	var card_drawn = deck[0]
	deck.erase(card_drawn)
	
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var new_card = cardMan.spawn_card(card_drawn)
	zoneMan.handZone.add_card_to_hand(new_card)
	new_card.get_node("AnimationPlayer").play("Card_Flip")
	
func buildTop():
	var topCard = deck[0]
	deck.erase(topCard)
	zoneMan.stageZone.build_card(cardMan.spawn_card(topCard))
	
func toCardPool():
	var topCard = deck[0]
	deck.erase(topCard)
	zoneMan.cardpoolZone.add_to_card_pool(cardMan.spawn_card(topCard))
	
func call_fun(buttonName):
	match buttonName:
		"Draw 1":
			draw_card()
		"Build Top":
			buildTop()
		"Add Top to Card Pool":
			toCardPool()
