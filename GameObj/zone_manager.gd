extends Node2D

var deckZone
var handZone
var stageZone
var discardZone
var removedZone
var momentumZone

func _ready() -> void:
	deckZone = $"../Deck"
	handZone = $"../Hand"
	stageZone = $"../Stage"
	discardZone = $"../Discard"
	removedZone = $"../Removed"
	momentumZone = $"../Momentum"
