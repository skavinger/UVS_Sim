extends Node2D

const LIST_CARD_SCENE_PATH = "res://GameObj/Deckbuilder/list_card.tscn"

const PAGESIZE = 300

var page = 0
var cardDatabaseScreen = []
var selectedSave = ""

func _ready() -> void:
	populateDeckList()
	
	populateSaves()

func _on_back_pressed() -> void:
	var saveFile = FileAccess.open("user://Saves/current_list.auto_sav",FileAccess.WRITE)
	saveFile.store_string(JSON.stringify($"../..".currentDeckList))
	$"../../StartWindowHolder".spawnWindow()
	$"..".closeWindow()

func fillFilterResults(cards):
	page = 0
	cardDatabaseScreen = []
	for i in range(cards.size()):
		var card = preload(LIST_CARD_SCENE_PATH).instantiate()
		card.get_node("CardImage").texture_normal = CardDatabase.get_card_art_small({ "set": cards[i].setName, "number": cards[i].cardNumber})
		card.get_node("CardName").text =cards[i].Name
		card.cardMeta = cards[i]
		card.source = "database"
		cardDatabaseScreen.append(card)
			
	populateDataBaseWindow()

func populateDataBaseWindow():
	var dataBaseWindow = $CardDatabaseList/ScrollContainer/GridContainer.get_children()
	for i in range(dataBaseWindow.size()):
		$CardDatabaseList/ScrollContainer/GridContainer.remove_child(dataBaseWindow[i])
		
	$CardDatabaseList/PageCount.text = str(page + 1)
	for i in PAGESIZE:
		if (i + (page * PAGESIZE) + 1) > cardDatabaseScreen.size():
			break
		$CardDatabaseList/ScrollContainer/GridContainer.add_child(cardDatabaseScreen[i + (page * PAGESIZE)])

func populateDeckList():
	var decklist = $"../..".currentDeckList
	
	var deckBuilderList = $DecklistBox/ScrollContainer/GridContainer.get_children()
	for i in range(deckBuilderList.size()):
		$DecklistBox/ScrollContainer/GridContainer.remove_child(deckBuilderList[i])
	
	var sideBuilderList = $SideBoardList/ScrollContainer/GridContainer.get_children()
	for i in range(sideBuilderList.size()):
		$SideBoardList/ScrollContainer/GridContainer.remove_child(sideBuilderList[i])
	$DeckDetails/Character.texture_normal = null
	
	$DeckDetails/DeckName.text = decklist.DeckName
	$"../..".currentDeckList.Formats = getFormats()
	$DeckDetails/Formats/ScrollContainer/RichTextLabel.text = ""
	for i in range($"../..".currentDeckList.Formats.size()):
		$DeckDetails/Formats/ScrollContainer/RichTextLabel.append_text($"../..".currentDeckList.Formats[i] + "\n")
	
	
	if decklist.character != null:
		setCharacter(decklist.character.cardID)
	
	if decklist.main.size() != 0:
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
				card.get_node("CardImage").texture_normal = CardDatabase.get_card_art_small(decklist.main[i].cardID)
				card.get_node("CardName").text = cardData.Name
				card.cardMeta = cardData
				card.source = "deck"
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
	else:
		$Cardcounts/CharacterCount.text = "0"
		$Cardcounts/ActionCount.text = "0"
		$Cardcounts/AssetCount.text = "0"
		$Cardcounts/AttackCount.text = "0"
		$Cardcounts/BackupCount.text = "0"
		$Cardcounts/FoundationCount.text = "0"
		
	if decklist.side.size() != 0:
		var CharactersSide = []
		var ActionsSide = []
		var AssetsSide = []
		var BackupsSide = []
		var AttacksSide = []
		var FoundationsSide = []
			
		for i in range(decklist.side.size()):
			var cardData = CardDatabase.getCard(decklist.side[i].cardID)
			for j in range(decklist.side[i].count):
				var card = preload(LIST_CARD_SCENE_PATH).instantiate()
				card.get_node("CardImage").texture_normal = CardDatabase.get_card_art_small(decklist.side[i].cardID)
				card.get_node("CardName").text = cardData.Name
				card.cardMeta = cardData
				card.source = "side"
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

func _on_page_back_pressed() -> void:
	if page > 0:
		page = page - 1
		populateDataBaseWindow()

func _on_page_forward_pressed() -> void:
	@warning_ignore("integer_division")
	if int(cardDatabaseScreen.size() / PAGESIZE) > page :
		page = page + 1
		populateDataBaseWindow()

func connect_signals(cardObj):
	cardObj.connect("hovered", populateInspector)
	cardObj.connect("clicked_right", card_right_clicked)
	cardObj.connect("clicked_left", card_left_clicked)

func populateInspector(cardID):
	if cardID != null:
		$CardInspector/CardArt.texture = CardDatabase.get_card_art({"set": cardID.set, "number": cardID.number})
		genCardText(get_node("CardInspector/ScrollContainer/CardText"),CardDatabase.getCard(cardID))

