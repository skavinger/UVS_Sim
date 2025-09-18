extends Node2D

var deckZone
var handZone
var cardpoolZone
var stageZone
var discardZone
var removedZone
var momentumZone

func _ready() -> void:
	deckZone = $"../Deck"
	handZone = $"../Hand"
	cardpoolZone = $"../Cardpool"
	stageZone = $"../Stage"
	discardZone = $"../Discard"
	removedZone = $"../Removed"
	momentumZone = $"../Momentum"
