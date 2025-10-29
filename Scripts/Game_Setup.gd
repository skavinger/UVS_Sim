extends Node2D


func host_setup():
	call_deferred("initDecks")
	call_deferred("initCharacters")
	call_deferred("startingHands")
	
func client_setup():
	call_deferred("initDecks")
	call_deferred("initCharacters")
	call_deferred("startingHands")
	

func initDecks():
	$"Player/Deck".setUpPlayerDeck()

func initCharacters():
	var startingCharacter = $"Player/Deck".decklist.character.cardID
	$"Player/Transit".move_to("character", {
			"cardID": startingCharacter,
			"cardProperties": CardDatabase.getCard(startingCharacter),
			"cardState": $"Player/Deck".defaultCardState.duplicate(),
			"cardObj": null
		}, false)
	$"../SyncFunctions".setPlayerHealth($"Player/Stage".starting_character.cardProperties.Health)
	$"Player/Stage".starting_character.cardState.maxHealth = $"Player/Stage".starting_character.cardProperties.Health

func startingHands():
	$"Player/Deck".drawToHandSize()
