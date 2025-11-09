extends Node2D

const CARD_WIDTH = 70
const HAND_X_POS = 900
const HAND_Y_POS = 52
const HAND_MAX_WIDTH = 800

var hand = []

const handActions = []

var animationMan

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

func get_card_by_indexID(ID):
	for i in range(hand.size()):
		if hand[i].indexID == ID:
			return hand[i]

func add_card_to_hand(card):
	hand.insert(0, card)
	hand.shuffle()
	update_pos()
	card.cardObj.set_buttons(card, handActions.duplicate(true))
	
func eraseCard(card):
	hand.erase(card)
	update_pos()
	
func update_pos():
	#Move cards to center
	for i in range(hand.size()):
		animationMan.animate_card_to_pos(hand[i].cardObj, Vector2(calc_card_pos(i), HAND_Y_POS))
	#Move cards to new position
	for i in range(hand.size()):
		hand[i].cardObj.z_index = 400 + i
		animationMan.animate_card_to_pos(hand[i].cardObj, Vector2(calc_card_pos(i), HAND_Y_POS))
		
func calc_card_pos(index):
	var cardWidth
	if CARD_WIDTH * hand.size() > HAND_MAX_WIDTH:
		cardWidth = float(HAND_MAX_WIDTH) / float(hand.size())
	else:
		cardWidth = CARD_WIDTH
	var total_width = (hand.size() - 1) * cardWidth
	var x_offset = HAND_X_POS + index * cardWidth - total_width / 2
	return x_offset
