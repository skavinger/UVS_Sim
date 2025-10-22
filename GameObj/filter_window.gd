extends Control

var filter = {
	"format": ""
}

func _ready() -> void:
	var formats = CardDatabase.getFormats()
	for i in range(formats.size()):
		$Formats.get_popup().add_item(formats[i])
	$Formats.get_popup().id_pressed.connect(_format_selected)

func _format_selected(id):
	var format = $Formats.get_popup().get_item_text(id)
	filter.format = format
	$Formats.text = format
