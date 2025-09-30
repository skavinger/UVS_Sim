extends Node2D

const CARD_WIDTH = 70

const CH_POS_X = 1590
const CH_POS_Y = 180

const STAGE_POS_START_X = 1400
const STAGE_POS_START_Y = 0

var starting_character

var stage = []

var animationMan

const characterActions = []
const stageActions = []

func _ready() -> void:
	animationMan = $"../../AnimationManager"

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
	var readyCards = []
	var committed = []
	for i in range(stage.size()):
		if(stage[i].cardState.committed):
			committed.append(stage[i])
		else:
			readyCards.append(stage[i])
			
	for i in range(readyCards.size()):
		animationMan.animate_card_to_pos(readyCards[i].cardObj, Vector2(STAGE_POS_START_X - (CARD_WIDTH * i), STAGE_POS_START_Y))
		readyCards[i].cardObj.z_index = 200 + i
	
	for i in range(committed.size()):
		animationMan.animate_card_to_pos(committed[i].cardObj, Vector2(STAGE_POS_START_X - (CARD_WIDTH * (i + readyCards.size())), STAGE_POS_START_Y))
		committed[i].cardObj.z_index = 200 + (i + readyCards.size())
