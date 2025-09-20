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

func move_to(zone, card, faceup):
	#if card obj hasn't been spawned yet spawn it
	if card.cardObj == null:
		card.cardObj = cardMan.spawn_card(card)
		
	match zone:
		"character":
			stageZone.add_character_to_stage(card)
			card.cardObj.get_node("AnimationPlayer").play("Unflip")
		"top deck":
			pass
		"bottom deck":
			pass
		"hand":
			handZone.add_card_to_hand(card)
			card.cardState.faceup = true
			card.cardObj.get_node("AnimationPlayer").play("To_Hand")
		"cardpool":
			check_flip(card, faceup)
			cardpoolZone.add_to_card_pool(card)
		"discard":
			check_flip(card, faceup)
			discardZone.add_to_discard(card)
		"stage":
			check_flip(card, faceup)
			stageZone.build_card(card)
		"momentum":
			check_flip(card, faceup)
			momentumZone.add_to_momentum(card)
		"removed":
			check_flip(card, faceup)
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
