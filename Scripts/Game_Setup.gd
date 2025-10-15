extends Node2D


func host_setup():
	call_deferred("initCharacters")
	call_deferred("startingHands")
	
func client_setup():
	call_deferred("initCharacters")
	call_deferred("startingHands")
	

func initCharacters():
	var card_database = get_node("/root/Main/CardDataBaseHandler")
	var startingCharacter = $"Player/Deck".decklist.character.cardID
	$"Player/Transit".move_to("character", {
			"cardID": startingCharacter,
			"cardProperties": card_database.getCard(startingCharacter),
			"cardState": $"Player/Deck".defaultCardState.duplicate(),
			"cardObj": null
		}, false)
	$"../SyncFunctions".setPlayerHealth($"Player/Stage".starting_character.cardProperties.Health)
	$"Player/Stage".starting_character.cardState.maxHealth = $"Player/Stage".starting_character.cardProperties.Health

func startingHands():
	$"Player/Deck".drawToHandSize()
