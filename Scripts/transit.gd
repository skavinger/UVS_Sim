extends Node2D

var cardMan

var deckZone
var handZone
var cardpoolZone
var stageZone
var discardZone
var removedZone
var momentumZone

func _ready() -> void:
	cardMan = $"../CardManager"
	
	deckZone = $"../Deck"
	handZone = $"../Hand"
	cardpoolZone = $"../Cardpool"
	stageZone = $"../Stage"
	discardZone = $"../Discard"
	removedZone = $"../Removed"
	momentumZone = $"../Momentum"

func move_to(zone, card):
	#if card obj hasn't been spawned yet spawn it
	if card.cardObj == null:
		card.cardObj = cardMan.spawn_card(card)
		card.cardObj.get_node("AnimationPlayer").play("Card_Flip")
		
	match zone:
		"character":
			stageZone.add_character_to_stage(card)
		"top deck":
			pass
		"bottom deck":
			pass
		"hand":
			handZone.add_card_to_hand(card)
		"cardpool":
			cardpoolZone.add_to_card_pool(card)
		"discard":
			discardZone.add_to_discard(card)
		"stage":
			stageZone.build_card(card)
		"momentum":
			pass
		"removed":
			removedZone.add_to_removed(card)
