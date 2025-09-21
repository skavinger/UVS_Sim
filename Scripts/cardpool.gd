extends Node2D

const CARD_WIDTH = 70

const STAGE_POS_CARDPOOL_X = 300
const STAGE_POS_CARDPOOL_Y = 670

var starting_character

var cardpool = []

var cardpoolActions = ["Build", "Clear", "Remove", "Add to Momentum", "To Deck"]

var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func add_to_card_pool(card):
	cardpool.append(card)
	update_pos()
	card.cardObj.set_buttons(card, cardpoolActions)

func eraseCard(card):
	cardpool.erase(card)
	update_pos()

func update_pos():
	for i in range(cardpool.size()):
		animationMan.animate_card_to_pos(cardpool[i].cardObj, Vector2(STAGE_POS_CARDPOOL_X + (CARD_WIDTH * i), STAGE_POS_CARDPOOL_Y))
		cardpool[i].cardObj.z_index = 200 + i
