extends Node2D

const PATH_TO_TAB = "res://GameObj/GameWindow/EffectTab.tscn"

var card
var ability

func displayWindow():
	self.position = Vector2(0,0)

func hideWindow():
	self.position = Vector2(2000,0)

func populateWindow(cardMeta):
	var oldEffects = $EffectList.get_children()
	for i in range(oldEffects.size()):
		$EffectList.remove_child(oldEffects[i])
	
	for i in range(cardMeta.cardProperties.Abilities.size()):
		var tab = preload(PATH_TO_TAB).instantiate()
		tab.cardMeta = cardMeta
		tab.ability = cardMeta.cardProperties.Abilities[i]
		$WindowTitle.text = "Abilities of " + cardMeta.cardProperties.Name
		
		var textbox = tab.get_child(0)
		if(cardMeta.cardProperties.Abilities[i].Type.contains("Enhance")):
			textbox.append_text("[color=orange]" + cardMeta.cardProperties.Abilities[i].Type + "[/color] ")
		elif(cardMeta.cardProperties.Abilities[i].Type.contains("Response")):
			textbox.append_text("[color=green]" + cardMeta.cardProperties.Abilities[i].Type + "[/color] ")
		elif(cardMeta.cardProperties.Abilities[i].Type.contains("Form")):
			textbox.append_text("[color=lightblue]" + cardMeta.cardProperties.Abilities[i].Type + "[/color] ")
		elif(cardMeta.cardProperties.Abilities[i].Type.contains("Blitz")):
			textbox.append_text("[color=pink]" + cardMeta.cardProperties.Abilities[i].Type + "[/color] ")
		textbox.append_text(" " + cardMeta.cardProperties.Abilities[i].Cost + ": " + cardMeta.cardProperties.Abilities[i].Effect)
		
		tab.name =  cardMeta.cardProperties.Abilities[i].Type
		$EffectList.add_child(tab)
