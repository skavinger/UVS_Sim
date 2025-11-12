extends Node2D

const objType = "searchBox"

const SEARCHABLE_CARD_SCENE_PATH = "res://GameObj/CardObjs/cardSearchOption.tscn"

var zoneBeingSearched

func displaySearchBox(cardsToSearch, zone, buttons):
	zoneBeingSearched = zone
	$Label.text = "Searching " + zone + "..."
	var searchTargets = $Control/ScrollContainer/HBoxContainer.get_children()
	for i in range(searchTargets.size()):
		$Control/ScrollContainer/HBoxContainer.remove_child(searchTargets[i])
	
	for i in range(cardsToSearch.size()):
		var searchable = preload(SEARCHABLE_CARD_SCENE_PATH).instantiate()
		$Control/ScrollContainer/HBoxContainer.add_child(searchable)
		searchable.get_node("TextureRect").texture = CardDatabase.get_card_art(cardsToSearch[i].cardID)
		searchable.get_node("RichTextLabel").text = cardsToSearch[i].cardProperties.Name
		searchable.set_buttons(cardsToSearch[i], buttons)
		searchable.setMeta(cardsToSearch[i])
	self.z_index = 1000
	$Area2D/CollisionShape2D.disabled = false
	
func hideSearchBox():
	zoneBeingSearched = null
	self.z_index = -1000
	$Area2D/CollisionShape2D.disabled = true
	
func dectectChange(contentsOfZone, zone, buttons):
	if(zoneBeingSearched == zone):
		displaySearchBox(contentsOfZone, zone, buttons)
