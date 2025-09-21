extends Node2D

const CARD_WIDTH = 70
const HAND_Y_POS = 1100

var hand = []
var center_screen_x
var animationMan

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	animationMan = $"../AnimationManager"

func add_card_to_hand(card):
	hand.insert(0, card)
	hand.shuffle()
	update_pos()
	
func eraseCard(card):
	hand.erase(card)
	update_pos()
	
func update_pos():
	#Move cards to center
	for i in range(hand.size()):
		animationMan.animate_card_to_pos(hand[i].cardObj, Vector2(calc_card_pos(i), HAND_Y_POS))
	#wait for animation to finish before moving the cards again
	await get_tree().create_timer(0.2).timeout
	#Move cards to new position
	for i in range(hand.size()):
		hand[i].cardObj.z_index = 400 + i
		animationMan.animate_card_to_pos(hand[i].cardObj, Vector2(calc_card_pos(i), HAND_Y_POS))
		
func calc_card_pos(index):
	var total_width = (hand.size() - 1) * CARD_WIDTH
	@warning_ignore("integer_division")
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
