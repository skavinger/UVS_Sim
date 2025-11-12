extends Control

func setPlayerName(playerName):
	$PlayerName.text = playerName

func disableUI():
	$Button.disabled = true
