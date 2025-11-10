extends Node2D

var cardMan
var rivalCardMan
var transitZone
var rivalTransitZone

var obj_selected

func playerLoaded():
	cardMan = $"../Game/Player/CardManager"
	transitZone = $"../Game/Player/Transit"

func rivalLoaded():
	rivalCardMan = $"../Game/Rival/RivalCardManager"
	rivalTransitZone = $"../Game/Rival/RivalTransit"

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var new_obj = raycast_at_curser()
			if new_obj != null and new_obj.objType == "button":
				new_obj.get_parent().get_parent().call_fun(new_obj.button_type)
			elif new_obj != null and new_obj.objType == "searchBoxButton":
				new_obj.get_parent().get_parent().call_fun(new_obj.button_type)
			elif new_obj != null and new_obj.objType == "cardInspector":
				new_obj.toggleInspector()
			elif new_obj != null and new_obj.objType == "trackerArrows":
				new_obj.toggleTracker()
			elif new_obj != null and (new_obj.objType == "high" or 
			new_obj.objType == "mid" or 
			new_obj.objType == "low"):
				new_obj.changeZone()
			elif new_obj != null and new_obj.objType == "trackerValueAdjuster":
				new_obj.adjstValue()
			elif new_obj != null and new_obj.objType == "closeEffectWindow":
				new_obj.hideWindow()
			else:
				if obj_selected:
					match obj_selected.objType:
						"card":
							if(cardMan.selected_card != null):
								cardMan.card_unselected()
						"rival_card":
							if(rivalCardMan.selected_card != null):
								rivalCardMan.card_unselected()
						"deck":
							transitZone.deckZone.deck_unselected()
						"discard":
							transitZone.discardZone.discard_unselected()
						"removed":
							transitZone.removedZone.removed_unselected()
						"searchBoxCard":
							if(cardMan.selected_card != null):
								cardMan.search_card_unselected()
						"rival_deck":
							rivalTransitZone.deckZone.deck_unselected()
						"rival_discard":
							rivalTransitZone.discardZone.discard_unselected()
						"rival_removed":
							rivalTransitZone.removedZone.removed_unselected()
				obj_selected = new_obj
				if obj_selected:
					match obj_selected.objType:
						"card":
							cardMan.card_selected(obj_selected)
						"rival_card":
							rivalCardMan.card_selected(obj_selected)
						"deck":
							transitZone.deckZone.deck_selected()
						"discard":
							transitZone.discardZone.discard_selected()
						"removed":
							transitZone.removedZone.removed_selected()
						"searchBoxCard":
							cardMan.search_card_selected(obj_selected)
						"searchBox":
							transitZone.cardSearch.hideSearchBox()
						"rival_deck":
							rivalTransitZone.deckZone.deck_selected()
						"rival_discard":
							rivalTransitZone.discardZone.discard_selected()
						"rival_removed":
							rivalTransitZone.removedZone.removed_selected()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			var new_obj = raycast_at_curser()
			if new_obj != null and new_obj.objType == "AdvancePhaseTracker":
				$"../Game/Field/TurnSequence".advancePhase()
			elif new_obj != null and new_obj.objType == "RevertPhaseTracker":
				$"../Game/Field/TurnSequence".revertPhase()
			elif new_obj != null and new_obj.objType == "StartAttackSeq":
				$"../Game/Field/TurnSequence".startAttackSeq()

func raycast_at_curser():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var results = space_state.intersect_point(parameters)
	if results.size() > 0:
		return get_obj_with_highest_index(results)
	return null


func get_obj_with_highest_index(objs):
	var highest_z_obj = objs[0].collider.get_parent()
	for i in range(1, objs.size()):
		if objs[i].collider.get_parent().z_index > highest_z_obj.z_index:
			highest_z_obj = objs[i].collider.get_parent()
	return highest_z_obj
