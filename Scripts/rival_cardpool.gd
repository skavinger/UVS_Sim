extends Node2D

const CARD_WIDTH = 70
const CARDPOOL_MAX_WIDTH = 1300

const CARDPOOL_POS_X = 1636
const CARDPOOL_POS_Y = 435

var starting_character

var cardpool = []

const cardpoolActions = []

var animationMan

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

func get_card_by_indexID(ID):
	for i in range(cardpool.size()):
		if cardpool[i].indexID == ID:
			return cardpool[i]

func add_to_card_pool(card):
	cardpool.append(card)
	update_pos()
	card.cardObj.set_buttons(card, cardpoolActions.duplicate(true))

func eraseCard(card):
	cardpool.erase(card)
	update_pos()

func update_pos():
	var cardWidth
	if CARD_WIDTH * cardpool.size() > CARDPOOL_MAX_WIDTH:
		cardWidth = float(CARDPOOL_MAX_WIDTH) / float(cardpool.size())
	else:
		cardWidth = CARD_WIDTH
	for i in range(cardpool.size()):
		animationMan.animate_card_to_pos(cardpool[i].cardObj, Vector2(CARDPOOL_POS_X - (cardWidth * i), CARDPOOL_POS_Y))
		cardpool[i].cardObj.z_index = 100 + i
