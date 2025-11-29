extends Control

const GreenCheck = "res://Assets/GreenCheck.png"
const YellowBang = "res://Assets/YellowBang.png"
const RedX = "res://Assets/Red_X.png.png"

const type = "spacer"
var formatSets = []

func setName(formatName):
	$FormatName.text = formatName

func disableButton():
	$Update_Download.disabled = true
	$Update_Download.text = "Up to Date"

func _on_update_download_pressed() -> void:
	$Update_Download.disabled = true
	$Update_Download.text = "Processing"
	$"../../../..".downloadSubSet(formatSets)
