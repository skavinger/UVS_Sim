extends Node2D

const CARD_WIDTH = 70

const CH_POS_X = 100
const CH_POS_Y = 650

const STAGE_POS_START_X = 260
const STAGE_POS_START_Y = 835

var starting_character

var stage = []

var animationMan

const characterActions = []
const stageActions = [
{"Action": "Commit", "Label": "Commit"}, 
{"Action": "To Hand", "Label": "Add to Hand"}, 
{"Action": "To Card Pool", "Label": "Add To Cardpool"}, 
{"Action": "To Discard", "Label": "Sacrifice"}, 
{"Action": "To Removed", "Label": "Remove"}, 
{"Action": "To Momentum", "Label": "Add to Momentum"}, 
{"Action": "To Top Deck", "Label": "To Top Deck"},
{"Action": "To Bottom Deck", "Label": "To Bottom Deck"}]

func _ready() -> void:
	animationMan = $"../AnimationManager"

func add_character_to_stage(character):
	starting_character = character
	animationMan.animate_card_to_pos(starting_character.cardObj, Vector2(CH_POS_X, CH_POS_Y))
	starting_character.cardObj.set_buttons(starting_character, characterActions.duplicate(true))

func build_card(card):
	stage.append(card)
	update_pos()
	card.cardObj.set_buttons(card, stageActions.duplicate(true))

func eraseCard(card):
	stage.erase(card)
	update_pos()

func update_pos():
	var ready = []
	var committed = []
	for i in range(stage.size()):
		if(stage[i].cardState.committed):
			committed.append(stage[i])
		else:
			ready.append(stage[i])
			
	for i in range(ready.size()):
		animationMan.animate_card_to_pos(ready[i].cardObj, Vector2(STAGE_POS_START_X + (CARD_WIDTH * i), STAGE_POS_START_Y))
		ready[i].cardObj.z_index = 200 + i
	
	for i in range(committed.size()):
		animationMan.animate_card_to_pos(committed[i].cardObj, Vector2(STAGE_POS_START_X + (CARD_WIDTH * (i + ready.size())), STAGE_POS_START_Y))
		committed[i].cardObj.z_index = 200 + (i + ready.size())
