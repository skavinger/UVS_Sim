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
	
	
	var rivalStartingCharacter = $Rival.get_node("RivalDeck").decklist.character.cardID
	$"Rival/RivalTransit".move_to("character", "character", {
			"cardID": rivalStartingCharacter,
			"cardProperties": $"Rival/RivalDeck".card_database.CARDS[rivalStartingCharacter.set][rivalStartingCharacter.number],
			"cardState": $"Rival/RivalDeck".cardState.duplicate(),
			"cardObj": null
		}, false)
	

func startingHands():
	$"Player/Deck".drawToHandSize()
