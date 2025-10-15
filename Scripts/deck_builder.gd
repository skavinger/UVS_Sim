extends Node2D

const LIST_CARD_SCENE_PATH = "res://GameObj/list_card.tscn"

func _ready() -> void:
	populateDeckList()

func _on_back_pressed() -> void:
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func populateDeckList():
	var decklist = $"../..".currentDeckList
	
	#clear current list
	var deckBuilderList = $DecklistBox/ScrollContainer/GridContainer.get_children()
	for i in range(deckBuilderList.size()):
		$DecklistBox/ScrollContainer/GridContainer.remove_child(deckBuilderList[i])
	
	for i in range(decklist.main.size()):
		var cardData = $"../../CardDataBaseHandler".getCard(decklist.main[i].cardID)
		for j in range(decklist.main[i].count):
			var card = preload(LIST_CARD_SCENE_PATH).instantiate()
			$DecklistBox/ScrollContainer/GridContainer.add_child(card)
			card.get_node("CardImage").texture = load("res://Assets/Sets/" + decklist.main[i].cardID.set + "/Images/" + decklist.main[i].cardID.number + ".jpg")
			card.get_node("CardName").text = cardData.Name
			card.cardMeta = cardData
