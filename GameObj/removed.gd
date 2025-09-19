extends Node2D

const objType = "removed"

var removed = []

var cardMan

func _ready() -> void:
	cardMan = $"../CardManager"

func change_top():
	if(removed.size() > 0):
		self.get_node("Sprite2D").visible = true
		self.get_node("Sprite2D").texture = load("res://Assets/Sets/" + removed[0].cardID.set + "/" + removed[0].cardID.number + ".jpg")
	else:
		self.get_node("Sprite2D").visible = false

func add_to_removed(card):
	removed.insert(0, card)
	cardMan.despwan_card(removed[0].cardObj)
	removed[0].cardObj = null
	change_top()
