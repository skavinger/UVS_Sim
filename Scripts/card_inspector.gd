extends Node2D

const objType = "cardInspector"
const INSPECTORWIDTH = 365

var expanded = true
var animationMan

func _ready() -> void:
	animationMan = $"../AnimationManager"

func toggleInspector():
	if expanded:
		expanded = false
		$Arrows.rotation = 0
		animationMan.animate_card_to_pos(self, Vector2(self.position.x - INSPECTORWIDTH, self.position.y))
	else:
		expanded = true
		$Arrows.rotation = PI
		animationMan.animate_card_to_pos(self, Vector2(self.position.x + INSPECTORWIDTH, self.position.y))

func showInspector(card):
	self.z_index = 1000
	self.get_node("Card").texture = load("res://Assets/Sets/" + card.cardID.set + "/" + card.cardID.number + ".jpg")
	genCardText(self.get_node("ScrollContainer/Cardtext"), card)
	
func hideInspector():
	self.z_index = -1000
	self.get_node("ScrollContainer/Cardtext").text = ""

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
		textbox.append_text("Difficulty: " + str(card.cardProperties.Difficulty) + " | " + "Check: " + str(card.cardProperties.Check) + "\n")
	
	if(card.cardProperties.HandSize != null):
		textbox.append_text("Hand Size: " + str(card.cardProperties.HandSize) + " | " + "Health: " + str(card.cardProperties.Health) + "\n")
	
	if(card.cardProperties.BlockZone != null):
		textbox.append_text("Block Zone: " + card.cardProperties.BlockZone + " | " + "Block Modifier: " + str(card.cardProperties.BlockMod) + "\n")
	
	if(card.cardProperties.AttackZone != null):
		textbox.append_text("Speed: " + str(card.cardProperties.Speed) + " | " + "Zone: " + card.cardProperties.AttackZone + " | " + "Damage: " + str(card.cardProperties.Damage) + "\n")
	
	for i in range(card.cardProperties.Keywords.size()):
		var color = checkKeywordColor(card.cardProperties.Keywords[i].Name)
		if(color != ""):
			textbox.append_text("[color=" + color + "]")
		textbox.append_text(card.cardProperties.Keywords[i].Name)
		if(card.cardProperties.Keywords[i].Rating != null):
			textbox.append_text(" " + str(card.cardProperties.Keywords[i].Rating))
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
		
