extends Node2D

const CARD_WIDTH = 70
const HAND_Y_POS = 1100

var hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card):
	hand.insert(0, card)
	hand.shuffle()
	update_pos()
	
func update_pos():
	#Move cards to center
	for i in range(hand.size()):
		animate_card_to_pos(hand[i], Vector2(calc_card_pos(i), HAND_Y_POS))
	#Move cards to new position
	for i in range(hand.size()):
		hand[i].z_index = 400 + i
		animate_card_to_pos(hand[i], Vector2(calc_card_pos(i), HAND_Y_POS))
		
func calc_card_pos(index):
	var total_width = (hand.size() - 1) * CARD_WIDTH
	@warning_ignore("integer_division")
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func animate_card_to_pos(card, pos):
	var tween = get_tree().create_tween()
	tween.tween_property(card,"position", pos, 0.2)
