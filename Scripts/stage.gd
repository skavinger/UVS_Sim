extends Node2D

const CARD_WIDTH = 70
const STAGE_MAX_WIDTH = 1300

const CH_POS_X = 100
const CH_POS_Y = 670

const STAGE_POS_START_X = 260
const STAGE_POS_START_Y = 855

var starting_character

var stage = []

var animationMan

const characterActions = [
	{"Action": "Commit", "Label": "Commit"},
	{"Action": "Play Ability", "Label": "Play Ability"},
	{"Action": "Add Counter", "Label": "Add Counter"},
	{"Action": "Remove Counter", "Label": "Remove Counter"}]
const stageActions = [
	{"Action": "Commit", "Label": "Commit"}, 
	{"Action": "Flip", "Label": "Flip"},
	{"Action": "Play Ability", "Label": "Play Ability"},
	{"Action": "To Hand", "Label": "Add to Hand"}, 
	{"Action": "To Card Pool", "Label": "Add To Cardpool"}, 
	{"Action": "To Discard", "Label": "Sacrifice"}, 
	{"Action": "To Removed", "Label": "Remove"}, 
	{"Action": "To Momentum", "Label": "Add to Momentum"}, 
	{"Action": "To Top Deck", "Label": "To Top Deck"},
	{"Action": "To Bottom Deck", "Label": "To Bottom Deck"},
	{"Action": "Add Counter", "Label": "Add Counter"},
	{"Action": "Remove Counter", "Label": "Remove Counter"}]

func _ready() -> void:
	animationMan = $"../../Field/AnimationManager"

func add_character_to_stage(character):
	starting_character = character
	animationMan.animate_card_to_pos(starting_character.cardObj, Vector2(CH_POS_X, CH_POS_Y))
	starting_character.cardObj.z_index = 200
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
		animationMan.animate_card_to_pos(readyCards[i].cardObj, Vector2(STAGE_POS_START_X + (cardWidth * i), STAGE_POS_START_Y))
		readyCards[i].cardObj.z_index = 200 + i
	
	for i in range(committed.size()):
		animationMan.animate_card_to_pos(committed[i].cardObj, Vector2(STAGE_POS_START_X + (cardWidth * (i + readyCards.size())), STAGE_POS_START_Y))
		committed[i].cardObj.z_index = 200 + (i + readyCards.size())

func readyStage():
	if !starting_character.cardState.frozen:
		starting_character.cardObj.ready()
	else:
		starting_character.cardState.frozen = false
	for i in range(stage.size()):
		if !stage[i].cardState.frozen:
			stage[i].cardObj.ready()
		else:
			stage[i].cardState.frozen = false
