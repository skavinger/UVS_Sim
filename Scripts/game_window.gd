extends Node2D

var host = false

func _ready() -> void:
	Server.rpc_id(1, "checkIfGameReady")
	$InputManager.call_deferred("playerLoaded")
	$InputManager.call_deferred("rivalLoaded")

func setAsHost():
	host = true

func setUpGame():
	if host:
		host_setup()
	else:
		client_setup()

func host_setup():
	call_deferred("initPlayerData")
	call_deferred("initDecks")
	call_deferred("initCharacters")
	call_deferred("determinFirst")

func client_setup():
	call_deferred("initPlayerData")
	call_deferred("initDecks")
	call_deferred("initCharacters")

func initPlayerData():
	$"../..".rpc_id(1, "setRivalPlayerData", $"../..".playerData)

func initDecks():
	$"Player/Deck".setUpPlayerDeck()

func initCharacters():
	var startingCharacter = $"Player/Deck".decklist.character.cardID
	$"Player/Transit".move_to("character", {
			"cardID": startingCharacter,
			"indexID": -1,
			"cardProperties": CardDatabase.getCard(startingCharacter),
			"cardState": $"Player/Deck".defaultCardState.duplicate(),
			"cardObj": null
		}, true)
	$"SyncFunctions".setPlayerHealth($"Player/Stage".starting_character.cardProperties.Health)
	$"Player/Stage".starting_character.cardState.faceup = true
	$"Player/Stage".starting_character.cardState.maxHealth = $"Player/Stage".starting_character.cardProperties.Health

func determinFirst():
	var first = randi()
	if first % 2 == 0:
		$"Field/TurnSequence".setFirst(true)
	else:
		$"Field/TurnSequence".setFirst(false)

func leaveGame():
	Server.rpc_id(1, "gameLeft")
	$"../../ConnectWindowHolder".spawnWindow()
	$"..".closeWindow()
