extends Node2D

const objType = "cardInspector"
const INSPECTORWIDTH = 365
const INSPECTORHEIGHT = 579


var expandedV = false
var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func showInspector(card):
	if card.cardObj.objType == "card" or card.cardState.faceup == true:
		self.z_index = 1000
		self.get_node("Card").texture = CardDatabase.get_card_art(card.cardID)
		genCardText(self.get_node("TextArea/ScrollContainer/Cardtext"), card)
	
func hideInspector():
	self.z_index = -1000
	self.get_node("TextArea/ScrollContainer/Cardtext").text = ""

func genCardText(textbox, card):
	textbox.append_text(card.cardProperties.Name + "\n")
	
	if(card.cardProperties.Cardtype == "Character"):
		textbox.append_text("[color=purple]")
	elif(card.cardProperties.Cardtype == "Action"):
		textbox.append_text("[color=blue]")
	elif(card.cardProperties.Cardtype == "Asset"):
		textbox.append_text("[color=green]")
	elif(card.cardProperties.Cardtype == "Attack"):
		textbox.append_text("[color=orange]")
	elif(card.cardProperties.Cardtype == "Backup"):
		textbox.append_text("[color=pink]")
	elif(card.cardProperties.Cardtype == "Foundation"):
		textbox.append_text("[color=grey]")
	textbox.append_text(card.cardProperties.Cardtype + "[/color]\n")
	
	if(card.cardProperties.Difficulty != null):
		textbox.append_text("Difficulty: " + str(int(card.cardProperties.Difficulty)) + " | " + "Check: " + str(int(card.cardProperties.Check)) + "\n")
	
	if(card.cardProperties.HandSize != null):
		textbox.append_text("Hand Size: " + str(int(card.cardProperties.HandSize)) + " | " + "Health: " + str(int(card.cardProperties.Health)) + "\n")
	
	if(card.cardProperties.BlockZone != null):
		textbox.append_text("Block Zone: " + card.cardProperties.BlockZone + " | " + "Block Modifier: " + str(int(card.cardProperties.BlockMod)) + "\n")
	
	if(card.cardProperties.AttackZone != null):
		textbox.append_text("Speed: " + str(int(card.cardProperties.Speed)) + " | " + "Zone: " + card.cardProperties.AttackZone + " | " + "Damage: " + str(int(card.cardProperties.Damage)) + "\n")
	
	for i in range(card.cardProperties.Keywords.size()):
		var keywordAbilities = CardDatabase.getKeywordAbilities()
		var color = ""
		for j in range(keywordAbilities.size()):
			if card.cardProperties.Keywords[i].Name.contains(keywordAbilities[j].Name):
				color = keywordAbilities[j].color
		if(color != ""):
			textbox.append_text("[color=" + color + "]")
		textbox.append_text(card.cardProperties.Keywords[i].Name)
		if(card.cardProperties.Keywords[i].Rating != null):
			textbox.append_text(" " + str(int(card.cardProperties.Keywords[i].Rating)))
		if(color != ""):
			textbox.append_text("[/color]")
		if(i + 1 != card.cardProperties.Keywords.size()):
			textbox.append_text(" | ")
	
	textbox.append_text("\n\n")
	for i in range(card.cardProperties.Abilities.size()):
		if(card.cardProperties.Abilities[i].Type.contains("Static")):
			textbox.append_text(card.cardProperties.Abilities[i].Effect + "\n\n")
		else:
			if(card.cardProperties.Abilities[i].Type.contains("Enhance")):
				textbox.append_text("[color=orange]" + card.cardProperties.Abilities[i].Type + "[/color] ")
			elif(card.cardProperties.Abilities[i].Type.contains("Response")):
				textbox.append_text("[color=green]" + card.cardProperties.Abilities[i].Type + "[/color] ")
			elif(card.cardProperties.Abilities[i].Type.contains("Form")):
				textbox.append_text("[color=lightblue]" + card.cardProperties.Abilities[i].Type + "[/color] ")
			elif(card.cardProperties.Abilities[i].Type.contains("Blitz")):
				textbox.append_text("[color=pink]" + card.cardProperties.Abilities[i].Type + "[/color] ")
			
			if(card.cardProperties.Abilities[i].Cost != null):
				textbox.append_text(card.cardProperties.Abilities[i].Cost + ": ")
			else:
				textbox.append_text(": ")
			textbox.append_text(card.cardProperties.Abilities[i].Effect + "\n\n")
		
func checkKeywordColor(keyword):
	if(keyword.contains("Stun") or 
	keyword.contains("Powerful") or
	keyword.contains("Ex") or 
	keyword.contains("Multiple") or 
	keyword.contains("Gauge")):
		return "orange"
	elif(keyword.contains("Echo") or
	keyword.contains("Breaker") or
	keyword.contains("Deflect") or
	keyword.contains("Reversal")):
		return "green"
	elif(keyword.contains("Combo") or
	keyword.contains("Desperation") or
	keyword.contains("Elusive") or
	keyword.contains("Flash") or
	keyword.contains("Only") or 
	keyword.contains("Safe")or 
	keyword.contains("Shift") or 
	keyword.contains("Terrain") or 
	keyword.contains("Throw") or 
	keyword.contains("Unique")):
		return "lightblue"
	elif(keyword.contains("Frenzy") or
	keyword.contains("Tension")):
		return "pink"
	return ""
		
