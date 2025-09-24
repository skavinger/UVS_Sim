extends Node2D

var cardMan
var animationMan

var deckZone
var handZone
var cardpoolZone
var stageZone
var discardZone
var removedZone
var momentumZone

func _ready() -> void:
	cardMan = $"../CardManager"
	animationMan = $"../AnimationManager"
	
	deckZone = $"../Deck"
	handZone = $"../Hand"
	cardpoolZone = $"../Cardpool"
	stageZone = $"../Stage"
	discardZone = $"../Discard"
	removedZone = $"../Removed"
	momentumZone = $"../Momentum"

func move_to(destinationZone, card, faceup):
	#if card obj hasn't been spawned yet spawn it
	if card.cardObj == null:
		card.cardObj = cardMan.spawn_card(card)
	
	match card.cardState.currentZone:
		"character":
			pass
		"deck":
			if(destinationZone != "character"):
				deckZone.eraseCard(card)
		"hand":
			handZone.eraseCard(card)
		"cardpool":
			cardpoolZone.eraseCard(card)
		"discard":
			discardZone.eraseCard(card)
		"stage":
			stageZone.eraseCard(card)
		"momentum":
			card.cardObj.rotation = 0
			momentumZone.eraseCard(card)
		"removed":
			removedZone.eraseCard(card)
	
	if(card.cardState.currentZone == "cardpool" or 
	card.cardState.currentZone == "stage" or 
	card.cardState.currentZone == "momentum" ):
		cardMan.card_unselected()
	
	card.cardState.currentZone = destinationZone
	
	match destinationZone:
		"character":
			stageZone.add_character_to_stage(card)
			card.cardObj.get_node("AnimationPlayer").play("Unflip")
		"top deck":
			check_flip(card, false)
			deckZone.add_card_to_top(card)
		"bottom deck":
			check_flip(card, false)
			deckZone.add_card_to_bottom(card)
		"hand":
			check_flip(card, faceup)
			handZone.add_card_to_hand(card)
		"cardpool":
			check_flip(card, faceup)
			cardpoolZone.add_to_card_pool(card)
		"discard":
			check_flip(card, false)
			discardZone.add_to_discard(card)
		"stage":
			check_flip(card, faceup)
			stageZone.build_card(card)
		"momentum":
			check_flip(card, faceup)
			momentumZone.add_to_momentum(card)
		"removed":
			check_flip(card, false)
			removedZone.add_to_removed(card)
			
func check_flip(card, faceup):
	if(!faceup and card.cardState.faceup):
		card.cardObj.get_node("AnimationPlayer").play("Flip")
		card.cardState.faceup = false
	elif(faceup and !card.cardState.faceup):
		card.cardObj.get_node("AnimationPlayer").play("Unflip")
		card.cardState.faceup = true
	elif(!faceup and !card.cardState.faceup):
		card.cardObj.get_node("AnimationPlayer").play("FD_to_FD")
	elif(faceup and card.cardState.faceup):
		card.cardObj.get_node("AnimationPlayer").play("FU_to_FU")
