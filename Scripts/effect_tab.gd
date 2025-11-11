extends Control

var cardMeta
var ability

func _on_play_pressed() -> void:
	cardMeta.cardObj.cardFlash()
	var publicMessage = "Played ability from " + cardMeta.cardProperties.Name + " in " + cardMeta.cardState.currentZone + ". "
	if(ability.Type.contains("Enhance")):
		publicMessage = publicMessage + "[color=orange]" + ability.Type + "[/color] "
	elif(ability.Type.contains("Response")):
		publicMessage = publicMessage + "[color=green]" + ability.Type + "[/color] "
	elif(ability.Type.contains("Form")):
		publicMessage = publicMessage + "[color=lightblue]" + ability.Type + "[/color] "
	elif(ability.Type.contains("Blitz")):
		publicMessage = publicMessage + "[color=pink]" + ability.Type + "[/color] "
	publicMessage = publicMessage + " " + ability.Cost + ": " + ability.Effect 
	$"../../../Chat".addGameEventToLog(publicMessage, publicMessage)
	$"../..".hideWindow()
