extends Node2D

const CARD_WIDTH = 70
const STAGE_MAX_WIDTH = 1300

const CH_POS_X = 1826
const CH_POS_Y = 412

const STAGE_POS_START_X = 1636
const STAGE_POS_START_Y = 212

var starting_character

var stage = []

var animationMan

const characterActions = [{"Action": "Select Card", "Label": "Select"}]
const stageActions = [{"Action": "Select Card", "Label": "Select"}]

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

func get_card_by_indexID(ID):
	for i in range(stage.size()):
		if stage[i].indexID == ID:
			return stage[i]

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
			
	var cardWidth
	if CARD_WIDTH * stage.size() > STAGE_MAX_WIDTH:
		cardWidth = float(STAGE_MAX_WIDTH) / float(stage.size())
	else:
		cardWidth = CARD_WIDTH
	for i in range(readyCards.size()):
		animationMan.animate_card_to_pos(readyCards[i].cardObj, Vector2(STAGE_POS_START_X - (cardWidth * i), STAGE_POS_START_Y))
		readyCards[i].cardObj.z_index = 200 + i
	
	for i in range(committed.size()):
		animationMan.animate_card_to_pos(committed[i].cardObj, Vector2(STAGE_POS_START_X - (cardWidth * (i + readyCards.size())), STAGE_POS_START_Y))
		committed[i].cardObj.z_index = 200 + (i + readyCards.size())
