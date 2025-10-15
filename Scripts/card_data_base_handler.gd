extends Node2D

const DATABASE_ENTRY_PATH = "res://GameObj/card_database_entry.tscn"

func _ready() -> void:
	#populateCardDatabase
	for setName in DirAccess.open("res://Assets/Sets/").get_directories():
		var setData = FileAccess.get_file_as_string("res://Assets/Sets/" + setName + "/setData.json")
		setData = JSON.parse_string(setData)
		var newEntry = preload(DATABASE_ENTRY_PATH).instantiate()
		self.add_child(newEntry)
		newEntry.cards = setData
		newEntry.setName = setName

func getCard(cardID):
	var dataBaseEntries = self.get_children()
	for i in range(dataBaseEntries.size()):
		if(dataBaseEntries[i].setName == cardID.set):
			return dataBaseEntries[i].cards[cardID.number]
