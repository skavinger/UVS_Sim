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
var cardSearch

func _ready() -> void:
	cardMan = $"../RivalCardManager"
	animationMan = $"../../Field/AnimationManager"
	
	deckZone =$"../RivalDeck"
	handZone = $"../RivalHand"
	cardpoolZone = $"../RivalCardpool"
	stageZone = $"../RivalStage"
	discardZone = $"../RivalDiscard"
	removedZone = $"../RivalRemoved"
	momentumZone = $"../RivalMomentum"
	cardSearch = $"../../Field/SearchBox"

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
				cardSearch.dectectChange(deckZone.deck, "Deck", deckZone.searchBoxButtons)
		"hand":
			handZone.eraseCard(card)
			cardSearch.dectectChange(handZone.hand, "Hand", handZone.handActions)
		"cardpool":
			cardpoolZone.eraseCard(card)
			cardSearch.dectectChange(cardpoolZone.cardpool, "Card Pool", cardpoolZone.cardpoolActions)
		"discard":
			discardZone.eraseCard(card)
			cardSearch.dectectChange(discardZone.discard, "Discard", discardZone.searchBoxButtons)
		"stage":
			card.cardObj.rotation = PI
			stageZone.eraseCard(card)
			cardSearch.dectectChange(stageZone.stage, "Stage", stageZone.stageActions)
		"momentum":
			card.cardObj.rotation = PI
			momentumZone.eraseCard(card)
			cardSearch.dectectChange(momentumZone.momentum, "Momentum", momentumZone.momentumActions)
		"removed":
			removedZone.eraseCard(card)
			cardSearch.dectectChange(removedZone.removed, "Removed", removedZone.searchBoxButtons)
	
	if(card.cardState.currentZone == "cardpool" or 
	card.cardState.currentZone == "stage" or 
	card.cardState.currentZone == "momentum" or 
	card.cardState.currentZone == "hand"):
		cardMan.card_unselected()
	
	card.cardState.currentZone = destinationZone
	
	match destinationZone:
		"character":
			stageZone.add_character_to_stage(card)
			card.cardObj.get_node("AnimationPlayer").play("Unflip")
		"top deck":
			check_flip(card, false)
			deckZone.add_card_to_top(card)
			cardSearch.dectectChange(deckZone.deck, "Deck", deckZone.searchBoxButtons)
		"bottom deck":
			check_flip(card, false)
			deckZone.add_card_to_bottom(card)
			cardSearch.dectectChange(deckZone.deck, "Deck", deckZone.searchBoxButtons)
		"hand":
			check_flip(card, faceup)
			handZone.add_card_to_hand(card)
			cardSearch.dectectChange(handZone.hand, "Hand", handZone.handActions)
		"cardpool":
			check_flip(card, faceup)
			cardpoolZone.add_to_card_pool(card)
			cardSearch.dectectChange(cardpoolZone.cardpool, "Card Pool", cardpoolZone.cardpoolActions)
		"discard":
			check_flip(card, false)
			discardZone.add_to_discard(card)
			cardSearch.dectectChange(discardZone.discard, "Discard", discardZone.searchBoxButtons)
		"stage":
			check_flip(card, faceup)
			stageZone.build_card(card)
			cardSearch.dectectChange(stageZone.stage, "Stage", stageZone.stageActions)
		"momentum":
			check_flip(card, faceup)
			momentumZone.add_to_momentum(card)
			cardSearch.dectectChange(momentumZone.momentum, "Momentum", momentumZone.momentumActions)
		"removed":
			check_flip(card, false)
			removedZone.add_to_removed(card)
			cardSearch.dectectChange(removedZone.removed, "Removed", removedZone.searchBoxButtons)
			
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