func card_left_clicked(source, cardMeta):
	match source:
		"database":
			addToDeck(cardMeta)
		"deck":
			pass
		"side":
			pass

func card_right_clicked(source, cardMeta):
	match source:
		"database":
			addToSide(cardMeta)
		"deck":
			removeFromDeck(cardMeta)
		"side":
			removeFromSide(cardMeta)

func addToDeck(cardMeta):
	var cardID = {"set": cardMeta.setName, "number": cardMeta.cardNumber}
	var added = false
	if cardMeta.Cardtype == "Character" and $"../..".currentDeckList.character == null:
		setCharacter(cardID)
	else:
		if cardMeta.Difficulty != null:
			for i in range($"../..".currentDeckList.main.size()):
				if $"../..".currentDeckList.main[i].cardID.set == cardMeta.setName and $"../..".currentDeckList.main[i].cardID.number == cardMeta.cardNumber:
					$"../..".currentDeckList.main[i].count = $"../..".currentDeckList.main[i].count + 1
					added = true
					break
			if !added:
				$"../..".currentDeckList.main.append({"count": 1, "cardID": cardID})
	populateDeckList()

func setCharacter(cardID):
	$"../..".currentDeckList.character = {"cardID": cardID}
	$DeckDetails/Character.texture_normal = CardDatabase.get_card_art(cardID)
	$DeckDetails/CharacterName.text = CardDatabase.getCard(cardID).Name

func unSetCharacter():
	$"../..".currentDeckList.character = null
	$DeckDetails/Character.texture_normal = null
	$DeckDetails/CharacterName.text = ""

func addToSide(cardMeta):
	var cardID = {"set": cardMeta.setName, "number": cardMeta.cardNumber}
	var added = false
	for i in range($"../..".currentDeckList.side.size()):
		if $"../..".currentDeckList.side[i].cardID.set == cardMeta.setName and $"../..".currentDeckList.side[i].cardID.number == cardMeta.cardNumber:
			$"../..".currentDeckList.side[i].count = $"../..".currentDeckList.side[i].count + 1
			added = true
			break
	if !added:
		$"../..".currentDeckList.side.append({"count": 1, "cardID": cardID})
	populateDeckList()

func removeFromDeck(cardMeta):
	for i in range($"../..".currentDeckList.main.size()):
		if $"../..".currentDeckList.main[i].cardID.set == cardMeta.setName and $"../..".currentDeckList.main[i].cardID.number == cardMeta.cardNumber:
			$"../..".currentDeckList.main[i].count = $"../..".currentDeckList.main[i].count - 1
			if  $"../..".currentDeckList.main[i].count == 0:
				$"../..".currentDeckList.main.remove_at(i)
			break
	populateDeckList()
	
func removeFromSide(cardMeta):
	for i in range($"../..".currentDeckList.side.size()):
		if $"../..".currentDeckList.side[i].cardID.set == cardMeta.setName and $"../..".currentDeckList.side[i].cardID.number == cardMeta.cardNumber:
			$"../..".currentDeckList.side[i].count = $"../..".currentDeckList.side[i].count - 1
			if  $"../..".currentDeckList.side[i].count == 0:
				$"../..".currentDeckList.side.remove_at(i)
			break
	populateDeckList()

func genCardText(textbox, card):
	textbox.text = ""
	textbox.append_text(card.Name + "\n")
	
	if(card.Cardtype == "Character"):
		textbox.append_text("[color=purple]")
	elif(card.Cardtype == "Action"):
		textbox.append_text("[color=blue]")
	elif(card.Cardtype == "Asset"):
		textbox.append_text("[color=green]")
	elif(card.Cardtype == "Attack"):
		textbox.append_text("[color=orange]")
	elif(card.Cardtype == "Backup"):
		textbox.append_text("[color=pink]")
	elif(card.Cardtype == "Foundation"):
		textbox.append_text("[color=grey]")
	textbox.append_text(card.Cardtype + "[/color]\n")
	
	if(card.Difficulty != null):
		textbox.append_text("Difficulty: " + str(int(card.Difficulty)) + " | " + "Check: " + str(int(card.Check)) + "\n")
	
	if(card.HandSize != null):
		textbox.append_text("Hand Size: " + str(int(card.HandSize)) + " | " + "Health: " + str(int(card.Health)) + "\n")
	
	if(card.BlockZone != null and card.BlockMod != null):
		textbox.append_text("Block Zone: " + card.BlockZone + " | " + "Block Modifier: " + str(int(card.BlockMod)) + "\n")
	
	if(card.AttackZone != null):
		textbox.append_text("Speed: " + str(int(card.Speed)) + " | " + "Zone: " + card.AttackZone + " | " + "Damage: " + str(int(card.Damage)) + "\n")
	
	for i in range(card.Keywords.size()):
		var color = checkKeywordColor(card.Keywords[i].Name)
		if(color != ""):
			textbox.append_text("[color=" + color + "]")
		textbox.append_text(card.Keywords[i].Name)
		if(card.Keywords[i].Rating != null):
			textbox.append_text(" " + str(int(card.Keywords[i].Rating)))
		if(color != ""):
			textbox.append_text("[/color]")
		if(i + 1 != card.Keywords.size()):
			textbox.append_text(" | ")
	
	textbox.append_text("\n\n")
	for i in range(card.Abilities.size()):
		if(card.Abilities[i].Type.contains("Static")):
			textbox.append_text(card.Abilities[i].Effect + "\n\n")
		else:
			if(card.Abilities[i].Type.contains("Enhance")):
				textbox.append_text("[color=orange]" + card.Abilities[i].Type + "[/color] ")
			elif(card.Abilities[i].Type.contains("Response")):
				textbox.append_text("[color=green]" + card.Abilities[i].Type + "[/color] ")
			elif(card.Abilities[i].Type.contains("Form")):
				textbox.append_text("[color=lightblue]" + card.Abilities[i].Type + "[/color] ")
			elif(card.Abilities[i].Type.contains("Blitz")):
				textbox.append_text("[color=pink]" + card.Abilities[i].Type + "[/color] ")
			
			if(card.Abilities[i].Cost != null):
				textbox.append_text(card.Abilities[i].Cost + ": ")
			else:
				textbox.append_text(": ")
			textbox.append_text(card.Abilities[i].Effect + "\n\n")
		
