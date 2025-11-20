extends Node2D

var lastCallback

func setPlayerHealth(health):
	$"../Field/PlayerHealth/Label".text = str(int(health))
	rpc_id(1, "syncHealth", health)
	
@rpc("any_peer")
func syncHealth(health):
	$"../Field/RivalHealth/Label".text = str(int(health))

func gainHealth(amount):
	var maxHP = $"../Player/Stage".starting_character.cardState.maxHealth
	var current = int($"../Field/PlayerHealth/Label".text)
	
	if current + amount > maxHP:
		setPlayerHealth(maxHP)
	else:
		setPlayerHealth(current + amount)

func loseHealth(amount):
	var current = int($"../Field/PlayerHealth/Label".text)
	
	if current - amount < 0:
		setPlayerHealth(0)
	else:
		setPlayerHealth(current - amount)

func promptRival(message, callback):
	lastCallback = callback
	$"../Field/Message".displayMessage("Waiting For Rival Reply")
	$"../Field/Message".hideButtons()
	rpc_id(1, "sendMessageToRival", message)

@rpc("any_peer")
func sendMessageToRival(message):
	$"../Field/Message".displayMessage(message)

@rpc("any_peer")
func sendRivalMessageReply(answer):
	$"../Field/Message".hideMessage()
	$"../Field/Message".showButtons()
	lastCallback.call(answer)
