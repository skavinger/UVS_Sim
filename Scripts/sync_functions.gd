extends Node2D

func setPlayerHealth(health):
	$"../Game/Field/PlayerHealth/Label".text = str(int(health))
	rpc_id(1, "syncHealth", health)
	
@rpc("any_peer")
func syncHealth(health):
	$"../Game/Field/RivalHealth/Label".text = str(int(health))

func gainHealth(amount):
	var maxHP = $"../Game/Player/Stage".starting_character.cardState.maxHealth
	var current = int($"../Game/Field/PlayerHealth/Label".text)
	
	if current + amount > maxHP:
		setPlayerHealth(maxHP)
	else:
		setPlayerHealth(current + amount)

func loseHealth(amount):
	var current = int($"../Game/Field/PlayerHealth/Label".text)
	
	if current - amount < 0:
		setPlayerHealth(0)
	else:
		setPlayerHealth(current - amount)
