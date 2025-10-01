extends Node2D


func host_setup():
	initCharacters()
	
func client_setup():
	initCharacters()
	

func initCharacters():
	var startingCharacter = $"Player/Deck".decklist.character.cardID
	$"Player/Transit".move_to("character", {
			"cardID": startingCharacter,
			"cardProperties": $"Player/Deck".card_database.CARDS[startingCharacter.set][startingCharacter.number],
			"cardState": $"Player/Deck".cardState.duplicate(),
			"cardObj": null
		}, false)
	
	$"Player/Deck".drawToHandSize()
	
	var rivalStartingCharacter = $"Rival/RivalDeck".decklist.character.cardID
	$"Rival/RivalTransit".move_to("character", {
			"cardID": rivalStartingCharacter,
			"cardProperties": $"Rival/RivalDeck".card_database.CARDS[rivalStartingCharacter.set][rivalStartingCharacter.number],
			"cardState": $"Rival/RivalDeck".cardState.duplicate(),
			"cardObj": null
		}, false)
		
	$"Rival/RivalDeck".drawToHandSize()
