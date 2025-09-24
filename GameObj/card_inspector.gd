extends Node2D

func showInspector(card):
	self.z_index = 1000
	self.get_node("Card").texture = load("res://Assets/Sets/" + card.cardID.set + "/" + card.cardID.number + ".jpg")
	
func hideInspector():
	self.z_index = -1000
