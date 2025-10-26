extends Node2D

const DATABASE_ENTRY_PATH = "res://GameObj/card_database_entry.tscn"

var formatList
var keywordTraitList
var keywordAbilityList

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
	
	formatList = FileAccess.get_file_as_string("user://SetData/formats.json")
	formatList = JSON.parse_string(formatList).formats
	var keywordList = FileAccess.get_file_as_string("user://SetData/keywords.json")
	keywordTraitList = JSON.parse_string(keywordList).traits
	keywordAbilityList = JSON.parse_string(keywordList).abilities

func getFormat(format):
	return formatList[format]

func getFormats():
	return formatList.keys()

func getCard(cardID):
	var dataBaseEntries = self.get_children()
	for i in range(dataBaseEntries.size()):
		if(dataBaseEntries[i].setName == cardID.set):
			return dataBaseEntries[i].cards[cardID.number]

func getSet(setName):
	var dataBaseEntries = self.get_children()
	for i in range(dataBaseEntries.size()):
		if(dataBaseEntries[i].setName == setName):
			return dataBaseEntries[i]

func getSets():
	var sets = []
	var setDatabases = self.get_children()
	for i in range(setDatabases.size()):
		sets.append(setDatabases[i].setName)
	return sets

func get_card_art(cardID):
	var image = Image.load_from_file("user://SetData/" + cardID.set + "/Images/" + cardID.number + ".jpg")
	return ImageTexture.create_from_image(image)

func get_card_art_small(cardID):
	var image = Image.load_from_file("user://SetData/" + cardID.set + "/Images_small/" + cardID.number + ".jpg")
	return ImageTexture.create_from_image(image)
	
func getKeywordTraits():
	return keywordTraitList
	
func getKeywordAbilities():
	return keywordAbilityList

func getCardsFromFilter(filter):
	var returnCards = []
	if filter.sets.size() == 0:
		if filter.format == "":
			return returnCards
		filter.sets = getFormat(filter.format)
	
	returnCards = populateCardListFromSets(filter)
	returnCards = filterByFormat(filter, returnCards)
	
	return returnCards
	
func populateCardListFromSets(filter):
	var returnCards = []
	for i in range(filter.sets.size()):
		var setData = getSet(filter.sets[i]).cards
		var setKeys = setData.keys()
		for j in range(setKeys.size()):
			returnCards.append(setData[setKeys[j]])
		
	return returnCards

func filterByFormat(filter, cards):
	var returnCards = []
	for i in range(cards.size()):
		var found = false
		for j in range(cards[i].Legality.size()):
			if filter.format == cards[i].Legality[j]:
				found = true
				break
		if found:
			returnCards.append(cards[i])
			
	return returnCards
