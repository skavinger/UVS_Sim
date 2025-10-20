extends Node2D

const DATABASE_ENTRY_PATH = "res://GameObj/card_database_entry.tscn"

func _ready() -> void:
	#populateCardDatabase
	for setName in DirAccess.open("user://SetData/").get_directories():
		var setData = FileAccess.get_file_as_string("user://SetData/" + setName + "/setData.json")
		setData = JSON.parse_string(setData)
		var newEntry = preload(DATABASE_ENTRY_PATH).instantiate()
		self.add_child(newEntry)
		newEntry.cards = setData
		newEntry.setName = setName
		newEntry.name = setName

func getCard(cardID):
	var dataBaseEntries = self.get_children()
	for i in range(dataBaseEntries.size()):
		if(dataBaseEntries[i].setName == cardID.set):
			return dataBaseEntries[i].cards[cardID.number]

func getSet(setData):
	var dataBaseEntries = self.get_children()
	for i in range(dataBaseEntries.size()):
		if(dataBaseEntries[i].setName == setData):
			return dataBaseEntries[i]

func getCardsFromFilter(filter):
	var returnCards = []
	for i in range(filter.sets.size()):
		returnCards.append(getSet(filter.sets[i]).cards)
	
	return returnCards

func get_card_art(cardID):
	var image = Image.load_from_file("user://SetData/" + cardID.set + "/Images/" + cardID.number + ".jpg")
	return ImageTexture.create_from_image(image)

func get_card_art_small(cardID):
	var image = Image.load_from_file("user://SetData/" + cardID.set + "/Images_small/" + cardID.number + ".jpg")
	return ImageTexture.create_from_image(image)
