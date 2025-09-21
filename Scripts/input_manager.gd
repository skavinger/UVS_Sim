extends Node2D

var cardMan
var transitZone

var obj_selected

func _ready() -> void:
	cardMan = $"../CardManager"
	transitZone = $"../Transit"

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var new_obj = raycast_at_curser()
			if new_obj != null and new_obj.objType == "button":
				new_obj.get_parent().get_parent().call_fun(new_obj.button_type)
			else:
				if obj_selected:
					match obj_selected.objType:
						"card":
							if(cardMan.selected_card != null):
								cardMan.card_unselected()
						"deck":
							transitZone.deckZone.deck_unselected()
				obj_selected = new_obj
				if obj_selected:
					match obj_selected.objType:
						"card":
							cardMan.card_selected(obj_selected)
						"deck":
							transitZone.deckZone.deck_selected()

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
