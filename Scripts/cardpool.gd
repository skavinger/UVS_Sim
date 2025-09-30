extends Node2D

const CARD_WIDTH = 70

const CARDPOOL_POS_CARDPOOL_X = 270
const CARDPOOL_POS_CARDPOOL_Y = 640

var starting_character

var cardpool = []

const cardpoolActions = [
{"Action": "To Hand", "Label": "Add to Hand"}, 
{"Action": "To Stage", "Label": "Build"}, 
{"Action": "To Discard", "Label": "Clear"}, 
{"Action": "To Removed", "Label": "Remove"}, 
{"Action": "To Momentum", "Label": "Add to Momentum"}, 
{"Action": "To Top Deck", "Label": "To Top Deck"},
{"Action": "To Bottom Deck", "Label": "To Bottom Deck"}]

var animationMan

func _ready() -> void:
	animationMan = $"../../AnimationManager"

func add_to_card_pool(card):
	cardpool.append(card)
	update_pos()
	card.cardObj.set_buttons(card, cardpoolActions.duplicate(true))

func eraseCard(card):
	cardpool.erase(card)
	update_pos()

func update_pos():
	for i in range(cardpool.size()):
		animationMan.animate_card_to_pos(cardpool[i].cardObj, Vector2(CARDPOOL_POS_CARDPOOL_X + (CARD_WIDTH * i), CARDPOOL_POS_CARDPOOL_Y))
		cardpool[i].cardObj.z_index = 100 + i
