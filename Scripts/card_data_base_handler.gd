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
			filter.format = "Legacy"
		filter.sets = getFormat(filter.format)
	
	returnCards = populateCardListFromSets(filter)
	returnCards = applyFilter(filter, returnCards)
	
	return returnCards
	
func populateCardListFromSets(filter):
	var returnCards = []
	for i in range(filter.sets.size()):
		var setData = getSet(filter.sets[i]).cards
		var setKeys = setData.keys()
		for j in range(setKeys.size()):
			returnCards.append(setData[setKeys[j]])
		
	return returnCards

func applyFilter(filter, cards):
	var returnCards = []
	for i in range(cards.size()):
		var formatFound = false
		var nameMatched = false
		var textMached = false
		var cardTypeMatched = false
		var hasSymbol = false
		var hasKeywordT = false
		var hasKeywordA = false
		var keywordCountMatched = false
		var abilityCountMatched = false
		var blockZoneMatched = false
		var blockModMatched = false
		var speedMatched = false
		var attackZoneMatched = false
		var damageMatched = false
		var handSizeMatched = false
		var healthMatched = false
		var difficultyMatched = false
		var checkMatched = false
		#filter by format
		if filter.format != "":
			for j in range(cards[i].Legality.size()):
				if filter.format == cards[i].Legality[j]:
					formatFound = true
					break
		else:
			formatFound = true
		
		#filter by card name
		if filter.cardName != null:
			if cards[i].Name.contains(filter.cardName):
				nameMatched = true
		else:
			nameMatched = true
		
		#filter by card text
		if filter.cardText != null:
			for j in range(cards[i].Abilities.size()):
				var abilityStr = cards[i].Abilities[j].Type + " " + cards[i].Abilities[j].Cost + ": " + cards[i].Abilities[j].Effect
				if abilityStr.contains(filter.cardText):
					textMached = true
					break
		else:
			textMached = true
		
		#filter cardtype
		if filter.cardType.size() != 0:
			for j in range(filter.cardType.size()):
				if cards[i].Cardtype == filter.cardType[j]:
					cardTypeMatched = true
					break
		else:
			cardTypeMatched = true
		
		#filter symbols
		if filter.symbols.size() != 0 or filter.symbolsAttned.size() != 0:
			if filter.symbols.size() != 0:
				for j in range(filter.symbols.size()):
					for k in range(cards[i].Symbols.size()):
						if cards[i].Symbols[k] == filter.symbols[j].to_lower():
							hasSymbol = true
							break
			
			#filter attund symbols
			if filter.symbolsAttned.size() != 0:
				for j in range(filter.symbolsAttned.size()):
					for k in range(cards[i].Symbols.size()):
						if cards[i].Symbols[k] == "at_" + filter.symbolsAttned[j].to_lower():
							hasSymbol = true
							break
		else:
			hasSymbol = true
			
		
		#filter if a card has a keyword trait
		if filter.keywordTraits.size() != 0:
			for j in range(filter.keywordTraits.size()):
				for k in range(cards[i].Keywords.size()):
					if cards[i].Keywords[k].Name == filter.keywordTraits[j]:
						hasKeywordT = true
						break
		else:
			hasKeywordT = true
			
		#filter if a card has a keyword ability
		if filter.keywordAbilities.size() != 0:
			for j in range(filter.keywordAbilities.size()):
				for k in range(cards[i].Keywords.size()):
					if cards[i].Keywords[k].Name.contains(filter.keywordAbilities[j]):
						hasKeywordA = true
						break
		else:
			hasKeywordA = true
			
		#filter numer of keywords
		if filter.keywordCount and filter.keywordCountValue != null:
			if (filter.keywordCountMode == "=" and filter.keywordCountValue == cards[i].Keywords.size()) or (filter.keywordCountMode == "<" and cards[i].Keywords.size() < filter.keywordCountValue) or (filter.keywordCountMode == ">" and cards[i].Keywords.size() > filter.keywordCountValue):
				keywordCountMatched = true
		else:
			keywordCountMatched = true
			
		#filter number of abilities
		if filter.abilityCount and filter.abilityCountValue != null:
			if (filter.abilityCountMode == "=" and filter.abilityCountValue == cards[i].Abilities.size()) or (filter.abilityCountMode == "<" and cards[i].Abilities.size() < filter.abilityCountValue) or (filter.abilityCountMode == ">" and cards[i].Abilities.size() > filter.abilityCountValue):
				abilityCountMatched = true
		else:
			abilityCountMatched = true
			
		#filter block zone
		if filter.blockZone != null:
			if filter.blockZone.to_lower() == cards[i].BlockZone:
				blockZoneMatched = true
		else:
			blockZoneMatched = true
			
		#filter block mod
		if filter.blockMod and filter.blockModValue != null:
			if cards[i].BlockMod != null:
				if (filter.blockModMode == "=" and filter.blockModValue == cards[i].BlockMod) or (filter.blockModMode == "<" and cards[i].BlockMod < filter.blockModValue) or (filter.blockModMode == ">" and cards[i].BlockMod > filter.blockModValue):
					blockModMatched = true
		else:
			blockModMatched = true
			
		#filter speed
		if filter.speed and filter.speedValue != null:
			if cards[i].Speed != null:
				if (filter.speedMode == "=" and filter.speedValue == cards[i].Speed) or (filter.speedMode == "<" and cards[i].Speed < filter.speedValue) or (filter.speedMode == ">" and cards[i].Speed > filter.speedValue):
					speedMatched = true
		else:
			speedMatched = true
			
		#filter attack zone
		if filter.attackZone != null:
			if cards[i].AttackZone != null:
				if filter.attackZone.to_lower() == cards[i].AttackZone:
					attackZoneMatched = true
		else:
			attackZoneMatched = true
		
		#filter damage
		if filter.damage and filter.damageValue != null:
			if cards[i].Damage != null:
				if (filter.damageMode == "=" and filter.damageValue == cards[i].Damage) or (filter.damageMode == "<" and cards[i].Damage < filter.damageValue) or (filter.damageMode == ">" and cards[i].Damage > filter.damageValue):
					damageMatched = true
		else:
			damageMatched = true
		
		#filter hand size
		if filter.handSize and filter.handSizeValue != null:
			if cards[i].HandSize != null:
				if (filter.handSizeMode == "=" and filter.handSizeValue == cards[i].HandSize) or (filter.handSizeMode == "<" and cards[i].HandSize < filter.handSizeValue) or (filter.handSizeMode == ">" and cards[i].HandSize > filter.handSizeValue):
					handSizeMatched = true
		else:
			handSizeMatched = true
		
		#filter health
		if filter.health and filter.healthValue != null:
			if cards[i].Health != null:
				if (filter.healthMode == "=" and filter.healthValue == cards[i].Health) or (filter.healthMode == "<" and cards[i].Health < filter.healthValue) or (filter.healthMode == ">" and cards[i].Health > filter.healthValue):
					healthMatched = true
		else:
			healthMatched = true
		
		#filter diff
		if filter.difficulty and filter.difficultyValue != null:
			if cards[i].Difficulty != null:
				if (filter.difficultyMode == "=" and filter.difficultyValue == cards[i].Difficulty) or (filter.difficultyMode == "<" and cards[i].Difficulty < filter.difficultyValue) or (filter.difficultyMode == ">" and cards[i].Difficulty > filter.difficultyValue):
					difficultyMatched = true
		else:
			difficultyMatched = true
		
		#filter check
		if filter.check and filter.checkValue != null:
			if cards[i].Check != null:
				if (filter.checkMode == "=" and filter.checkValue == cards[i].Check) or (filter.checkMode == "<" and cards[i].Check < filter.checkValue) or (filter.checkMode == ">" and cards[i].Check > filter.checkValue):
					checkMatched = true
		else:
			checkMatched = true
		
		#if filters matched add card to result list
		if formatFound and nameMatched and textMached and cardTypeMatched and hasSymbol and hasKeywordT and hasKeywordA and keywordCountMatched and abilityCountMatched and blockZoneMatched and blockModMatched and speedMatched and attackZoneMatched and damageMatched and handSizeMatched and healthMatched and difficultyMatched and checkMatched:
			returnCards.append(cards[i])
		
	return returnCards
