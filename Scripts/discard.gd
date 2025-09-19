extends Node2D

const objType = "discard"

var discard = []

var transitZone
var cardMan
var animationMan

func _ready() -> void:
	transitZone = $"../Transit"
	cardMan = $"../CardManager"
	animationMan = $"../AnimationManager"

func change_top():
	if(discard.size() > 0):
		self.get_node("Sprite2D").visible = true
		self.get_node("Sprite2D").texture = load("res://Assets/Sets/" + discard[0].cardID.set + "/" + discard[0].cardID.number + ".jpg")
	else:
		self.get_node("Sprite2D").visible = false

func add_to_discard(card):
	discard.insert(0, card)
	animationMan.animate_card_to_pos(discard[0].cardObj, self.position)
	await get_tree().create_timer(0.2).timeout
	cardMan.despwan_card(discard[0].cardObj)
	discard[0].cardObj = null
	change_top()
	pass
