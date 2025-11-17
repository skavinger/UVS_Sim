extends Control

var creatorPlayerID

func setPlayerName(playerName):
	$PlayerName.text = playerName

func disableUI():
	$Button.disabled = true
	
func enableUI():
	$Button.disabled = false

func _on_button_pressed() -> void:
	$"../../../.."._on_join_pressed(creatorPlayerID)
