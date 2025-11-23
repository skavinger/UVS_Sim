extends Control

var cardMeta
var ability
var isKeyword = false

var effectScript = null

func _on_play_pressed() -> void:
	cardMeta.cardObj.cardFlash()
	if effectScript != null:
		effectScript.payCosts($"../../../..")
		effectScript.resolveEffect($"../../../..")
	var publicMessage = ""
	if isKeyword:
		publicMessage = "Played Keyword ability on " + cardMeta.cardProperties.Name + " in " + cardMeta.cardState.currentZone + ". " + ability.text 
	elif ability.Type != "Static":
		publicMessage = "Played ability from " + cardMeta.cardProperties.Name + " in " + cardMeta.cardState.currentZone + ". "
		if(ability.Type.contains("Enhance")):
			publicMessage = publicMessage + "[color=orange]" + ability.Type + "[/color] "
		elif(ability.Type.contains("Response")):
			publicMessage = publicMessage + "[color=green]" + ability.Type + "[/color] "
		elif(ability.Type.contains("Form")):
			publicMessage = publicMessage + "[color=lightblue]" + ability.Type + "[/color] "
		elif(ability.Type.contains("Blitz")):
			publicMessage = publicMessage + "[color=pink]" + ability.Type + "[/color] "
		publicMessage = publicMessage + " " + ability.Cost + ": " + ability.Effect 
	else:
		publicMessage = "Triggered Static on " + cardMeta.cardProperties.Name + " in " + cardMeta.cardState.currentZone + ". " + ability.Effect 
	$"../../../Chat".addGameEventToLog(publicMessage, publicMessage)
	$"../..".hideWindow()
