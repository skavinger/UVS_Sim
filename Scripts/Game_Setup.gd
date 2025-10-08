extends Node2D


func host_setup():
	call_deferred("initCharacters")
	call_deferred("startingHands")
	
func client_setup():
	call_deferred("initCharacters")
	call_deferred("startingHands")
	

func initCharacters():
	var startingCharacter = $"Player/Deck".decklist.character.cardID
	$"Player/Transit".move_to("character", {
			"cardID": startingCharacter,
			"cardProperties": $"Player/Deck".card_database.CARDS[startingCharacter.set][startingCharacter.number],
			"cardState": $"Player/Deck".cardState.duplicate(),
			"cardObj": null
		}, false)
	$"../SyncFunctions".setPlayerHealth($"Player/Stage".starting_character.cardProperties.Health)

func startingHands():
	$"Player/Deck".drawToHandSize()
