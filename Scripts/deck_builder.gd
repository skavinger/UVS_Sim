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
	
	$Character.texture = CardDatabase.get_card_art(decklist.character.cardID)
	
	var Characters = []
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
				"Character":
					Characters.push_back(card)
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
	
	$Cardcounts/CharacterCount.text = str(Characters.size())
	$Cardcounts/ActionCount.text = str(Actions.size())
	$Cardcounts/AssetCount.text = str(Assets.size())
	$Cardcounts/AttackCount.text = str(Attacks.size())
	$Cardcounts/BackupCount.text = str(Backups.size())
	$Cardcounts/FoundationCount.text = str(Foundations.size())
	
	for i in range(Characters.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Characters[i])
	for i in range(Actions.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Actions[i])
	for i in range(Assets.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Assets[i])
	for i in range(Attacks.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Attacks[i])
	for i in range(Backups.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Backups[i])
	for i in range(Foundations.size()):
		$DecklistBox/ScrollContainer/GridContainer.add_child(Foundations[i])
		
	#Populate Side
	var CharactersSide = []
	var ActionsSide = []
	var AssetsSide = []
	var BackupsSide = []
	var AttacksSide = []
	var FoundationsSide = []
	
	var sideBuilderList = $SideBoardList/ScrollContainer/GridContainer.get_children()
	for i in range(deckBuilderList.size()):
		$SideBoardList/ScrollContainer/GridContainer.remove_child(sideBuilderList[i])
		
	for i in range(decklist.side.size()):
		var cardData = CardDatabase.getCard(decklist.side[i].cardID)
		for j in range(decklist.side[i].count):
			var card = preload(LIST_CARD_SCENE_PATH).instantiate()
			card.get_node("CardImage").texture = CardDatabase.get_card_art(decklist.side[i].cardID)
			card.get_node("CardName").text = cardData.Name
			card.cardMeta = cardData
			match cardData.Cardtype:
				"Character":
					CharactersSide.push_back(card)
				"Action":
					ActionsSide.push_back(card)
				"Asset":
					AssetsSide.push_back(card)
				"Backup":
					BackupsSide.push_back(card)
				"Attack":
					AttacksSide.push_back(card)
				"Foundation":
					FoundationsSide.push_back(card)
	
	for i in range(CharactersSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(CharactersSide[i])
	for i in range(ActionsSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(ActionsSide[i])
	for i in range(AssetsSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(AssetsSide[i])
	for i in range(AttacksSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(AttacksSide[i])
	for i in range(BackupsSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(BackupsSide[i])
	for i in range(FoundationsSide.size()):
		$SideBoardList/ScrollContainer/GridContainer.add_child(FoundationsSide[i])
	
