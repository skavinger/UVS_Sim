extends Node2D

const objType = "discard"

var discard = []

var cardMan

func _ready() -> void:
	cardMan = $"../CardManager"

func change_top():
	if(discard.size() > 0):
		self.get_node("Sprite2D").visible = true
		self.get_node("Sprite2D").texture = load("res://Assets/Sets/" + discard[0].cardID.set + "/" + discard[0].cardID.number + ".jpg")
	else:
		self.get_node("Sprite2D").visible = false

func add_to_discard(card):
	discard.insert(0, card)
	cardMan.despwan_card(discard[0].cardObj)
	discard[0].cardObj = null
	change_top()
