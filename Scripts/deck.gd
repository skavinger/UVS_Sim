extends Node2D

const objType = "deck"

var decklist
var deck = []

const BUTTON_PATH = "res://GameObj/button.tscn"
const BUTTON_POS_X = 0
const BUTTON_OFFSET = -80
const BUTTON_HEIGHT = -28

var transitZone
var cardMan

var defaultCardState = {
	"faceup": false,
	"currentZone": "deck",
	"committed": false,
	"maxHealth": null,
	"frozen": false
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

func setUpPlayerDeck() -> void:
	transitZone = $"../Transit"
	cardMan = $"../CardManager"
	#load decklist from deck
	decklist = $"../../../../..".currentDeckList
	var cardCount = 0
	for i in range(decklist.main.size()):
		for j in decklist.main[i].count:
			deck.append({
				"cardID": decklist.main[i].cardID,
				"indexID": cardCount,
				"cardProperties": CardDatabase.getCard(decklist.main[i].cardID),
				"cardState": defaultCardState.duplicate(),
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
	$"../../Rival/RivalDeck".rpc("setUpRivalDeck", decklist)

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
		transitZone.move_to("hand", card_drawn, true)

func eraseCard(card):
	deck.erase(card)
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false

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

func check():
	var topCard = deck[0]
	transitZone.move_to("discard", topCard, false)

func removeCount(count):
	for i in count:
		var topCard = deck[0]
		transitZone.move_to("removed", topCard, false)
		
func toMomentum():
	var topCard = deck[0]
	transitZone.move_to("momentum", topCard, false)
	

func drawToHandSize():
	var handSize = $"../Stage".starting_character.cardProperties.HandSize
	var cardsInHand = $"../Hand".hand.size()
	
	if(cardsInHand < handSize):
		draw_card(handSize - cardsInHand)

func call_fun(buttonType):
	match buttonType:
		"Make A Check":
			check()
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
