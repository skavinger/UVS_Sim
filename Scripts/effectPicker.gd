extends Node2D

const PATH_TO_TAB = "res://GameObj/EffectTab.tscn"

func displayWindow():
	self.z_index = 1000

func hideWindow():
	self.z_index = -1000

func populateWindow(cardName, listOfEffects):
	var oldEffects = $EffectList.get_children()
	for i in range(oldEffects.size()):
		$EffectList.remove_child(oldEffects[i])
	for i in range(listOfEffects.size()):
		var tab = preload(PATH_TO_TAB).instantiate()
		$WindowTitle.text = "Abilities of " + cardName
		
		var textbox = tab.get_child(0)
		if(listOfEffects[i].Type.contains("Enhance")):
			textbox.append_text("[color=orange]" + listOfEffects[i].Type + "[/color] ")
		elif(listOfEffects[i].Type.contains("Response")):
			textbox.append_text("[color=green]" + listOfEffects[i].Type + "[/color] ")
		elif(listOfEffects[i].Type.contains("Form")):
			textbox.append_text("[color=lightblue]" + listOfEffects[i].Type + "[/color] ")
		elif(listOfEffects[i].Type.contains("Blitz")):
			textbox.append_text("[color=pink]" + listOfEffects[i].Type + "[/color] ")
		
		tab.name =  listOfEffects[i].Type
		textbox.append_text(" " + listOfEffects[i].Cost + ": " + listOfEffects[i].Effect)
		$EffectList.add_child(tab)
