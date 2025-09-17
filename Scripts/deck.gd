extends Node2D

var deck = {
	"character": "CHA03-GMM_01", 
	"main": ["CHA03-GMM_13", "CHA03-GMM_13", "CHA03-GMM_13", "CHA03-GMM_13", "CHA03-GMM_14",
"CHA03-GMM_14", "CHA03-GMM_15", "CHA03-GMM_15", "CHA03-GMM_15", "CHA03-GMM_15", "CHA03-GMM_16",
 "CHA03-GMM_16", "CHA03-GMM_16", "CHA03-GMM_16", "CHA03-GMM_17", "CHA03-GMM_17", "CHA03-GMM_17",
 "CHA03-GMM_17", "CHA03-GMM_18", "CHA03-GMM_18", "CHA03-GMM_19", "CHA03-GMM_19", "CHA03-GMM_19",
 "CHA03-GMM_20","CHA03-GMM_20","CHA03-GMM_20","CHA03-GMM_20","CHA03-GMM_21","CHA03-GMM_21",
"CHA03-GMM_21","CHA03-GMM_21","CHA03-GMM_22","CHA03-GMM_22","CHA03-GMM_22","CHA03-GMM_22",
"CHA03-GMM_06","CHA03-GMM_06","CHA03-GMM_06","CHA03-GMM_07","CHA03-GMM_07","CHA03-GMM_08",
"CHA03-GMM_08","CHA03-GMM_08","CHA03-GMM_08","CHA03-GMM_09","CHA03-GMM_09","CHA03-GMM_10",
"CHA03-GMM_10","CHA03-GMM_10","CHA03-GMM_10","CHA03-GMM_11","CHA03-GMM_11","CHA03-GMM_11",
"CHA03-GMM_12","CHA03-GMM_12","CHA03-GMM_12","CHA03-GMM_04","CHA03-GMM_04","CHA03-GMM_05",
"CHA03-GMM_05",],
	"side": []
}

const CARD_SCENE_PATH = "res://GameObj/Card.tscn"
const BUTTON_PATH = "res://GameObj/button.tscn"
const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -16

var objType = "deck"

var zoneMan
var cardMan
var card_database

var buttons = ["Draw 1"]

func _ready() -> void:
	card_database = preload("res://Scripts/card_database.gd")
	deck.main.shuffle()
	zoneMan = $"../ZoneManager"
	cardMan = $"../CardManager"
	
	#init character
	var new_card = preload(CARD_SCENE_PATH).instantiate()
	cardMan.add_child(new_card)
	new_card.get_node("CardFront").texture = load("res://Assets/Sets/Precons/Godzilla, King of the Monsters/" + deck.character + ".jpg")
	new_card.name = deck.character
	zoneMan.stageZone.add_character_to_stage(new_card)
	new_card.get_node("AnimationPlayer").play("Card_Flip")
	
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
	var card_drawn = deck.main[0]
	deck.main.erase(card_drawn)
	
	if deck.main.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var new_card = preload(CARD_SCENE_PATH).instantiate()
	cardMan.add_child(new_card)
	new_card.get_node("CardFront").texture = load("res://Assets/Sets/Precons/Godzilla, King of the Monsters/" + card_drawn+ ".jpg")
	new_card.cardName = card_drawn
	zoneMan.handZone.add_card_to_hand(new_card)
	new_card.get_node("AnimationPlayer").play("Card_Flip")
	
func call_fun(buttonName):
	match buttonName:
		"Draw 1":
			draw_card()
