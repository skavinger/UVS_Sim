extends Node2D

var cardMan
var animationMan
var chat

var deckZone
var handZone
var cardpoolZone
var stageZone
var discardZone
var removedZone
var momentumZone
var cardSearch

func _ready() -> void:
	cardMan = $"../CardManager"
	animationMan = $"../../Field/AnimationManager"
	chat = $"../../Field/Chat"
	
	deckZone = $"../Deck"
	handZone = $"../Hand"
	cardpoolZone = $"../Cardpool"
	stageZone = $"../Stage"
	discardZone = $"../Discard"
	removedZone = $"../Removed"
	momentumZone = $"../Momentum"
	cardSearch = $"../../Field/SearchBox"

func move_to(destinationZone, card, faceUpOverride):
	var faceup = faceUpOverride
	var publicMessage
	var privateMessage
	var private = false
	#if card obj hasn't been spawned yet spawn it
	if faceUpOverride == null:
		match card.cardState.currentZone:
			"character":
				pass
			"deck":
				match destinationZone:
					"hand":
						faceup = true
						private = true
						publicMessage = "Drew 1 card"
						privateMessage = "Drew " + card.cardProperties.Name
					"cardpool":
						faceup = false
						publicMessage = "Added to card of deck to card pool"
						privateMessage = "Added " + card.cardProperties.Name + " to card pool face down"
					"discard":
						faceup = true
						publicMessage = "Milled " + card.cardProperties.Name
						privateMessage = publicMessage
					"stage":
						faceup = false
						publicMessage = "Built the top card of deck"
						privateMessage = "Built " + card.cardProperties.Name + " face down from top of deck"
					"momentum":
						faceup = false
						publicMessage = "Added the top card of deck to momentum"
						privateMessage = "Added " + card.cardProperties.Name + " to momentum face down"
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from the top of deck"
						privateMessage = publicMessage
			"hand":
				match destinationZone:
					"deck":
						faceup = false
						publicMessage = "Added card from hand to top of deck"
						privateMessage = "Added " + card.cardProperties.Name + " from hand to top of deck"
					"cardpool":
						faceup = false
						publicMessage = "Added card from hand to card pool"
						privateMessage = "Added " + card.cardProperties.Name + " from hand to card pool face down"
					"discard":
						faceup = true
						publicMessage = "Discarded " + card.cardProperties.Name
						privateMessage = publicMessage
					"stage":
						faceup = false
						publicMessage = "Built card from hand"
						privateMessage = "Built " + card.cardProperties.Name + " face down"
					"momentum":
						faceup = false
						publicMessage = "Added card from hand to momentum"
						privateMessage = "Added " + card.cardProperties.Name + " to momentum face down"
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from hand"
						privateMessage = publicMessage
			"cardpool":
				match destinationZone:
					"deck":
						faceup = false
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from card pool to top of deck"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from card pool to top of deck"
							privateMessage = "Added " + card.cardProperties.Name + " from card pool to top of deck"
					"hand":
						faceup = true
						private = true
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from card pool to hand"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from card pool to hand"
							privateMessage = "Added " + card.cardProperties.Name + " from card pool to hand"
					"discard":
						faceup = true
						publicMessage = "Cleared " + card.cardProperties.Name
						privateMessage = publicMessage
					"stage":
						faceup = card.cardState.faceup
						if card.cardState.faceup:
							publicMessage = "Built " + card.cardProperties.Name + " from card pool"
							privateMessage = publicMessage
						else:
							publicMessage = "Built face down card from card pool"
							privateMessage = "Built " + card.cardProperties.Name + " from card pool"
					"momentum":
						faceup = false
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from card pool to momentum"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from card pool to momentum"
							privateMessage = "Added " + card.cardProperties.Name + " from card pool to momentum"
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from card pool"
						privateMessage = publicMessage
			"discard":
				match destinationZone:
					"deck":
						faceup = false
						publicMessage = "Added " + card.cardProperties.Name + " from discard to top of deck"
						privateMessage = publicMessage
					"hand":
						faceup = true
						private = true
						publicMessage = "Added " + card.cardProperties.Name + " from discard to hand"
						privateMessage = publicMessage
					"cardpool":
						faceup = true
						publicMessage = "Added " + card.cardProperties.Name + " from discard to card pool"
						privateMessage = publicMessage
					"stage":
						faceup = true
						publicMessage = "Built " + card.cardProperties.Name + " from discard"
						privateMessage = publicMessage
					"momentum":
						faceup = false
						publicMessage = "Added " + card.cardProperties.Name + " from discard momentum"
						privateMessage = publicMessage
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from discard"
						privateMessage = publicMessage
			"stage":
				match destinationZone:
					"deck":
						faceup = false
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from stage to top of deck"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from stage to top of deck"
							privateMessage = "Added " + card.cardProperties.Name + " from stage to top of deck"
					"hand":
						faceup = true
						private = true
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from stage to hand"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from stage to hand"
							privateMessage = "Added " + card.cardProperties.Name + " from stage to hand"
					"cardpool":
						faceup = card.cardState.faceup
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from stage to card pool"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from stage to hand"
							privateMessage = "Added " + card.cardProperties.Name + " from stage to card pool"
					"discard":
						faceup = true
						publicMessage = "Destroyed " + card.cardProperties.Name 
						privateMessage = publicMessage
					"momentum":
						faceup = false
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from stage to momentum"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from stage to momentum"
							privateMessage = "Added " + card.cardProperties.Name + " from stage to momentum"
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from stage"
						privateMessage = publicMessage
			"momentum":
				match destinationZone:
					"deck":
						faceup = false
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from momentum to top of deck"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from momentum to top of deck"
							privateMessage = "Added " + card.cardProperties.Name + " from momentum to top of deck"
					"hand":
						faceup = true
						private = true
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from momentum to hand"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from momentum to hand"
							privateMessage = "Added " + card.cardProperties.Name + " from momentum to hand"
					"cardpool":
						faceup = card.cardState.faceup
						if card.cardState.faceup:
							publicMessage = "Added " + card.cardProperties.Name + " from momentum to card pool"
							privateMessage = publicMessage
						else:
							publicMessage = "Added face down card from momentum to card pool"
							privateMessage = "Added " + card.cardProperties.Name + " from momentum to card pool"
					"discard":
						faceup = true
						publicMessage = "Spent " + card.cardProperties.Name
						privateMessage = publicMessage
					"stage":
						faceup = card.cardState.faceup
						if card.cardState.faceup:
							publicMessage = "Built " + card.cardProperties.Name + " from momentum"
							privateMessage = publicMessage
						else:
							publicMessage = "Built face down card from momentum"
							privateMessage = "Built " + card.cardProperties.Name + " from momentum"
					"removed":
						faceup = true
						publicMessage = "Removed " + card.cardProperties.Name + " from momentum"
						privateMessage = publicMessage
			"removed":
				match destinationZone:
					"deck":
						faceup = false
						publicMessage = "Added " + card.cardProperties.Name + " from removed to top of deck"
						privateMessage = publicMessage
					"hand":
						faceup = true
						private = true
						publicMessage = "Added " + card.cardProperties.Name + " from removed to hand"
						privateMessage = publicMessage
					"cardpool":
						faceup = card.cardState.faceup
						publicMessage = "Added " + card.cardProperties.Name + " from removed to card pool"
						privateMessage = publicMessage
					"discard":
						faceup = true
						publicMessage = "Added " + card.cardProperties.Name + " from removed to discard"
						privateMessage = publicMessage
					"stage":
						faceup = card.cardState.faceup
						publicMessage = "Built " + card.cardProperties.Name + " from removed"
						privateMessage = publicMessage
					"momentum":
						faceup = false
						publicMessage = "Added " + card.cardProperties.Name + " from removed to momentum"
						privateMessage = publicMessage
	
	if private:
		$"../../Rival/RivalTransit".rpc("move_to",card.cardState.currentZone, destinationZone, card, false)
	else:
		$"../../Rival/RivalTransit".rpc("move_to",card.cardState.currentZone, destinationZone, card, faceup)
	
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
			card.cardObj.rotation = 0
			stageZone.eraseCard(card)
			cardSearch.dectectChange(stageZone.stage, "Stage", stageZone.stageActions)
		"momentum":
			card.cardObj.rotation = 0
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
			
	if publicMessage != null and privateMessage != null:
		chat.addGameEventToLog(publicMessage, privateMessage)
	

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
