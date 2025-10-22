extends Control

var filter = {
	"format": "",
	"sets": []
}

func _ready() -> void:
	var formats = CardDatabase.getFormats()
	for i in range(formats.size()):
		$Formats.get_popup().add_item(formats[i])
	$Formats.get_popup().id_pressed.connect(_format_selected)
	
	var sets = CardDatabase.getSets()
	for i in range(sets.size()):
		$Sets.get_popup().add_check_item(sets[i])
	$Sets.get_popup().hide_on_checkable_item_selection = false
	$Sets.get_popup().id_pressed.connect(_sets_selected)

func _format_selected(id):
	var formatName = $Formats.get_popup().get_item_text(id)
	filter.format = formatName
	$Formats.text = formatName
	var formatList = CardDatabase.getFormat(formatName)
	$Sets.get_popup().clear()
	for i in range(formatList.size()):
		$Sets.get_popup().add_check_item(formatList[i])
	
func _sets_selected(id):
	var setName = $Sets.get_popup().get_item_text(id)
	if $Sets.get_popup().is_item_checked(id):
		$Sets.get_popup().set_item_checked(id, false)
		for i in range(filter.sets.size()):
			if filter.sets[i] == setName:
				filter.sets.remove_at(i)
				break
	else:
		$Sets.get_popup().set_item_checked(id, true)
		filter.sets.append(setName)