func checkKeywordColor(keyword):
	if(keyword.contains("Stun") or 
	keyword.contains("Powerful") or
	keyword.contains("EX") or 
	keyword.contains("Multiple") or 
	keyword.contains("Gauge")):
		return "orange"
	elif(keyword.contains("Echo") or
	keyword.contains("Breaker") or
	keyword.contains("Deflect") or
	keyword.contains("Reversal")):
		return "green"
	elif(keyword.contains("Combo") or
	keyword.contains("Desperation") or
	keyword.contains("Elusive") or
	keyword.contains("Flash") or
	keyword.contains("Only") or 
	keyword.contains("Safe")or 
	keyword.contains("Shift") or 
	keyword.contains("Terrain") or 
	keyword.contains("Throw") or 
	keyword.contains("Unique")):
		return "lightblue"
	elif(keyword.contains("Frenzy") or
	keyword.contains("Tension")):
		return "pink"
	return ""

func populateSaves():
	if !DirAccess.dir_exists_absolute("user://Saves/"):
			DirAccess.make_dir_absolute("user://Saves/")
	var saves = DirAccess.open("user://Saves/").get_files()
	for i in range(saves.size()):
		if saves[i].contains(".uvs_sav"):
			$Save_Load/Saves.get_popup().add_item(saves[i])
			
	$Save_Load/Saves.get_popup().id_pressed.connect(_save_selected)

func _save_selected(id):
	var save = $Save_Load/Saves.get_popup().get_item_text(id)
	$Save_Load/Saves.text = save
	selectedSave = save

func _on_load_pressed() -> void:
	var saveFile = FileAccess.get_file_as_string("user://Saves/" + selectedSave)
	saveFile = JSON.parse_string(saveFile)
	if saveFile != null:
		$"../..".currentDeckList = saveFile
		$DeckDetails/DeckName.text = saveFile.DeckName
		populateDeckList()

func _on_save_pressed() -> void:
	if $"../..".currentDeckList != null:
		var fileName = $DeckDetails/DeckName.text + ".uvs_sav"
		if !DirAccess.dir_exists_absolute("user://Saves/"):
			DirAccess.make_dir_absolute("user://Saves/")
		var saveFile = FileAccess.open("user://Saves/" + fileName,FileAccess.WRITE)
		saveFile.store_string(JSON.stringify($"../..".currentDeckList))
		$Save_Load/Saves.get_popup().add_item(fileName)

func _on_deck_name_text_changed(new_text: String) -> void:
	$"../..".currentDeckList.DeckName = new_text


func _on_character_mouse_entered() -> void:
	$DeckDetails/Timer.start()

func _on_character_mouse_exited() -> void:
	$DeckDetails/Timer.stop()

func _on_timer_timeout() -> void:
	if $"../..".currentDeckList.character != null:
		populateInspector($"../..".currentDeckList.character.cardID)

func _on_character_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				unSetCharacter()

func _on_filter_pressed() -> void:
	$FilterWindow.z_index = 1000
	move_child($FilterWindow, -1)

func _on_close_filter_pressed() -> void:
	$FilterWindow.z_index = -1000
	move_child($FilterWindow, 0)
	fillFilterResults(CardDatabase.getCardsFromFilter($FilterWindow.filter))

func getFormats():
	var decklist = $"../..".currentDeckList
	var formats = CardDatabase.getFormats()
	var outFormats = formats.duplicate()
	for i in range(decklist.main.size()):
		var cardData = CardDatabase.getCard(decklist.main[i].cardID)
		for j in range(formats.size()):
			var found = false
			for k in range(cardData.Legality.size()):
				if formats[j] == cardData.Legality[k]:
					found = true
			if !found:
				outFormats.erase(formats[j])
	return outFormats
