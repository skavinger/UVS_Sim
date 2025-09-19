extends Node2D

const CARD_WIDTH = 70

const STAGE_POS_CARDPOOL_X = 290
const STAGE_POS_CARDPOOL_Y = 670

var starting_character

var cardpool = []

var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func add_to_card_pool(card):
	cardpool.append(card)
	update_pos()
	card.cardObj.get_node("AnimationPlayer").play("Card_Flip")
	card.cardObj.scale = Vector2(0.6,0.6)
	
func update_pos():
	for i in range(cardpool.size()):
		animationMan.animate_card_to_pos(cardpool[i].cardObj, Vector2(STAGE_POS_CARDPOOL_X + (CARD_WIDTH * i), STAGE_POS_CARDPOOL_Y))
		cardpool[i].cardObj.z_index = 200 + i
