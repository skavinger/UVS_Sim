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
	
	var Actions = []
	var Assets = []
	var Backups = []
	var Attacks = []
	var Foundations = []
	
	for i in range(decklist.main.size()):
		var cardData = CardDatabase.getCard(decklist.main[i].cardID)
		for j in range(decklist.main[i].count):
			var card = preload(LIST_CARD_SCENE_PATH).instantiate()
			card.get_node("CardImage").texture = CardDatabase.get_card_art(decklist.main[i].cardID)
			card.get_node("CardName").text = cardData.Name
			card.cardMeta = cardData
			match cardData.Cardtype:
				"Action":
					Actions.push_back(card)
				"Asset":
					Assets.push_back(card)
				"Backup":
					Backups.push_back(card)
				"Attack":
					Attacks.push_back(card)
				"Foundation":
					Foundations.push_back(card)
	
	for i in range(Actions.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Actions[i])
	for i in range(Assets.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Assets[i])
	for i in range(Backups.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Backups[i])
	for i in range(Attacks.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Attacks[i])
	for i in range(Foundations.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Foundations[i])
	
