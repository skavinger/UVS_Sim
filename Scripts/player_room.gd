extends Control

var creatorPlayerID

func setPlayerName(playerName):
	$PlayerName.text = playerName

func disableUI():
	$Button.disabled = true
	
func enableUI():
	$Button.disabled = false

func setFormat(format):
	$Format.text = ""
	if format == "Missing Cards":
		$Button.disabled = true
		$Format.append_text("[color=red]Missing data[/color]")
	elif format == "Decklist Invalid":
		$Button.disabled = true
		$Format.append_text("[color=red]Decklist Format Error[/color]")
	else:
		$Format.append_text(format)

func _on_button_pressed() -> void:
	$"../../../.."._on_join_pressed(creatorPlayerID)
