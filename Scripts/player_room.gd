extends Control

var creatorPlayerID

func setPlayerName(playerName):
	$PlayerName.text = playerName

func disableUI():
	$Button.disabled = true
	
func enableUI():
	$Button.disabled = false

func disableRoom():
	$Button.disabled = true
	$Format.append_text("[color=red]Missing data[/color]")

func _on_button_pressed() -> void:
	$"../../../.."._on_join_pressed(creatorPlayerID)
