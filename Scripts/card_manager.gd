extends Node2D

const CARD_SCENE_PATH = "res://GameObj/Card.tscn"

var selected_card
var screen_size
var is_hovering

var inputMan
var transitZone
var cardDatabase

func _ready() -> void:
	screen_size = get_viewport_rect().size
	inputMan = $"../InputManager"
	transitZone = $"../Transit"
	cardDatabase = preload("res://Scripts/card_database.gd")
	
func spawn_card(card):
	var new_card = preload(CARD_SCENE_PATH).instantiate()
	self.add_child(new_card)
	new_card.get_node("CardFront").texture = load("res://Assets/Sets/" + card.cardID.set + "/" + card.cardID.number + ".jpg")
	new_card.setMeta(card)
	return new_card
	
func despwan_card(card):
	self.remove_child(card)

func card_selected(card):
	card.get_node("Buttons").visible = true
	if !card or card == selected_card:
		card_unselected()
	elif selected_card:
		card_unselected()
		selected_card = card
		selected_card.position = Vector2(selected_card.position.x, selected_card.position.y - 20)
	else:
		selected_card = card
		selected_card.position = Vector2(selected_card.position.x, selected_card.position.y - 20)
	
func card_unselected():
	selected_card.get_node("Buttons").visible = false
	selected_card.position = Vector2(selected_card.position.x, selected_card.position.y + 20)
	selected_card = null

func connect_card_signals(card):
	card.connect("hovered", on_hovered_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_card(card):
	if inputMan.raycast_at_curser() == card:
		is_hovering = true
		highlight_card(card, true)
	else:
		highlight_card(card, false)
	
func on_hovered_off_card(card):
	highlight_card(card, false)
	var new_card_hovered = inputMan.raycast_at_curser()
	if new_card_hovered:
		highlight_card(new_card_hovered, true)
	else:
		is_hovering = false
	
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05,1.05)
	else:
		card.scale = Vector2(1,1)
